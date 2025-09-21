import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/chat_section.dart';
import 'package:gain_quest/presentation/widgets/stream_header.dart';
import 'package:gain_quest/presentation/widgets/video_player.dart';
import 'package:get/get.dart';
import 'package:gain_quest/presentation/controllers/live_controller.dart';

class LiveStreamDetailScreen extends StatefulWidget {
  final Map<String, dynamic> stream;

  const LiveStreamDetailScreen({super.key, required this.stream});

  @override
  _LiveStreamDetailScreenState createState() => _LiveStreamDetailScreenState();
}

class _LiveStreamDetailScreenState extends State<LiveStreamDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final LiveController liveController = Get.find<LiveController>();

  final List<Map<String, dynamic>> _chatMessages = [
    {
      'id': '1',
      'username': 'Alice Johnson',
      'message': 'Great progress team! 🚀',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': '2',
      'username': 'Bob Smith',
      'message': 'This is so exciting to watch live!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
    },
    {
      'id': '3',
      'username': 'Carol Wilson',
      'message': 'Betting on success for sure! 💪',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _chatMessages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'username': 'You',
          'message': _messageController.text.trim(),
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            StreamHeader(stream: widget.stream),
           const  Expanded(flex: 3, child: VideoPlayerPlaceholder()),
            Expanded(
              flex: 2,
              child: ChatSection(
                chatMessages: _chatMessages,
                chatScrollController: _chatScrollController,
                messageController: _messageController,
                onSend: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


