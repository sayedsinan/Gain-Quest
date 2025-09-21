import 'package:get/get.dart';
import 'package:gain_quest/data/models/challenge_model.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/data/models/bet_model.dart';
import 'package:gain_quest/data/sources/firebase_service.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ChallengeModel> activeChallenges = <ChallengeModel>[].obs;
  final RxList<TeamModel> trendingTeams = <TeamModel>[].obs;
  final RxList<BetModel> userBets = <BetModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  @override
  void onReady() {
    super.onReady();
    _setupRealtimeListeners();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.wait([
        _loadActiveChallenges(),
        _loadTrendingTeams(),
        _loadUserBets(),
      ]);
    } catch (e) {
      print('Error loading initial data: $e');
      errorMessage.value = 'Failed to load data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadActiveChallenges() async {
    try {
      print('Loading active challenges...');
      final challenges = await _firebaseService.getActiveChallenges();
      activeChallenges.value = challenges;
      print('Loaded ${challenges.length} active challenges');
    } catch (e) {
      print('Error loading active challenges: $e');
      throw e;
    }
  }

  Future<void> _loadTrendingTeams() async {
    try {
      print('Loading trending teams...');
      final teams = await _firebaseService.getTeams();
      teams.sort((a, b) => b.followersCount.compareTo(a.followersCount));
      trendingTeams.value = teams.take(5).toList(); 
      print('Loaded ${trendingTeams.length} trending teams');
    } catch (e) {
      print('Error loading trending teams: $e');
      throw e;
    }
  }

  Future<void> _loadUserBets() async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        print('No current user, skipping bet loading');
        return;
      }

      print('Loading user bets for: ${currentUser.id}');
      final bets = await _firebaseService.getUserBets(currentUser.id);
      userBets.value = bets;
      print('Loaded ${bets.length} user bets');
    } catch (e) {
      print('Error loading user bets: $e');
      throw e;
    }
  }

  void _setupRealtimeListeners() {
    try {

      _firebaseService.getActiveChallengesStream().listen(
        (challenges) {
          activeChallenges.value = challenges;
          print('Real-time update: ${challenges.length} active challenges');
        },
        onError: (e) {
          print('Error in active challenges stream: $e');
        },
      );

      _firebaseService.getTeamsStream().listen(
        (teams) {
          teams.sort((a, b) => b.followersCount.compareTo(a.followersCount));
          trendingTeams.value = teams.take(5).toList();
          print('Real-time update: ${trendingTeams.length} trending teams');
        },
        onError: (e) {
          print('Error in teams stream: $e');
        },
      );

      
      final currentUser = _authController.currentUser.value;
      if (currentUser != null) {
        _firebaseService.getUserBetsStream(currentUser.id).listen(
          (bets) {
            userBets.value = bets;
            print('Real-time update: ${bets.length} user bets');
          },
          onError: (e) {
            print('Error in user bets stream: $e');
          },
        );
      }
    } catch (e) {
      print('Error setting up real-time listeners: $e');
    }
  }

  Future<void> refreshDashboard() async {
    isRefreshing.value = true;
    errorMessage.value = '';

    try {
      await _loadInitialData();
      Get.snackbar(
        'Success',
        'Dashboard refreshed successfully!',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Error refreshing dashboard: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> placeBet(String challengeId, String teamId, int credits, String prediction) async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Please log in to place a bet',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

     
      if (currentUser.credits < credits) {
        Get.snackbar(
          'Insufficient Credits',
          'You don\'t have enough credits to place this bet',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

   
      BetModel bet = BetModel(
        id: '', 
        userId: currentUser.id,
        challengeId: challengeId,
        teamId: teamId,
        creditsStaked: credits,
        prediction: prediction,
        status: 'pending',
        creditsWon: 0,
        createdAt: DateTime.now(),
        resolvedAt: null,
      );


      await _firebaseService.placeBet(bet);

      Get.snackbar(
        'Bet Placed!',
        'Your bet of $credits credits has been placed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: 3),
      );

      await _authController.updateProfile({});

    } catch (e) {
      print('Error placing bet: $e');
      Get.snackbar(
        'Error',
        'Failed to place bet. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> followTeam(String teamId) async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Please log in to follow teams',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      await _firebaseService.followTeam(currentUser.id, teamId);
      
      Get.snackbar(
        'Success',
        'Team followed successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await _authController.updateProfile({});

    } catch (e) {
      print('Error following team: $e');
      Get.snackbar(
        'Error',
        'Failed to follow team. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> unfollowTeam(String teamId) async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) return;

      await _firebaseService.unfollowTeam(currentUser.id, teamId);
      
      Get.snackbar(
        'Success',
        'Team unfollowed successfully!',
        snackPosition: SnackPosition.TOP,
      );

     
      await _authController.updateProfile({});

    } catch (e) {
      print('Error unfollowing team: $e');
      Get.snackbar(
        'Error',
        'Failed to unfollow team. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }


  bool isTeamFollowed(String teamId) {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) return false;
    return currentUser.followedTeams.contains(teamId);
  }

  ChallengeModel? getChallengeById(String challengeId) {
    try {
      return activeChallenges.firstWhere((challenge) => challenge.id == challengeId);
    } catch (e) {
      return null;
    }
  }

  TeamModel? getTeamById(String teamId) {
    try {
      return trendingTeams.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  
}