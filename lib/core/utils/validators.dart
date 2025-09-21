import 'package:gain_quest/core/constants/app_constant.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  // Bet amount validation
  static String? validateBetAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bet amount is required';
    }
    
    final amount = int.tryParse(value);
    if (amount == null) {
      return 'Enter a valid number';
    }
    
    if (amount < 10) {
      return 'Minimum bet is 10 credits';
    }
    
    if (amount > AppConstants.maxBetAmount) {
      return 'Maximum bet is ${AppConstants.maxBetAmount} credits';
    }
    
    return null;
  }

  // Phone number validation (optional)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    
    return null;
  }

  // Text length validation
  static String? validateTextLength(String? value, int minLength, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    
    return null;
  }

  // Credit amount validation
  static String? validateCredits(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credits amount is required';
    }
    
    final credits = int.tryParse(value);
    if (credits == null) {
      return 'Enter a valid number';
    }
    
    if (credits < 0) {
      return 'Credits cannot be negative';
    }
    
    return null;
  }

  // Team name validation
  static String? validateTeamName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Team name is required';
    }
    
    if (value.trim().length < 3) {
      return 'Team name must be at least 3 characters';
    }
    
    if (value.length > 50) {
      return 'Team name must be less than 50 characters';
    }
    
    // Check for special characters (allow alphanumeric, spaces, hyphens, underscores)
    final nameRegex = RegExp(r'^[a-zA-Z0-9\s\-_]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Team name can only contain letters, numbers, spaces, hyphens, and underscores';
    }
    
    return null;
  }

  // Challenge title validation
  static String? validateChallengeTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Challenge title is required';
    }
    
    if (value.trim().length < 5) {
      return 'Challenge title must be at least 5 characters';
    }
    
    if (value.length > 100) {
      return 'Challenge title must be less than 100 characters';
    }
    
    return null;
  }

  // Challenge description validation
  static String? validateChallengeDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Challenge description is required';
    }
    
    if (value.trim().length < 10) {
      return 'Challenge description must be at least 10 characters';
    }
    
    if (value.length > 500) {
      return 'Challenge description must be less than 500 characters';
    }
    
    return null;
  }

  // Percentage validation (0-100)
  static String? validatePercentage(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Enter a valid number';
    }
    
    if (percentage < 0 || percentage > 100) {
      return '$fieldName must be between 0 and 100';
    }
    
    return null;
  }
  
}