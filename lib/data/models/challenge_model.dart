
class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String teamId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final Map<String, int> odds;
  final int totalBets;
  final int totalCreditsStaked;
  final String? resultDescription;
  final DateTime createdAt;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teamId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.odds,
    required this.totalBets,
    required this.totalCreditsStaked,
    this.resultDescription,
    required this.createdAt,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      teamId: map['teamId'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] ?? 0),
      status: map['status'] ?? '',
      odds: Map<String, int>.from(map['odds'] ?? {}),
      totalBets: map['totalBets'] ?? 0,
      totalCreditsStaked: map['totalCreditsStaked'] ?? 0,
      resultDescription: map['resultDescription'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teamId': teamId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'status': status,
      'odds': odds,
      'totalBets': totalBets,
      'totalCreditsStaked': totalCreditsStaked,
      'resultDescription': resultDescription,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  bool get isActive => status == 'active' && DateTime.now().isBefore(endDate);
  bool get isCompleted => status == 'completed';
  Duration get timeRemaining => endDate.difference(DateTime.now());
}

