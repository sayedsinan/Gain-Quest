import 'package:flutter/material.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:gain_quest/data/models/challenge_model.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final Function(String challengeId, String teamId, int credits, String prediction) onBetPressed;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onBetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showChallengeDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: Get.theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          challenge.description,
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor().withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      challenge.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Challenge Stats
              Row(
                children: [
                  _buildStatItem(
                    Icons.people_outline,
                    '${challenge.totalBets} bets',
                  ),
                  SizedBox(width: 16),
                  _buildStatItem(
                    Icons.account_balance_wallet_outlined,
                    '${challenge.totalCreditsStaked} staked',
                  ),
                  Spacer(),
                  if (challenge.isActive)
                    _buildTimeRemaining(),
                ],
              ),
              
              if (challenge.isActive) ...[
                SizedBox(height: 16),
                
                // Odds Display
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: challenge.odds.entries.map((entry) {
                      return Expanded(
                        child: Column(
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${entry.value}%',
                              style: Get.theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: entry.key == 'success' 
                                    ? Get.theme.colorScheme.secondary 
                                    : Get.theme.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Bet Button
                CustomButton(
                  text: 'Place Bet',
                  onPressed: () => _showBetDialog(context),
                  icon: Icons.trending_up,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: Get.theme.textTheme.bodySmall?.copyWith(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRemaining() {
    Duration timeLeft = challenge.timeRemaining;
    String timeText;
    
    if (timeLeft.inDays > 0) {
      timeText = '${timeLeft.inDays}d ${timeLeft.inHours % 24}h';
    } else if (timeLeft.inHours > 0) {
      timeText = '${timeLeft.inHours}h ${timeLeft.inMinutes % 60}m';
    } else if (timeLeft.inMinutes > 0) {
      timeText = '${timeLeft.inMinutes}m';
    } else {
      timeText = 'Ending soon';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: Get.theme.colorScheme.secondary,
          ),
          SizedBox(width: 4),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (challenge.status) {
      case 'active':
        return Get.theme.colorScheme.secondary;
      case 'completed':
        return Get.theme.primaryColor;
      case 'cancelled':
        return Get.theme.colorScheme.error;
      default:
        return Get.theme.colorScheme.onSurface;
    }
  }

  void _showChallengeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChallengeDetailsSheet(challenge: challenge),
    );
  }

  void _showBetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BetDialog(
        challenge: challenge,
        onBetPlaced: onBetPressed,
      ),
    );
  }
}

class ChallengeDetailsSheet extends StatelessWidget {
  final ChallengeModel challenge;

  const ChallengeDetailsSheet({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: EdgeInsets.only(top: 12, bottom: 20),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: Get.theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        challenge.description,
                        style: Get.theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Challenge Info Cards
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: 'Start Date',
                              value: DateFormat.MMMd().format(challenge.startDate),
                              icon: Icons.calendar_today,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              title: 'End Date',
                              value: DateFormat.MMMd().format(challenge.endDate),
                              icon: Icons.event,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: 'Total Bets',
                              value: '${challenge.totalBets}',
                              icon: Icons.people,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              title: 'Credits Staked',
                              value: '${challenge.totalCreditsStaked}',
                              icon: Icons.account_balance_wallet,
                            ),
                          ),
                        ],
                      ),
                      
                      if (challenge.resultDescription != null) ...[
                        SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Get.theme.colorScheme.secondary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Get.theme.colorScheme.secondary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Result',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                challenge.resultDescription!,
                                style: Get.theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Get.theme.primaryColor),
          SizedBox(height: 8),
          Text(
            value,
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BetDialog extends StatefulWidget {
  final ChallengeModel challenge;
  final Function(String challengeId, String teamId, int credits, String prediction) onBetPlaced;

  const BetDialog({
    Key? key,
    required this.challenge,
    required this.onBetPlaced,
  }) : super(key: key);

  @override
  _BetDialogState createState() => _BetDialogState();
}

class _BetDialogState extends State<BetDialog> {
  String selectedPrediction = 'success';
  int betAmount = 50;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Place Your Bet'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.challenge.title,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          
          // Prediction Selection
          Text(
            'Your Prediction:',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: widget.challenge.odds.keys.map((prediction) {
              bool isSelected = selectedPrediction == prediction;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: prediction != widget.challenge.odds.keys.last ? 8 : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPrediction = prediction;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Get.theme.primaryColor.withOpacity(0.1)
                            : Get.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected 
                              ? Get.theme.primaryColor 
                              : Get.theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            prediction.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Get.theme.primaryColor : null,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.challenge.odds[prediction]}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 16),
          
          // Bet Amount
          Text(
            'Bet Amount:',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: betAmount.toDouble(),
                  min: 10,
                  max: 500,
                  divisions: 49,
                  label: '$betAmount credits',
                  onChanged: (value) {
                    setState(() {
                      betAmount = value.toInt();
                    });
                  },
                ),
              ),
              Container(
                width: 80,
                child: Text(
                  '$betAmount',
                  style: Get.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Risk-free message
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.theme.colorScheme.secondary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: Get.theme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Risk-free betting: You can only win credits, never lose them!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        CustomButton(
          text: 'Place Bet',
          width: 120,
          height: 40,
          onPressed: () {
            widget.onBetPlaced(
              widget.challenge.id,
              widget.challenge.teamId,
              betAmount,
              selectedPrediction,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}