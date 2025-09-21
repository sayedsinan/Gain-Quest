import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:get/get.dart';

class MembersSection extends StatelessWidget {
  final TeamModel team;

  const MembersSection({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Team Members', style: Get.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
             const  Spacer(),
              Text('${team.members.length}',
                  style: Get.theme.textTheme.headlineMedium
                      ?.copyWith(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
         const  SizedBox(height: 16),
          ...team.members.map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Get.theme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(member, style: Get.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

