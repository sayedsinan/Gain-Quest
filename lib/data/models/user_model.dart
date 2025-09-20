class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final int credits;
  final int totalWinnings;
  final int betsPlaced;
  final int betsWon;
  final List<String> followedTeams;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool notificationsEnabled;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.credits,
    required this.totalWinnings,
    required this.betsPlaced,
    required this.betsWon,
    required this.followedTeams,
    required this.achievements,
    required this.createdAt,
    this.lastLoginAt,
    this.notificationsEnabled = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      credits: map['credits'] ?? 0,
      totalWinnings: map['totalWinnings'] ?? 0,
      betsPlaced: map['betsPlaced'] ?? 0,
      betsWon: map['betsWon'] ?? 0,
      followedTeams: List<String>.from(map['followedTeams'] ?? []),
      achievements: List<String>.from(map['achievements'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : null,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'credits': credits,
      'totalWinnings': totalWinnings,
      'betsPlaced': betsPlaced,
      'betsWon': betsWon,
      'followedTeams': followedTeams,
      'achievements': achievements,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    int? credits,
    int? totalWinnings,
    int? betsPlaced,
    int? betsWon,
    List<String>? followedTeams,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? notificationsEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      credits: credits ?? this.credits,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      betsPlaced: betsPlaced ?? this.betsPlaced,
      betsWon: betsWon ?? this.betsWon,
      followedTeams: followedTeams ?? this.followedTeams,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  double get winRate => betsPlaced > 0 ? (betsWon / betsPlaced) * 100 : 0.0;
}

