import 'package:gain_quest/data/sources/firebase_service.dart';
import 'package:get/get.dart';
import 'package:gain_quest/core/constants/app_constant.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';

class TeamsController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();
  
  final RxList<TeamModel> teams = <TeamModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  
  final List<String> categories = ['All', ...AppConstants.teamCategories];

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  List<TeamModel> get filteredTeams {
    if (selectedCategory.value == 'All') {
      return teams;
    }
    return teams.where((team) => team.category == selectedCategory.value).toList();
  }

  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      List<TeamModel> loadedTeams = await _firebaseService.getTeams();
      teams.assignAll(loadedTeams);
      
    } catch (e) {
      errorMessage.value = 'Failed to load teams: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> followTeam(String teamId) async {
    try {
      if (_authController.currentUser.value == null) {
        Get.snackbar('Error', 'Please log in to follow teams');
        return;
      }

      String userId = _authController.currentUser.value!.id;
      
      // Check if already following
      if (_authController.currentUser.value!.followedTeams.contains(teamId)) {
        await _firebaseService.unfollowTeam(userId, teamId);
        Get.snackbar('Success', AppConstants.teamUnfollowedSuccess);
      } else {
        await _firebaseService.followTeam(userId, teamId);
        Get.snackbar('Success', AppConstants.teamFollowedSuccess);
      }
      
      // Refresh teams to update follower count
      await loadTeams();
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to follow/unfollow team: ${e.toString()}');
    }
  }

  bool isTeamFollowed(String teamId) {
    return _authController.currentUser.value?.followedTeams.contains(teamId) ?? false;
  }
}