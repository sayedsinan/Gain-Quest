
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHeader extends StatelessWidget {
  final int messageCount;

  const ChatHeader({super.key, required this.messageCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Get.theme.colorScheme.outline.withOpacity(0.2))),
      ),
      child: Row(
        children: [
         const  Icon(Icons.chat, size: 20),
          const SizedBox(width: 8),
          Text(
            'Live Chat',
            style: Get.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        const   Spacer(),
          Text(
            '$messageCount messages',
            style: Get.theme.textTheme.bodySmall?.copyWith(color: Get.theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}