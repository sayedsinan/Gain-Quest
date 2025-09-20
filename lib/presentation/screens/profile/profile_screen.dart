import 'package:flutter/material.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar('Info', 'Edit profile feature coming soon!');
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProfileHeader(user),
              SizedBox(height: 32),
              _buildStatsSection(user),
              SizedBox(height: 32),
              _buildAchievementsSection(user),
              SizedBox(height: 32),
              _buildSettingsSection(),
              SizedBox(height: 32),
              _buildSignOutButton(),
            ],
          ),
        );
      }),
    );
  }

  // ==================== PROFILE HEADER ====================
  Widget _buildProfileHeader(user) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.theme.colorScheme.surface,
                  border: Border.all(
                    color: Get.theme.primaryColor.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: user.photoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: user.photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.person,
                            size: 40,
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 40,
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Get.theme.cardColor, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            user.name,
            style: Get.theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            user.email,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Get.theme.colorScheme.secondary.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Member since ${user.createdAt.year}',
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATS SECTION ====================
  Widget _buildStatsSection(user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stats',
            style: Get.theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  title: 'Credits',
                  value: '${user.credits}',
                  icon: Icons.account_balance_wallet,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  title: 'Total Winnings',
                  value: '${user.totalWinnings}',
                  icon: Icons.trending_up,
                  color: Color(0xFFFFD93D),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  title: 'Bets Placed',
                  value: '${user.betsPlaced}',
                  icon: Icons.sports_handball,
                  color: Get.theme.primaryColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  title: 'Win Rate',
                  value: '${user.winRate.toStringAsFixed(1)}%',
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

  // ==================== ACHIEVEMENTS SECTION ====================
  Widget _buildAchievementsSection(user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Get.theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.achievements.length}',
                style: Get.theme.textTheme.headlineMedium?.copyWith(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (user.achievements.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 48,
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No achievements yet',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start betting to earn your first badge!',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.achievements
                  .map((achievement) => _AchievementBadge(achievement))
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ==================== SETTINGS SECTION ====================
  Widget _buildSettingsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Get.theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _SettingItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.setDarkMode(value),
                  activeColor: Get.theme.primaryColor,
                )),
          ),
          _SettingItem(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            trailing: Obx(() => Switch(
                  value: authController.currentUser.value?.notificationsEnabled ?? true,
                  onChanged: (value) {
                    Get.snackbar('Info', 'Notification settings feature coming soon!');
                  },
                  activeColor: Get.theme.primaryColor,
                )),
          ),
          _SettingItem(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            onTap: () {
              Get.snackbar('Info', 'Privacy settings feature coming soon!');
            },
          ),
          _SettingItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Get.snackbar('Info', 'Help & Support feature coming soon!');
            },
          ),
          _SettingItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  // ==================== SIGN OUT BUTTON ====================
  Widget _buildSignOutButton() {
    return CustomButton(
      text: 'Sign Out',
      onPressed: () => _showSignOutDialog(),
      isOutlined: true,
      backgroundColor: Get.theme.colorScheme.error,
      textColor: Get.theme.colorScheme.error,
      icon: Icons.logout,
    );
  }

  void _showSignOutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.signOut();
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: Get.theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('About Sales Bets'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text(
              'Sales Bets is a revolutionary platform where business challenges meet betting excitement. Win big, risk nothing!',
              style: Get.theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 12),
            Text(
              '© 2024 Sales Bets. All rights reserved.',
              style: Get.theme.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ==================== REUSABLE WIDGETS ====================
class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
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

class _AchievementBadge extends StatelessWidget {
  final String achievement;

  const _AchievementBadge(this.achievement);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    Color color;

    switch (achievement) {
      case 'first_bet':
        icon = Icons.sports_handball;
        title = 'First Bet';
        color = Colors.blue;
        break;
      case 'first_win':
        icon = Icons.emoji_events;
        title = 'First Win';
        color = Colors.amber;
        break;
      case 'streak_winner':
        icon = Icons.local_fire_department;
        title = 'Streak Winner';
        color = Colors.orange;
        break;
      default:
        icon = Icons.star;
        title = 'Achievement';
        color = Get.theme.primaryColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(title),
      trailing: trailing ?? (onTap != null ? Icon(Icons.arrow_forward_ios, size: 16) : null),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
