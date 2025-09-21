import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/chat_bubble.dart';
import 'package:gain_quest/presentation/widgets/chat_header.dart';
import 'package:gain_quest/presentation/widgets/messeage_input.dart';
import 'package:get/get.dart';

class ChatSection extends StatelessWidget {
  final List<Map<String, dynamic>> chatMessages;
  final ScrollController chatScrollController;
  final TextEditingController messageController;
  final VoidCallback onSend;

  const ChatSection({super.key, 
    required this.chatMessages,
    required this.chatScrollController,
    required this.messageController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.cardColor,
      child: Column(
        children: [
          ChatHeader(messageCount: chatMessages.length),
          Expanded(
            child: ListView.builder(
              controller: chatScrollController,
              padding:const  EdgeInsets.all(12),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                return ChatMessageBubble(
                  username: message['username'],
                  message: message['message'],
                  timestamp: message['timestamp'],
                );
              },
            ),
          ),
          MessageInput(controller: messageController, onSend: onSend),
        ],
      ),
    );
  }
}



/// Chat message bubble
