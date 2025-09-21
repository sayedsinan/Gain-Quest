import 'package:flutter/material.dart';

class VideoPlayerPlaceholder extends StatelessWidget {
  const VideoPlayerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[900],
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_filled, color: Colors.white.withOpacity(0.8), size: 80),
               const  SizedBox(height: 16),
                Text('Live Stream Player', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  'Video streaming integration would go here',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.volume_up, color: Colors.white)),
                IconButton(onPressed: () {}, icon: Icon(Icons.fullscreen, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

