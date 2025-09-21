  import 'package:get/get.dart';
  import 'package:gain_quest/data/models/team_model.dart';
  import 'package:gain_quest/data/sources/firebase_service.dart';
  import 'package:gain_quest/presentation/controllers/auth_controller.dart';

  class TeamsController extends GetxController {
    final FirebaseService _firebaseService = Get.find<FirebaseService>();
    final AuthController _authController = Get.find<AuthController>();

  
    final RxList<TeamModel> teams = <TeamModel>[].obs;
    var categories = <String>[].obs;
    final RxString selectedCategory = 'All'.obs;
    final RxBool isLoading = false.obs;
    final RxString errorMessage = ''.obs;

    List<TeamModel> get filteredTeams {
      if (selectedCategory.value == 'All') {
        return teams;
      }
      return teams
          .where((team) => team.category == selectedCategory.value)
          .toList();
    }

    @override
    void onInit() {
      super.onInit();
      loadTeams();
    }

    Future<void> loadTeams() async {
      try {
        isLoading.value = true;
        errorMessage.value = '';

        print('Loading teams...');

        final loadedTeams = await _firebaseService.getTeams();
        teams.value = loadedTeams;

        Set<String> categorySet = {'All'};
        for (var team in loadedTeams) {
          if (team.category.isNotEmpty) {
            categorySet.add(team.category);
          }
        }
        categories.value = categorySet.toList();

        print('Loaded ${loadedTeams.length} teams');

      } catch (e) {
        print('Error loading teams: $e');
        errorMessage.value = 'Failed to load teams: $e';

        Get.snackbar(
          'Error',
          'Failed to load teams. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      } finally {
        isLoading.value = false;
      }
    }

    void selectCategory(String category) {
      selectedCategory.value = category;
      print('Selected category: $category');
      print('Filtered teams count: ${filteredTeams.length}');
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

        final teamIndex = teams.indexWhere((team) => team.id == teamId);
        if (teamIndex != -1) {
          teams[teamIndex] = teams[teamIndex].copyWith(
            followersCount: teams[teamIndex].followersCount + 1,
          );
        }

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

        final teamIndex = teams.indexWhere((team) => team.id == teamId);
        if (teamIndex != -1) {
          teams[teamIndex] = teams[teamIndex].copyWith(
            followersCount: teams[teamIndex].followersCount - 1,
          );
        }

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

    TeamModel? getTeamById(String teamId) {
      try {
        return teams.firstWhere((team) => team.id == teamId);
      } catch (e) {
        return null;
      }
    }

    void clearError() {
      errorMessage.value = '';
    }
  }
