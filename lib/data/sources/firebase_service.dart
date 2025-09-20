import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gain_quest/core/constants/app_constant.dart';
import 'package:gain_quest/data/models/bet_model.dart';
import 'package:gain_quest/data/models/challenge_model.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/data/models/user_model.dart';
import 'package:get/get.dart';
import 'dart:io';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Auth Methods
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // User Operations
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection(AppConstants.usersCollection).doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(AppConstants.usersCollection).doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection(AppConstants.usersCollection).doc(userId).update(data);
  }

  Stream<UserModel?> getUserProfileStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  // Team Operations
  Future<List<TeamModel>> getTeams() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(AppConstants.teamsCollection).get();
      return snapshot.docs.map((doc) => TeamModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<TeamModel?> getTeam(String teamId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(AppConstants.teamsCollection).doc(teamId).get();
      if (doc.exists) {
        return TeamModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Stream<List<TeamModel>> getTeamsStream() {
    return _firestore
        .collection(AppConstants.teamsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TeamModel.fromMap(doc.data())).toList());
  }

  Future<void> followTeam(String userId, String teamId) async {
    await _firestore.runTransaction((transaction) async {
      // Update user's followed teams
      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      transaction.update(userRef, {
        'followedTeams': FieldValue.arrayUnion([teamId])
      });

      // Update team's followers count
      DocumentReference teamRef = _firestore.collection(AppConstants.teamsCollection).doc(teamId);
      transaction.update(teamRef, {
        'followersCount': FieldValue.increment(1)
      });
    });
  }

  Future<void> unfollowTeam(String userId, String teamId) async {
    await _firestore.runTransaction((transaction) async {
      // Update user's followed teams
      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      transaction.update(userRef, {
        'followedTeams': FieldValue.arrayRemove([teamId])
      });

      // Update team's followers count
      DocumentReference teamRef = _firestore.collection(AppConstants.teamsCollection).doc(teamId);
      transaction.update(teamRef, {
        'followersCount': FieldValue.increment(-1)
      });
    });
  }

  // Challenge Operations
  Future<List<ChallengeModel>> getChallenges() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.challengesCollection)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => ChallengeModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<ChallengeModel>> getActiveChallenges() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.challengesCollection)
          .where('status', isEqualTo: AppConstants.challengeStatusActive)
          .orderBy('endDate')
          .get();
      return snapshot.docs.map((doc) => ChallengeModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e;
    }
  }

  Stream<List<ChallengeModel>> getActiveChallengesStream() {
    return _firestore
        .collection(AppConstants.challengesCollection)
        .where('status', isEqualTo: AppConstants.challengeStatusActive)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChallengeModel.fromMap(doc.data())).toList());
  }

  // Bet Operations
  Future<void> placeBet(BetModel bet) async {
    await _firestore.runTransaction((transaction) async {
      // Add bet document
      DocumentReference betRef = _firestore.collection(AppConstants.betsCollection).doc();
      BetModel betWithId = BetModel(
        id: betRef.id,
        userId: bet.userId,
        challengeId: bet.challengeId,
        teamId: bet.teamId,
        creditsStaked: bet.creditsStaked,
        prediction: bet.prediction,
        status: bet.status,
        creditsWon: bet.creditsWon,
        createdAt: bet.createdAt,
        resolvedAt: bet.resolvedAt,
      );
      transaction.set(betRef, betWithId.toMap());

      // Update user stats (no credits deducted - only gains allowed)
      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(bet.userId);
      transaction.update(userRef, {
        'betsPlaced': FieldValue.increment(1)
      });

      // Update challenge stats
      DocumentReference challengeRef = _firestore.collection(AppConstants.challengesCollection).doc(bet.challengeId);
      transaction.update(challengeRef, {
        'totalBets': FieldValue.increment(1),
        'totalCreditsStaked': FieldValue.increment(bet.creditsStaked)
      });
    });
  }

  Future<List<BetModel>> getUserBets(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.betsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => BetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e;
    }
  }

  Stream<List<BetModel>> getUserBetsStream(String userId) {
    return _firestore
        .collection(AppConstants.betsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => BetModel.fromMap(doc.data())).toList());
  }

  // Live Stream Operations
  Future<void> createLiveStream(Map<String, dynamic> streamData) async {
    await _firestore.collection(AppConstants.liveStreamsCollection).add(streamData);
  }

  Stream<List<Map<String, dynamic>>> getLiveStreamsStream() {
    return _firestore
        .collection(AppConstants.liveStreamsCollection)
        .where('isLive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  // Chat Operations
  Future<void> sendChatMessage(String streamId, Map<String, dynamic> message) async {
    await _firestore
        .collection(AppConstants.liveStreamsCollection)
        .doc(streamId)
        .collection(AppConstants.chatMessagesCollection)
        .add(message);
  }

  Stream<List<Map<String, dynamic>>> getChatMessagesStream(String streamId) {
    return _firestore
        .collection(AppConstants.liveStreamsCollection)
        .doc(streamId)
        .collection(AppConstants.chatMessagesCollection)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  // Storage Operations
  Future<String> uploadImage(File file, String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }

  // Notification Operations
  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  // Initialize sample data (for demo purposes)
  Future<void> initializeSampleData() async {
    // Check if data already exists
    QuerySnapshot teamsSnapshot = await _firestore.collection(AppConstants.teamsCollection).limit(1).get();
    if (teamsSnapshot.docs.isNotEmpty) return;

    // Create sample teams
    List<TeamModel> sampleTeams = [
      TeamModel(
        id: 'team1',
        name: 'Tech Titans',
        description: 'Leading technology innovation team',
        logoUrl: 'https://via.placeholder.com/150/6C5CE7/FFFFFF?text=TT',
        category: 'Technology',
        members: ['Alice Johnson', 'Bob Smith', 'Carol Williams'],
        followersCount: 150,
        winRate: 75.5,
        totalChallenges: 8,
        challengesWon: 6,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        isLive: false,
      ),
      TeamModel(
        id: 'team2',
        name: 'Sales Stars',
        description: 'High-performing sales champions',
        logoUrl: 'https://via.placeholder.com/150/00B894/FFFFFF?text=SS',
        category: 'Sales',
        members: ['David Brown', 'Eva Davis', 'Frank Miller'],
        followersCount: 200,
        winRate: 82.3,
        totalChallenges: 12,
        challengesWon: 10,
        createdAt: DateTime.now().subtract(Duration(days: 25)),
        isLive: true,
      ),
      TeamModel(
        id: 'team3',
        name: 'Marketing Mavericks',
        description: 'Creative marketing powerhouse',
        logoUrl: 'https://via.placeholder.com/150/FFD93D/000000?text=MM',
        category: 'Marketing',
        members: ['Grace Wilson', 'Henry Moore', 'Iris Taylor'],
        followersCount: 120,
        winRate: 68.9,
        totalChallenges: 9,
        challengesWon: 6,
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        isLive: false,
      ),
    ];

    // Create sample challenges
    List<ChallengeModel> sampleChallenges = [
      ChallengeModel(
        id: 'challenge1',
        title: 'Q4 Revenue Target',
        description: 'Achieve 25% revenue growth in Q4',
        teamId: 'team2',
        startDate: DateTime.now().subtract(Duration(days: 5)),
        endDate: DateTime.now().add(Duration(days: 25)),
        status: AppConstants.challengeStatusActive,
        odds: {'success': 70, 'failure': 30},
        totalBets: 45,
        totalCreditsStaked: 2250,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      ChallengeModel(
        id: 'challenge2',
        title: 'Product Launch Success',
        description: 'Launch new product with 1000+ users in first week',
        teamId: 'team1',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        status: AppConstants.challengeStatusActive,
        odds: {'success': 60, 'failure': 40},
        totalBets: 32,
        totalCreditsStaked: 1600,
        createdAt: DateTime.now(),
      ),
      ChallengeModel(
        id: 'challenge3',
        title: 'Campaign ROI Challenge',
        description: 'Achieve 300% ROI on marketing campaign',
        teamId: 'team3',
        startDate: DateTime.now().add(Duration(days: 2)),
        endDate: DateTime.now().add(Duration(days: 14)),
        status: AppConstants.challengeStatusActive,
        odds: {'success': 55, 'failure': 45},
        totalBets: 28,
        totalCreditsStaked: 1400,
        createdAt: DateTime.now(),
      ),
    ];

    // Save sample data
    WriteBatch batch = _firestore.batch();

    for (TeamModel team in sampleTeams) {
      batch.set(_firestore.collection(AppConstants.teamsCollection).doc(team.id), team.toMap());
    }

    for (ChallengeModel challenge in sampleChallenges) {
      batch.set(_firestore.collection(AppConstants.challengesCollection).doc(challenge.id), challenge.toMap());
    }

    await batch.commit();
  }
}