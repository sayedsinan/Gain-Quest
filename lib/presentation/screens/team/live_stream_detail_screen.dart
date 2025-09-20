import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/live_controller.dart';
import 'package:get/get.dart';

class LiveStreamDetailScreen extends StatefulWidget {
  final Map<String, dynamic> stream;

  const LiveStreamDetailScreen({Key? key, required this.stream})
      : super(key: key);

  @override
  _LiveStreamDetailScreenState createState() => _LiveStreamDetailScreenState();
}

class _LiveStreamDetailScreenState extends State<LiveStreamDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final LiveController liveController = Get.find<LiveController>();

  // Sample chat messages for demo
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'id': '1',
      'username': 'Alice Johnson',
      'message': 'Great progress team! 🚀',
      'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
    },
    {
      'id': '2',
      'username': 'Bob Smith',
      'message': 'This is so exciting to watch live!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 3)),
    },
    {
      'id': '3',
      'username': 'Carol Wilson',
      'message': 'Betting on success for sure! 💪',
      'timestamp': DateTime.now().subtract(Duration(minutes: 1)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Stream header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stream['title'] ?? 'Live Stream',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.stream['teamName'] ?? 'Unknown Team',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // TODO: Add video player + chat UI here
          ],
        ),
      ),
    );
  }
}
