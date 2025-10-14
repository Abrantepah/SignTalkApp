import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/loadingPage.dart';
import 'package:signtalk/providers/sign2text.dart';
import 'package:signtalk/providers/text2sign.dart';

class Translation extends StatefulWidget {
  final String? category;
  const Translation({super.key, this.category});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  bool isSignToText = true;
  bool isRecording = false;
  bool _isChatRecording = false;
  bool _isCameraInitialized = false;
  bool _initializingCamera = false;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final TextEditingController _controller = TextEditingController();

  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  bool _isVideoReady = false;
  bool _isVideoLoading = false;

  String backendBaseUrl = 'http://127.0.0.1:8000';
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// 🎥 Initialize Camera
  Future<void> _initializeCamera() async {
    if (_initializingCamera) return;
    setState(() => _initializingCamera = true);

    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() => _isCameraInitialized = true);
      print("📸 Camera initialized successfully!");
    } catch (e) {
      print("📷 Camera initialization error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Camera init error: $e")));
      }
    } finally {
      setState(() => _initializingCamera = false);
    }
  }

  /// 🧹 Dispose Camera
  Future<void> _disposeCamera() async {
    try {
      await _cameraController?.dispose();
      _cameraController = null;
      setState(() => _isCameraInitialized = false);
      print("🧹 Camera disposed.");
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

  /// 📹 Load Video from API
  Future<void> _loadVideo(String relativePath) async {
    try {
      setState(() => _isVideoLoading = true);

      final fullUrl = backendBaseUrl + relativePath;

      // Dispose camera before showing video
      if (_isCameraInitialized) {
        await _disposeCamera();
      }

      _videoController?.dispose();
      _videoController = VideoPlayerController.network(fullUrl);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      await _videoController!.play();

      setState(() {
        _isVideoReady = true;
        _isVideoLoading = false;
      });
    } catch (e) {
      print("🎥 Video load error: $e");
      setState(() => _isVideoLoading = false);
    }
  }

  /// ✍️ Send Text (Text → Sign)
  Future<void> _sendMessage(TextToSignProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isSignToText = false;
      _messages.add({"text": text, "isUser": true});
    });
    _controller.clear();

    await provider.sendText(text);

    if (provider.apiResponse != null) {
      final response = provider.apiResponse!;
      final videos = response['video_paths'] ?? [];
      final avatars = response['avatar_paths'] ?? [];

      if (videos.isNotEmpty) {
        await _loadVideo(videos.first);
      } else if (avatars.isNotEmpty) {
        await _loadVideo(avatars.first);
      }

      setState(() {
        _messages.add({"text": "Translation ready!", "isUser": false});
      });
    }
  }

  /// 🎙️ Start Audio Recording
  Future<void> _startAudioRecording() async {
    if (kIsWeb) {
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: 'recorded_audio.wav',
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/recorded_audio.wav';
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path,
      );
    }
  }

  /// 🎙️ Toggle Chat Audio Recording
  Future<void> _toggleChatRecording() async {
    final provider = context.read<TextToSignProvider>();

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied.")),
        );
        return;
      }

      if (!_isChatRecording) {
        await _startAudioRecording();
        setState(() => _isChatRecording = true);
      } else {
        final path = await _audioRecorder.stop();
        setState(() => _isChatRecording = false);

        if (path != null) {
          dynamic audioFile;

          if (kIsWeb) {
            // Web: path is usually a blob URL, use XFile
            audioFile = XFile(path, mimeType: 'audio/wav');
          } else {
            // Mobile/Desktop: use normal File
            audioFile = io.File(path);
          }

          await provider.sendAudio(audioFile);

          if (provider.apiResponse != null) {
            final response = provider.apiResponse!;
            final videos = response['video_paths'] ?? [];
            final avatars = response['avatar_paths'] ?? [];

            if (videos.isNotEmpty) {
              await _loadVideo(videos.first);
            } else if (avatars.isNotEmpty) {
              await _loadVideo(avatars.first);
            }
            final text =
                provider.apiResponse!["transcribed_text"] ?? "No transcription";

            print('Transcribed Text: $text');
            setState(() => _messages.add({"text": "🗣 $text", "isUser": true}));
          }
        }
      }
    } catch (e) {
      print("⚠️ Audio recording error: $e");
    }
  }

  /// 🎬 Record & Send Video (Sign → Text)
  Future<void> _toggleVideoRecording() async {
    final provider = context.read<SignToTextProvider>();

    try {
      // Stop video playback if any
      if (_isVideoReady && _videoController != null) {
        await _videoController!.pause();
        await _videoController!.dispose();
        setState(() {
          _isVideoReady = false;
          _videoController = null;
        });

        await Future.delayed(const Duration(milliseconds: 300));
      }

      if (!_isCameraInitialized || _initializingCamera) {
        await _initializeCamera();
      }

      if (!isRecording) {
        setState(() => isSignToText = true);
        await _cameraController?.startVideoRecording();
        setState(() => isRecording = true);
        print("🎥 Recording started...");
      } else {
        final file = await _cameraController?.stopVideoRecording();
        setState(() => isRecording = false);
        print("🛑 Recording stopped.");

        if (file != null) {
          _messages.add({"text": "🎬 Sending video...", "isUser": true});

          // Dispose camera before sending
          await _disposeCamera();

          await provider.sendVideo(
            kIsWeb ? file : io.File(file.path),
            widget.category!,
          );

          if (provider.apiResponse != null) {
            final text =
                provider.apiResponse!["translation"] ?? "No text recognized";
            setState(() => _messages.add({"text": "$text", "isUser": false}));
          }

          // Reinitialize camera for next use
          await Future.delayed(const Duration(milliseconds: 500));
          await _initializeCamera();
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
    final provider = context.watch<TextToSignProvider>();

    if (!_isCameraInitialized && !_isVideoReady) {
      return const Scaffold(body: Center(child: LoadingScreen()));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // 👈 Left Panel (Camera / Video)
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
                        child: Builder(
                          builder: (context) {
                            if (isRecording && _isCameraInitialized) {
                              return CameraPreview(_cameraController!);
                            } else if (_isVideoReady &&
                                _videoController != null) {
                              return AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              );
                            } else if (_isCameraInitialized) {
                              return CameraPreview(_cameraController!);
                            } else {
                              return const Image(
                                image: AssetImage("assets/images/signing.png"),
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    if (_isVideoLoading)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Lottie.asset(
                            'assets/lotties/loading.json',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),

                    // Mode Label
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

                    // Record Button
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
                          isRecording ? "Stop Recording" : "Start Recording",
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed:
                            _initializingCamera ? null : _toggleVideoRecording,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 👉 Right Panel (Chat + Output)
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
                                      ? ColorsConstant.secondary
                                      : ColorsConstant.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg["text"] ?? "",
                              style: TextStyle(
                                color:
                                    isUser
                                        ? Colors.white
                                        : ColorsConstant.textColor,
                              ),
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
                          onTap: () => setState(() => isSignToText = false),
                          onSubmitted: (_) => _sendMessage(provider),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor:
                            _isChatRecording
                                ? Colors.redAccent
                                : ColorsConstant.secondary,
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
                        backgroundColor: ColorsConstant.extra,
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
