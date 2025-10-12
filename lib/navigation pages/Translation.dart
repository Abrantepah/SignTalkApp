import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signtalk/components/loadingPage.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/providers/sign2text.dart';
import 'package:signtalk/providers/text2sign.dart';

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  bool isSignToText = true;
  bool isRecording = false;
  bool _isChatRecording = false;
  bool _isCameraInitialized = false;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final TextEditingController _controller = TextEditingController();

  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  bool _isVideoReady = false;
  String? _videoUrl;

  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// 🎥 Initialize camera
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);

      print("📸 Camera initialized successfully!");
    } catch (e) {
      print("📷 Camera initialization error: $e");
    }
  }

  /// 🧹 Properly dispose or stop camera
  Future<void> _disposeCamera() async {
    try {
      if (_cameraController != null) {
        await _cameraController!.dispose();
        _cameraController = null;
        setState(() => _isCameraInitialized = false);
        print("🧹 Camera disposed.");
      }

      if (kIsWeb) {
        print("🌐 Web camera stream released.");
      }
    } catch (e) {
      print("⚠️ Camera dispose error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  /// 🎥 Load and play returned video
  Future<void> _loadVideo(String url) async {
    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(url);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      await _videoController!.play();

      setState(() {
        _isVideoReady = true;
        _videoUrl = url;
      });
    } catch (e) {
      print("🎥 Video load error: $e");
    }
  }

  /// 🧠 Send text to API
  Future<void> _sendMessage(TextToSignProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isSignToText = false; // 👈 Switch to Text → Sign
      _messages.add({"text": text, "isUser": true});
    });
    _controller.clear();

    await provider.sendText(text);

    if (provider.apiResponse != null) {
      final response = provider.apiResponse!;
      final videos = response['video_paths'];

      if (videos is List && videos.isNotEmpty) {
        await _loadVideo(videos.first);
      }

      setState(() {
        _messages.add({
          "text": "🧠 Translation ready below 👇",
          "isUser": false,
          "videoUrl": videos.isNotEmpty ? videos.first : null,
        });
      });
    } else {
      setState(() {
        _messages.add({
          "text": "❌ Sorry, no video found for this input.",
          "isUser": false,
        });
      });
    }
  }

  /// 🎤 Cross-platform audio recording start
  Future<void> _startAudioRecording() async {
    if (kIsWeb) {
      // Web doesn’t support path_provider — use a temp path name
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: 'recorded_audio.wav', // ✅ required even on web
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/recorded_audio.wav';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path, // ✅ required argument
      );
    }
  }

  /// 🎤 Record & Send Audio
  Future<void> _toggleChatRecording() async {
    final provider = Provider.of<TextToSignProvider>(context, listen: false);

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied.")),
        );
        return;
      }

      if (!_isChatRecording) {
        print("🎤 Starting recording...");
        await _startAudioRecording();
        setState(() => _isChatRecording = true);
      } else {
        print("🛑 Stopping recording...");
        final path = await _audioRecorder.stop();
        setState(() => _isChatRecording = false);

        if (path != null) {
          final audioFile = File(path);
          setState(() {
            _messages.add({
              "text": "🎧 Sending recorded message...",
              "isUser": true,
            });
          });

          await provider.sendAudio(audioFile);

          if (provider.apiResponse != null) {
            final response = provider.apiResponse!;
            final text = response["transcribed_text"] ?? "No transcription";
            final videoPaths = response["video_paths"] ?? [];

            if (videoPaths is List && videoPaths.isNotEmpty) {
              await _loadVideo(videoPaths.first);
            }

            setState(() {
              _messages.add({"text": "🗣 $text", "isUser": false});
            });
          }
        }
      }
    } catch (e) {
      print("⚠️ Recording error: $e");
    }
  }

  /// 🎬 Record & Send Video (Sign → Text)
  Future<void> _toggleVideoRecording() async {
    final provider = Provider.of<SignToTextProvider>(context, listen: false);

    try {
      if (!isRecording) {
        setState(() => isSignToText = true); // 👈 Switch to Sign → Text
        print("🎬 Starting recording...");
        await _cameraController?.startVideoRecording();
        setState(() => isRecording = true);
      } else {
        print("🛑 Stopping recording...");
        final file = await _cameraController?.stopVideoRecording();
        setState(() => isRecording = false);

        if (file != null) {
          final recordedFile = File(file.path);
          setState(() {
            _messages.add({
              "text": "📹 Sending recorded video...",
              "isUser": true,
            });
          });

          await _disposeCamera();
          await Future.delayed(const Duration(milliseconds: 500));
          await _initializeCamera();

          await provider.sendVideo(recordedFile);

          if (provider.apiResponse != null) {
            final response = provider.apiResponse!;
            final text = response["text"] ?? "No text recognized";
            setState(() {
              _messages.add({"text": "🧠 $text", "isUser": false});
            });
          }
        }
      }
    } catch (e) {
      print("⚠️ Video recording error: $e");
      await _disposeCamera();
      await _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextToSignProvider>(context);

    if (!_isCameraInitialized) {
      return const Scaffold(body: Center(child: LoadingScreen()));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // 👈 Left Panel (Camera View)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: Center(
                        child:
                            isRecording && _isCameraInitialized
                                ? CameraPreview(_cameraController!)
                                : const Image(
                                  image: AssetImage(
                                    "assets/images/signing.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSignToText
                                  ? Colors.green.shade700
                                  : Colors.deepPurple.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isSignToText
                              ? "Mode: Sign → Text"
                              : "Mode: Text → Sign",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    // 🎬 Record button (ALWAYS visible)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isRecording ? Colors.redAccent : Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          isRecording ? Icons.stop : Icons.fiber_manual_record,
                          color: Colors.white,
                        ),
                        label: Text(
                          isRecording ? "End Recording" : "Start Recording",
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: _toggleVideoRecording,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 👉 Right Panel (Chat + Output Video)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    "Chatbot",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg["isUser"] as bool;
                        final videoUrl = msg["videoUrl"];

                        return Align(
                          alignment:
                              isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isUser
                                      ? Colors.blueGrey.shade700
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["text"] ?? "",
                                  style: TextStyle(
                                    color:
                                        isUser ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (videoUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: VideoPlayer(
                                        VideoPlayerController.network(videoUrl),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onTap:
                              () => setState(
                                () => isSignToText = false,
                              ), // 👈 Switch
                          onSubmitted: (_) => _sendMessage(provider),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor:
                            _isChatRecording
                                ? Colors.redAccent
                                : Colors.blueGrey.shade700,
                        child: IconButton(
                          icon: Icon(
                            _isChatRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                          ),
                          onPressed: _toggleChatRecording,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade900,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () => _sendMessage(provider),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
