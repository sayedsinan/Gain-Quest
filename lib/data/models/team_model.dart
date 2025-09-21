class TeamModel {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String category;
  final List<String> members;
  final int followersCount;
  final double winRate;
  final int totalChallenges;
  final int challengesWon;
  final DateTime createdAt;
  final bool isLive;

  TeamModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.category,
    required this.members,
    required this.followersCount,
    required this.winRate,
    required this.totalChallenges,
    required this.challengesWon,
    required this.createdAt,
    this.isLive = false,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      category: map['category'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      followersCount: map['followersCount'] ?? 0,
      winRate: map['winRate']?.toDouble() ?? 0.0,
      totalChallenges: map['totalChallenges'] ?? 0,
      challengesWon: map['challengesWon'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isLive: map['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'category': category,
      'members': members,
      'followersCount': followersCount,
      'winRate': winRate,
      'totalChallenges': totalChallenges,
      'challengesWon': challengesWon,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isLive': isLive,
    };
  }
TeamModel copyWith({
  String? id,
  String? name,
  String? description,
  String? logoUrl,
  String? category,
  List<String>? members,
  int? followersCount,
  double? winRate,
  int? totalChallenges,
  int? challengesWon,
  DateTime? createdAt,
  bool? isLive,
}) {
  return TeamModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    logoUrl: logoUrl ?? this.logoUrl,
    category: category ?? this.category,
    members: members ?? this.members,
    followersCount: followersCount ?? this.followersCount,
    winRate: winRate ?? this.winRate,
    totalChallenges: totalChallenges ?? this.totalChallenges,
    challengesWon: challengesWon ?? this.challengesWon,
    createdAt: createdAt ?? this.createdAt,
    isLive: isLive ?? this.isLive,
  );
}
}
