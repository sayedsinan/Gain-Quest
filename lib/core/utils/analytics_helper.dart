class AnalyticsHelper {
  // Event names
  static const String userSignedUp = 'user_signed_up';
  static const String userSignedIn = 'user_signed_in';
  static const String userSignedOut = 'user_signed_out';
  static const String betPlaced = 'bet_placed';
  static const String teamFollowed = 'team_followed';
  static const String teamUnfollowed = 'team_unfollowed';
  static const String challengeViewed = 'challenge_viewed';
  static const String liveStreamViewed = 'live_stream_viewed';
  static const String profileViewed = 'profile_viewed';
  static const String themeChanged = 'theme_changed';
  static const String onboardingCompleted = 'onboarding_completed';
  
  // Parameter names
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String teamId = 'team_id';
  static const String teamName = 'team_name';
  static const String challengeId = 'challenge_id';
  static const String challengeTitle = 'challenge_title';
  static const String betAmount = 'bet_amount';
  static const String betPrediction = 'bet_prediction';
  static const String streamId = 'stream_id';
  static const String streamTitle = 'stream_title';
  static const String themeMode = 'theme_mode';
  static const String screenName = 'screen_name';
  static const String actionType = 'action_type';
  
  // Screen names
  static const String homeScreen = 'home_screen';
  static const String teamsScreen = 'teams_screen';
  static const String liveStreamsScreen = 'live_streams_screen';
  static const String profileScreen = 'profile_screen';
  static const String loginScreen = 'login_screen';
  static const String signUpScreen = 'sign_up_screen';
  static const String onboardingScreen = 'onboarding_screen';
  static const String teamDetailScreen = 'team_detail_screen';
  static const String liveStreamDetailScreen = 'live_stream_detail_screen';
  
  // Log events (placeholder implementation)
  static void logEvent(String eventName, [Map<String, dynamic>? parameters]) {

    print('Analytics Event: $eventName');
    if (parameters != null) {
      print('Parameters: $parameters');
    }
  }
  
  // User events
  static void logUserSignUp(String userId, String email, String name) {
    logEvent(userSignedUp, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.userEmail: email,
      AnalyticsHelper.userName: name,
    });
  }
  
  static void logUserSignIn(String userId, String email) {
    logEvent(userSignedIn, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.userEmail: email,
    });
  }
  
  static void logUserSignOut(String userId) {
    logEvent(userSignedOut, {
      AnalyticsHelper.userId: userId,
    });
  }
  
  // Betting events
  static void logBetPlaced(String userId, String challengeId, String teamId, int amount, String prediction) {
    logEvent(betPlaced, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.challengeId: challengeId,
      AnalyticsHelper.teamId: teamId,
      AnalyticsHelper.betAmount: amount,
      AnalyticsHelper.betPrediction: prediction,
    });
  }
  
  // Team events
  static void logTeamFollowed(String userId, String teamId, String teamName) {
    logEvent(teamFollowed, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.teamId: teamId,
      AnalyticsHelper.teamName: teamName,
    });
  }
  
  static void logTeamUnfollowed(String userId, String teamId, String teamName) {
    logEvent(teamUnfollowed, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.teamId: teamId,
      AnalyticsHelper.teamName: teamName,
    });
  }
  
  // Content viewing events
  static void logChallengeViewed(String userId, String challengeId, String challengeTitle) {
    logEvent(challengeViewed, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.challengeId: challengeId,
      AnalyticsHelper.challengeTitle: challengeTitle,
    });
  }
  
  static void logLiveStreamViewed(String userId, String streamId, String streamTitle) {
    logEvent(liveStreamViewed, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.streamId: streamId,
      AnalyticsHelper.streamTitle: streamTitle,
    });
  }
  
  // App events
  static void logThemeChanged(String userId, String themeMode) {
    logEvent(themeChanged, {
      AnalyticsHelper.userId: userId,
      AnalyticsHelper.themeMode: themeMode,
    });
  }
  
  static void logOnboardingCompleted(String userId) {
    logEvent(onboardingCompleted, {
      AnalyticsHelper.userId: userId,
    });
  }
  
  // Screen tracking
  static void logScreenView(String screenName, [String? userId]) {
    Map<String, dynamic> parameters = {
      AnalyticsHelper.screenName: screenName,
    };
    
    if (userId != null) {
      parameters[AnalyticsHelper.userId] = userId;
    }
    
    logEvent('screen_view', parameters);
  }
  
  // Custom events
  static void logCustomEvent(String eventName, Map<String, dynamic> parameters) {
    logEvent(eventName, parameters);
  }
  
  // User properties (for user segmentation)
  static void setUserProperty(String name, String value) {
    // In a real implementation, you would set user properties
    print('User Property Set: $name = $value');
  }
  
  static void setUserProperties(Map<String, String> properties) {
    properties.forEach((key, value) {
      setUserProperty(key, value);
    });
  }
  
  // Error tracking
  static void logError(String error, String? stackTrace, [Map<String, dynamic>? additionalData]) {
    Map<String, dynamic> parameters = {
      'error_message': error,
    };
    
    if (stackTrace != null) {
      parameters['stack_trace'] = stackTrace;
    }
    
    if (additionalData != null) {
      parameters.addAll(additionalData);
    }
    
    logEvent('error_occurred', parameters);
  }
  
  // Performance tracking
  static void logPerformance(String metricName, int valueMs, [Map<String, dynamic>? attributes]) {
    Map<String, dynamic> parameters = {
      'metric_name': metricName,
      'value_ms': valueMs,
    };
    
    if (attributes != null) {
      parameters.addAll(attributes);
    }
    
    logEvent('performance_metric', parameters);
  }
}