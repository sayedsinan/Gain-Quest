import 'package:intl/intl.dart';

class Formatters {
  // Currency formatter
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  // Credits formatter (no decimal places for credits)
  static String formatCredits(int credits) {
    final formatter = NumberFormat('#,###');
    return formatter.format(credits);
  }

  // Large number formatter (K, M, B)
  static String formatLargeNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
  }

  // Percentage formatter
  static String formatPercentage(double percentage, {int decimalPlaces = 1}) {
    return '${percentage.toStringAsFixed(decimalPlaces)}%';
  }

  // Date formatters
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Duration formatters
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  static String formatTimeRemaining(DateTime endTime) {
    final now = DateTime.now();
    final timeLeft = endTime.difference(now);

    if (timeLeft.isNegative) {
      return 'Ended';
    }

    return formatDuration(timeLeft);
  }

  // Phone number formatter
  static String formatPhoneNumber(String phoneNumber) {

    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }
    
    return phoneNumber;
  }

  // Name formatter
  static String formatName(String name) {
    return name.split(' ').map((word) => 
      word.isNotEmpty 
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : word
    ).join(' ');
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Email masking for privacy
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }
    
    return '${username.substring(0, 2)}***@$domain';
  }

  // File size formatter
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Team member count formatter
  static String formatMemberCount(int count) {
    if (count == 1) {
      return '$count member';
    }
    return '$count members';
  }

  // Follower count formatter
  static String formatFollowerCount(int count) {
    if (count == 1) {
      return '$count follower';
    }
    return '$count followers';
  }

  // Bet status formatter
  static String formatBetStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'won':
        return 'Won';
      case 'lost':
        return 'No Win';
      default:
        return capitalize(status);
    }
  }

  // Challenge status formatter
  static String formatChallengeStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return capitalize(status);
    }
  }

  // Win rate formatter
  static String formatWinRate(double winRate) {
    return '${winRate.toStringAsFixed(1)}%';
  }

  // Odds formatter
  static String formatOdds(int odds) {
    return '$odds%';
  }

  // URL formatter (ensure https)
  static String formatUrl(String url) {
    if (url.isEmpty) return url;
    
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    
    return url;
  }

  // Strip HTML tags (basic)
  static String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Format ordinal numbers (1st, 2nd, 3rd, etc.)
  static String formatOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}