class BetModel {
  final String id;
  final String userId;
  final String challengeId;
  final String teamId;
  final int creditsStaked;
  final String prediction;
  final String status;
  final int? creditsWon;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  BetModel({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.teamId,
    required this.creditsStaked,
    required this.prediction,
    required this.status,
    this.creditsWon,
    required this.createdAt,
    this.resolvedAt,
  });

  factory BetModel.fromMap(Map<String, dynamic> map) {
    return BetModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      challengeId: map['challengeId'] ?? '',
      teamId: map['teamId'] ?? '',
      creditsStaked: map['creditsStaked'] ?? 0,
      prediction: map['prediction'] ?? '',
      status: map['status'] ?? '',
      creditsWon: map['creditsWon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolvedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'teamId': teamId,
      'creditsStaked': creditsStaked,
      'prediction': prediction,
      'status': status,
      'creditsWon': creditsWon,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'resolvedAt': resolvedAt?.millisecondsSinceEpoch,
    };
  }

  bool get isPending => status == 'pending';
  bool get isWon => status == 'won';
  bool get isLost => status == 'lost';
}