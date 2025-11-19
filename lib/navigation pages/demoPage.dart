import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:signtalk/components/customAppBar.dart';

class Demopage extends StatefulWidget {
  const Demopage({super.key});

  @override
  State<Demopage> createState() => _DemopageState();
}

class _DemopageState extends State<Demopage> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();

    /// 🔹 Load video from your server (HTTP/HTTPS URL)
    _controller = VideoPlayerController.networkUrl(
      Uri.parse("${ApiConstants.baseMediaUrl}/media/videos/SigntalkDemo.mp4"),
    )
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.play(); // Auto-play
      })
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Format time (mm:ss or hh:mm:ss)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    return h > 0
        ? '${twoDigits(h)}:${twoDigits(m)}:${twoDigits(s)}'
        : '${twoDigits(m)}:${twoDigits(s)}';
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _showOverlay = true;
    });

    /// Auto-hide overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showOverlay = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _initialized
          ? Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// 🔹 VIDEO
                      GestureDetector(
                        onTap: () => setState(() => _showOverlay = !_showOverlay),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),

                      /// 🔹 CENTER PLAY/PAUSE OVERLAY
                      AnimatedOpacity(
                        opacity: _showOverlay ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 PROGRESS + TIME
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      /// TIME ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_controller.value.position),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            _formatDuration(_controller.value.duration),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      /// SEEK BAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.blue,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
