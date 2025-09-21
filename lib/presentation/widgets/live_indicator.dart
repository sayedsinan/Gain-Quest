import 'package:flutter/material.dart';

class LiveIndicator extends StatelessWidget {
  final int viewerCount;

  const LiveIndicator({super.key, required this.viewerCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
             const   SizedBox(width: 4),
              const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
       const  SizedBox(width: 8),
        Row(
          children: [
            const Icon(Icons.visibility, color: Colors.white, size: 16),
           const  SizedBox(width: 4),
            Text('$viewerCount', style:const  TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}