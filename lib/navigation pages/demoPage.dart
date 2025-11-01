import 'package:flutter/material.dart';
import 'package:signtalk/components/toggle_button.dart';

class Demopage extends StatelessWidget {
  const Demopage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          // LEFT SIDE (VIDEO + CONTROLS)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Video area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Video Container / Placeholder
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/person.jpg', // Replace with your video widget later
                                ),
                              ),
                            ),
                          ),

                          // Timer top-left
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: Colors.redAccent,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "24:01:45",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Fullscreen button top-right
                          Positioned(
                            top: 20,
                            right: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: Icon(Icons.fullscreen),
                            ),
                          ),

                          // Mic bottom-right small bubble
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Icon(Icons.mic, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Call controls row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controlButton(Icons.mic),
                      _controlButton(Icons.camera_alt),
                      // _controlButton(Icons.image),
                      _controlButton(
                        Icons.fiber_manual_record,
                        color: Colors.redAccent,
                      ),
                      // _controlButton(Icons.chat),
                      // _controlButton(Icons.more_horiz),
                    ],
                  ),
                ),

                // End Call
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.redAccent,
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 40, vertical: 15),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(30)),
                //     ),
                //     onPressed: () {},
                //     child: const Text(
                //       "End Call",
                //       style: TextStyle(fontSize: 16, color: Colors.white),
                //     ),
                //   ),
                // ),
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
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chat header
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: ToggleButtonDemo(),
                          ),
                        ],
                      ),

                      Divider(height: 0.5, color: Colors.black12),

                      // Chat messages
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            chatBubble(
                              "Oh, hello! All perfectly.\nI will check it and get back to you soon",
                              time: "04:45 PM",
                              isMe: false,
                            ),
                            chatBubble(
                              "Oh, hello! All perfectly.\nI will check it and get back to you soon",
                              time: "04:45 PM",
                              isMe: true,
                            ),
                            chatBubble(
                              "Oh, hello! All perfectly.\nI will check it and get back to you soon",
                              time: "04:45 PM",
                              isMe: false,
                            ),
                          ],
                        ),
                      ),

                      // Input area
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: "Type your message here...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.send, color: Colors.white),
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
      ),
    );
  }

  // UI Component: bottom control button
  Widget _controlButton(IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue.shade50,
        child: Icon(icon, color: color ?? Colors.black87, size: 28),
      ),
    );
  }

  // Chat bubble widget
  Widget chatBubble(String text, {required String time, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.lightBlue.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
