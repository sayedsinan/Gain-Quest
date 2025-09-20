import 'package:gain_quest/data/models/bet_model.dart';
import 'package:gain_quest/data/models/challenge_model.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/data/sources/firebase_service.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();
  
  final RxList<ChallengeModel> activeChallenges = <ChallengeModel>[].obs;
  final RxList<TeamModel> trendingTeams = <TeamModel>[].obs;
  final RxList<BetModel> userBets = <BetModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Load active challenges
      List<ChallengeModel> challenges = await _firebaseService.getActiveChallenges();
      activeChallenges.assignAll(challenges);
      
      // Load trending teams
      List<TeamModel> teams = await _firebaseService.getTeams();
      teams.sort((a, b) => b.followersCount.compareTo(a.followersCount));
      trendingTeams.assignAll(teams.take(5).toList());
      
      // Load user bets if logged in
      if (_authController.currentUser.value != null) {
        List<BetModel> bets = await _firebaseService.getUserBets(_authController.currentUser.value!.id);
        userBets.assignAll(bets.take(5).toList());
      }
      
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  Future<void> placeBet(String challengeId, String teamId, int credits, String prediction) async {
    try {
      if (_authController.currentUser.value == null) {
        Get.snackbar('Error', 'Please log in to place bets');
        return;
      }

      isLoading.value = true;
      
      BetModel bet = BetModel(
        id: '',
        userId: _authController.currentUser.value!.id,
        challengeId: challengeId,
        teamId: teamId,
        creditsStaked: credits,
        prediction: prediction,
        status: 'pending',
        createdAt: DateTime.now(),
      );
      
      await _firebaseService.placeBet(bet);
      
      Get.snackbar(
        'Success',
        'Bet placed successfully! You can only win - no risk of losing credits!',
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
      
      await loadDashboardData();
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to place bet: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<ChallengeModel> get featuredChallenges {
    return activeChallenges.where((challenge) => 
      challenge.timeRemaining.inHours < 48 && challenge.totalBets > 20
    ).toList();
  }

  List<TeamModel> get liveTeams {
    return trendingTeams.where((team) => team.isLive).toList();
  }
}