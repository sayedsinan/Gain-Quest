import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TeamCard extends StatelessWidget {
  final TeamModel team;
  final double? width;
  final VoidCallback? onTap;

  const TeamCard({
    Key? key,
    required this.team,
    this.width,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Get.theme.colorScheme.surface,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: team.logoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Get.theme.colorScheme.surface,
                            child: Icon(
                              Icons.group,
                              color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Get.theme.colorScheme.surface,
                            child: Icon(
                              Icons.group,
                              color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  team.name,
                                  style: Get.theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (team.isLive)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            team.category,
                            style: Get.theme.textTheme.bodySmall?.copyWith(
                              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Text(
                  team.description,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 12),
                
                // Team Stats
                Row(
                  children: [
                    _buildStatItem(
                      Icons.people_outline,
                      '${team.followersCount}',
                      'Followers',
                    ),
                    SizedBox(width: 16),
                    _buildStatItem(
                      Icons.emoji_events_outlined,
                      '${team.winRate.toStringAsFixed(1)}%',
                      'Win Rate',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: Get.theme.textTheme.bodySmall?.copyWith(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}