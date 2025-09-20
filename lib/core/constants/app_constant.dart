class AppConstants {
  // App Info
  static const String appName = 'Sales Bets';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Win Big, Risk Nothing';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String teamsCollection = 'teams';
  static const String challengesCollection = 'challenges';
  static const String betsCollection = 'bets';
  static const String liveStreamsCollection = 'live_streams';
  static const String chatMessagesCollection = 'chat_messages';
  static const String notificationsCollection = 'notifications';

  // Shared Preferences Keys
  static const String isFirstTimeKey = 'isFirstTime';
  static const String themeKey = 'theme';
  static const String userIdKey = 'userId';

  // Default Values
  static const int initialCredits = 1000;
  static const int defaultBetAmount = 50;
  static const int maxBetAmount = 500;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // API Limits
  static const int pageSize = 20;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Image Paths
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultTeamLogo = 'assets/images/default_team.png';
  static const String onboardingImage1 = 'assets/images/onboarding_1.png';
  static const String onboardingImage2 = 'assets/images/onboarding_2.png';
  static const String onboardingImage3 = 'assets/images/onboarding_3.png';

  // Error Messages
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String permissionDenied = 'Permission denied. Please check your permissions.';

  // Success Messages
  static const String betPlacedSuccess = 'Bet placed successfully!';
  static const String teamFollowedSuccess = 'Team followed successfully!';
  static const String teamUnfollowedSuccess = 'Team unfollowed successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';

  // Validation
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // Betting Status
  static const String betStatusPending = 'pending';
  static const String betStatusWon = 'won';
  static const String betStatusLost = 'lost';

  // Challenge Status
  static const String challengeStatusActive = 'active';
  static const String challengeStatusCompleted = 'completed';
  static const String challengeStatusCancelled = 'cancelled';

  // Team Categories
  static const List<String> teamCategories = [
    'Technology',
    'Sales',
    'Marketing',
    'Finance',
    'Operations',
    'Customer Service',
    'HR',
    'Product',
    'Engineering',
    'Design'
  ];

  // Achievement Types
  static const String achievementFirstBet = 'first_bet';
  static const String achievementFirstWin = 'first_win';
  static const String achievementStreakWinner = 'streak_winner';
  static const String achievementBigWinner = 'big_winner';
  static const String achievementTeamFollower = 'team_follower';
  static const String achievementSocialButterfly = 'social_butterfly';

  // Notification Types
  static const String notificationBetResult = 'bet_result';
  static const String notificationTeamUpdate = 'team_update';
  static const String notificationLiveStream = 'live_stream';
  static const String notificationAchievement = 'achievement';
  static const String notificationGeneral = 'general';
}