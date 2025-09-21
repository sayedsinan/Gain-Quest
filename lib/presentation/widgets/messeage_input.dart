import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Get.theme.colorScheme.outline.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Get.theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:const  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        const   SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: Get.theme.primaryColor, shape: BoxShape.circle),
            child: IconButton(
              onPressed: onSend,
              icon:const  Icon(Icons.send, color: Colors.white, size: 20),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
        ],
      ),
    );
  }
}
