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
import 'dart:async';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeFirebaseSettings();
  }

  void _initializeFirebaseSettings() {
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      print('Firebase settings initialized');
    } catch (e) {
      print('Error initializing Firebase settings: $e');
    }
  }

  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      print('Attempting to sign in with email: $email');
      
      await _auth.signOut();
      await Future.delayed(Duration(milliseconds: 100));
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password
      ).timeout(Duration(seconds: 30));
      
      await Future.delayed(Duration(milliseconds: 500));
      
      print('Sign in successful: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      
      if (e.code == 'too-many-requests') {

        await Future.delayed(Duration(seconds: 2));
        try {
          final retryCredential = await _auth.signInWithEmailAndPassword(
            email: email.trim(), 
            password: password
          );
          return retryCredential;
        } catch (retryError) {
          print('Retry also failed: $retryError');
          throw e; 
        }
      }
      
      throw e;
    } on TimeoutException catch (e) {
      print('Sign in timeout: $e');
      throw FirebaseAuthException(
        code: 'timeout',
        message: 'Sign in request timed out. Please try again.',
      );
    } catch (e) {
      print('Unexpected sign in error: $e');
      
  
      await Future.delayed(Duration(milliseconds: 500));
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email == email.trim()) {
        print('User is actually signed in, returning mock credential');

        return MockUserCredential(currentUser);
      }
      
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred during sign in. Please try again.',
      );
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      print('Attempting to sign up with email: $email');
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), 
        password: password
      ).timeout(Duration(seconds: 30));
      
      await Future.delayed(Duration(milliseconds: 500));
      
      print('Sign up successful: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception during sign up: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected sign up error: $e');
      

      await Future.delayed(Duration(milliseconds: 500));
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email == email.trim()) {
        print('User is actually signed up, returning mock credential');
        return MockUserCredential(currentUser);
      }
      
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred during sign up. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Sign out successful');
    } catch (e) {
      print('Sign out error: $e');
      
    }
  }

  User? getCurrentUser() {
    try {
      final user = _auth.currentUser;
      print('Current user: ${user?.uid}');
      return user;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().handleError((error) {
      print('Auth state change error: $error');
    });
  }


  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toMap())
          .timeout(Duration(seconds: 15));
      print('User profile created successfully');
    } on FirebaseException catch (e) {
      print('Firebase error creating user profile: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Error creating user profile: $e');
      throw e;
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      print('Fetching user profile for: $userId');
      
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get()
          .timeout(Duration(seconds: 15));
      
      if (doc.exists && doc.data() != null) {
        print('User profile found');
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('User profile not found');
        return null;
      }
    } on FirebaseException catch (e) {
      print('Firebase error getting user profile: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Error getting user profile: $e');
      throw e;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data)
          .timeout(Duration(seconds: 15));
      print('User profile updated successfully');
    } on FirebaseException catch (e) {
      print('Firebase error updating user profile: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }

  Stream<UserModel?> getUserProfileStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

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
   
      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      transaction.update(userRef, {
        'followedTeams': FieldValue.arrayUnion([teamId])
      });

      DocumentReference teamRef = _firestore.collection(AppConstants.teamsCollection).doc(teamId);
      transaction.update(teamRef, {
        'followersCount': FieldValue.increment(1)
      });
    });
  }

  Future<void> unfollowTeam(String userId, String teamId) async {
    await _firestore.runTransaction((transaction) async {
   
      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      transaction.update(userRef, {
        'followedTeams': FieldValue.arrayRemove([teamId])
      });

     
      DocumentReference teamRef = _firestore.collection(AppConstants.teamsCollection).doc(teamId);
      transaction.update(teamRef, {
        'followersCount': FieldValue.increment(-1)
      });
    });
  }


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


  Future<void> placeBet(BetModel bet) async {
    await _firestore.runTransaction((transaction) async {
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

      DocumentReference userRef = _firestore.collection(AppConstants.usersCollection).doc(bet.userId);
      transaction.update(userRef, {
        'betsPlaced': FieldValue.increment(1)
      });

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


  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> initializeSampleData() async {
    try {
      print('Initializing sample data directly...');

  
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

      
      WriteBatch batch = _firestore.batch();

      for (TeamModel team in sampleTeams) {
        batch.set(_firestore.collection(AppConstants.teamsCollection).doc(team.id), team.toMap());
      }

      for (ChallengeModel challenge in sampleChallenges) {
        batch.set(_firestore.collection(AppConstants.challengesCollection).doc(challenge.id), challenge.toMap());
      }

      await batch.commit();
      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
  
    }
  }
}

class MockUserCredential implements UserCredential {
  @override
  final User user;

  MockUserCredential(this.user);

  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;
}