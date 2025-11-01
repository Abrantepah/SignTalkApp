// translation_demo_page.dart
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
import 'package:signtalk/components/toggle_button.dart';

// NOTE: This file expects the following to exist in your project:
// - AudioRecorder, RecordConfig, AudioEncoder (from 'record' package or your wrapper)
// - ApiConstants.baseMediaUrl
// - ColorsConstant.{secondary, accent, textColor, extra} (color palette)
// - CustomAppBar(), LoadingScreen()
// - TextToSignProvider and SignToTextProvider providers
// - assets/lotties/loading.json (for loading animation)
// - camera/video player dependencies set up in pubspec.yaml

class Translation extends StatefulWidget {
  final String? category;
  const Translation({super.key, this.category});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  // UI state
  bool isSignToText = true;
  bool isRecording = false;
  bool _isChatRecording = false;
  bool _isCameraInitialized = false;
  bool _initializingCamera = false;

  // Audio & text controllers
  final AudioRecorder _audioRecorder = AudioRecorder();
  final TextEditingController _controller = TextEditingController();

  // Camera & Video
  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  bool _isVideoReady = false;
  bool _isVideoLoading = false;

  // Chat messages (desktop)
  final List<Map<String, dynamic>> _messages = [];

  // Mobile simplified response area (single string, clears on next send)
  String? _mobileResponse;

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
    } catch (e) {
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
    } catch (e) {
      // ignore dispose errors
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

      final fullUrl = ApiConstants.baseMediaUrl + relativePath;

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
      setState(() => _isVideoLoading = false);
    }
  }

  /// ✍️ Send Text (Text → Sign)
  Future<void> _sendMessage(TextToSignProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Clear mobile response and add to desktop messages
    setState(() {
      _mobileResponse = null;
      isSignToText = false;
      _messages.add({"text": text, "isUser": true, "time": _timeStamp()});
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

      // Add desktop message + set mobile response to show single response on mobile
      setState(() {
        _messages.add({
          "text": "Translation ready!",
          "isUser": false,
          "time": _timeStamp(),
        });
        _mobileResponse = "Translation ready!";
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

            setState(() {
              _messages.add({
                "text": "🗣 $text",
                "isUser": true,
                "time": _timeStamp(),
              });
              _mobileResponse = "🗣 $text";
            });
          }
        }
      }
    } catch (e) {
      // ignore recording errors
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
        setState(() {
          isSignToText = true;
        });
        await _cameraController?.startVideoRecording();
        setState(() => isRecording = true);
      } else {
        final file = await _cameraController?.stopVideoRecording();
        setState(() => isRecording = false);

        if (file != null) {
          setState(() {
            _messages.add({
              "text": "🎬 Sending video...",
              "isUser": true,
              "time": _timeStamp(),
            });
            _mobileResponse = null;
          });

          // Dispose camera before sending
          await _disposeCamera();

          await provider.sendVideo(
            kIsWeb ? file : io.File(file.path),
            widget.category ?? '',
          );

          if (provider.apiResponse != null) {
            final text =
                provider.apiResponse!["translation"] ?? "No text recognized";
            setState(() {
              _messages.add({
                "text": "$text",
                "isUser": false,
                "time": _timeStamp(),
              });
              _mobileResponse = "$text";
            });
          }

          // Reinitialize camera for next use
          await Future.delayed(const Duration(milliseconds: 500));
          await _initializeCamera();
        }
      }
    } catch (e) {
      await _disposeCamera();
      await _initializeCamera();
    }
  }

  String _timeStamp() {
    final now = DateTime.now().toLocal();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    // Determine mobile vs desktop/tablet
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Watch provider for sendText/sendAudio responses
    final textToSignProvider = context.watch<TextToSignProvider>();

    // If nothing ready yet, show loading screen
    if (!_isCameraInitialized && !_isVideoReady) {
      return const Scaffold(body: Center(child: LoadingScreen()));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey.shade100,
      body:
          isMobile
              ? _buildMobileLayout(textToSignProvider)
              : _buildDesktopLayout(textToSignProvider),
    );
  }

  // ---------- Desktop Layout (two-column) ----------
  Widget _buildDesktopLayout(TextToSignProvider textToSignProvider) {
    return Row(
      children: [
        // LEFT SIDE (VIDEO + CONTROLS)
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Video area with padding & rounded corners
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Video / Camera / Placeholder
                        Positioned.fill(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black12,
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
                                      image: AssetImage(
                                        "assets/images/person.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        // Loading overlay (Lottie)
                        if (_isVideoLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.6),
                              child: Center(
                                child: Lottie.asset(
                                  'assets/lotties/loading.json',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                          ),

                        // Fullscreen button top-right
                        Positioned(
                          top: 20,
                          right: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: const Icon(Icons.fullscreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Call controls row (centered)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlCircle(
                      icon: _isChatRecording ? Icons.stop : Icons.mic,
                      color: _isChatRecording ? Colors.red : Colors.blue,
                      info:
                          _isChatRecording
                              ? "Stop Recording"
                              : "Start Speech to Sign Translation",
                      onTap: () {
                        _toggleChatRecording();
                      },
                    ),

                    const SizedBox(width: 20),

                    _controlCircle(
                      icon:
                          isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: isRecording ? Colors.red : Colors.green,
                      info:
                          isRecording
                              ? "Stop Recording"
                              : "Start Sign Language to Text Translation",
                      onTap: _initializingCamera ? null : _toggleVideoRecording,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // RIGHT SIDE (CHAT PANEL)
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey.shade300)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with title and toggle
                    // Header row with title and toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            "Chatbot",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: // Mode label bottom-left (from Translation)
                              Positioned(
                            left: 16,
                            bottom: 90,
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
                        ),
                      ],
                    ),

                    const Divider(height: 0.5, color: Colors.black12),

                    // Messages list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isUser
                                        ? ColorsConstant.secondary
                                        : ColorsConstant.accent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    isUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg["text"] ?? "",
                                    style: TextStyle(
                                      color:
                                          isUser
                                              ? Colors.white
                                              : ColorsConstant.textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    msg["time"] ?? "",
                                    style: TextStyle(
                                      color:
                                          isUser
                                              ? Colors.white70
                                              : Colors.black54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Input area (TextField with grey background, mic and send)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Type your message here...",
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onTap: () => setState(() => isSignToText = false),
                              onSubmitted:
                                  (_) => _sendMessage(
                                    context.read<TextToSignProvider>(),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: ColorsConstant.extra,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed:
                                  () => _sendMessage(
                                    context.read<TextToSignProvider>(),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Mobile Layout (video on top, simple chat below) ----------
  Widget _buildMobileLayout(TextToSignProvider textToSignProvider) {
    return Column(
      children: [
        // Video panel (top)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Video / Camera / Placeholder
                  Positioned.fill(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black12,
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
                                image: AssetImage("assets/images/person.jpg"),
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // Loading overlay (Lottie)
                  if (_isVideoLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Lottie.asset(
                            'assets/lotties/loading.json',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),

                  // Fullscreen button top-right
                  Positioned(
                    top: 20,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: const Icon(Icons.fullscreen),
                    ),
                  ),

                  // Mode label bottom-left
                  Positioned(
                    left: 16,
                    bottom: 20,
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
                ],
              ),
            ),
          ),
        ),

        // Controls row (compact for mobile)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controlCircle(
                icon: _isChatRecording ? Icons.stop : Icons.mic,
                color: _isChatRecording ? Colors.red : Colors.blue,
                info: _isChatRecording ? "Stop" : "Speech → Sign",
                onTap: () => _toggleChatRecording(),
              ),
              const SizedBox(width: 24),
              _controlCircle(
                icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
                color: isRecording ? Colors.red : Colors.green,
                info: isRecording ? "Stop" : "Sign → Text",
                onTap: _initializingCamera ? null : _toggleVideoRecording,
              ),
            ],
          ),
        ),

        // Mobile simple chat input area (not full chatbot)
        SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mobile response area (single response, disappears on next request)
                if (_mobileResponse != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _mobileResponse!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onTap: () => setState(() => isSignToText = false),
                        onSubmitted: (_) => _sendMessage(textToSignProvider),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: ColorsConstant.extra,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () => _sendMessage(textToSignProvider),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Reused control circle used in left panel and mobile controls
  Widget _controlCircle({
    required IconData icon,
    Color color = Colors.white,
    required String info,
    VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            info,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
