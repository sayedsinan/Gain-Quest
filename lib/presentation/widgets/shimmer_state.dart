import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerStats extends StatelessWidget {
  const ShimmerStats({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: Row(
        children: List.generate(3, (index) => 
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: Column(
        children: List.generate(3, (index) => 
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(right: 16),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}