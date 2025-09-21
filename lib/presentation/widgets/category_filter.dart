import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:get/get.dart';

class CategoryFilter extends StatelessWidget {
  final TeamsController controller;

  const CategoryFilter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (controller.categories.isEmpty) return const SizedBox.shrink();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            String category = controller.categories[index];
            bool isSelected = controller.selectedCategory.value == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(category),
                backgroundColor: Get.theme.colorScheme.surface,
                selectedColor: Get.theme.primaryColor.withOpacity(0.2),
                checkmarkColor: Get.theme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Get.theme.primaryColor : null,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
