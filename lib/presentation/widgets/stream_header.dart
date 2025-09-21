import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/live_indicator.dart';
import 'package:get/get.dart';

class StreamHeader extends StatelessWidget {
  final Map<String, dynamic> stream;

  const StreamHeader({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon:const  Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream['title'] ?? 'Live Stream',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  stream['teamName'] ?? 'Unknown Team',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ),
          LiveIndicator(viewerCount: stream['viewerCount'] ?? 0),
        ],
      ),
    );
  }
}
