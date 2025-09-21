import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        Text(
          "John Doe",
          style: Get.theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "johndoe@email.com",
          style: Get.theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

