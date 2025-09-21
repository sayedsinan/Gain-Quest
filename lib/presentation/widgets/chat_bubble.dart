import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageBubble extends StatelessWidget {
  final String username;
  final String message;
  final DateTime timestamp;

  const ChatMessageBubble({super.key, required this.username, required this.message, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    bool isOwnMessage = username == 'You';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnMessage)
            ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(Icons.person, size: 18, color: Get.theme.primaryColor),
              ),
             const  SizedBox(width: 8),
            ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOwnMessage ? Get.theme.primaryColor.withOpacity(0.1) : Get.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOwnMessage
                      ? Get.theme.primaryColor.withOpacity(0.3)
                      : Get.theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isOwnMessage
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 10, color: Get.theme.colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(message, style: Get.theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          if (isOwnMessage) const SizedBox(width: 40),
        ],
      ),
    );
  }
}


