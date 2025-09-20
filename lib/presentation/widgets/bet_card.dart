import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gain_quest/data/models/bet_model.dart';
import 'package:intl/intl.dart';

class BetCard extends StatelessWidget {
  final BetModel bet;

  const BetCard({
    super.key,
    required this.bet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 20,
              ),
            ),
            
            SizedBox(width: 12),
            
            // Bet Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bet on ${bet.prediction.toUpperCase()}',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Staked: ${bet.creditsStaked} credits',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateFormat.MMMd().add_jm().format(bet.createdAt),
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bet Result
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                if (bet.creditsWon != null && bet.creditsWon! > 0) ...[
                  SizedBox(height: 4),
                  Text(
                    '+${bet.creditsWon} credits',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (bet.status) {
      case 'pending':
        return Colors.orange;
      case 'won':
        return Get.theme.colorScheme.secondary;
      case 'lost':
        return Get.theme.colorScheme.error;
      default:
        return Get.theme.colorScheme.onSurface;
    }
  }

  IconData _getStatusIcon() {
    switch (bet.status) {
      case 'pending':
        return Icons.access_time;
      case 'won':
        return Icons.check_circle;
      case 'lost':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText() {
    switch (bet.status) {
      case 'pending':
        return 'PENDING';
      case 'won':
        return 'WON';
      case 'lost':
        return 'NO WIN';
      default:
        return 'UNKNOWN';
    }
  }
}