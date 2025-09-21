import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const AchievementBadge({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 20),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
