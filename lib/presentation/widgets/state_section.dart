import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/stat_items.dart';
import 'package:get/get.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stats',
            style: Get.theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Row(
            children:  [
              Expanded(
                child: StatItem(
                  title: 'Credits',
                  value: "1,200",
                  icon: Icons.account_balance_wallet,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatItem(
                  title: 'Total Winnings',
                  value: "₹25,000",
                  icon: Icons.trending_up,
                  color: Color(0xFFFFD93D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
         const Row(
            children:  [
              Expanded(
                child: StatItem(
                  title: 'Bets Placed',
                  value: "340",
                  icon: Icons.sports_handball,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatItem(
                  title: 'Win Rate',
                  value: "67%",
                  icon: Icons.star,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

