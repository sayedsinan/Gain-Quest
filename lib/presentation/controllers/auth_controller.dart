import 'package:gain_quest/core/constants/app_constant.dart';
import 'package:gain_quest/data/models/user_model.dart';
import 'package:gain_quest/data/sources/firebase_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseService.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserProfile(user.uid);
        isLoggedIn.value = true;
      } else {
        currentUser.value = null;
        isLoggedIn.value = false;
      }
    });
  }

  Future<void> checkAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool(AppConstants.isFirstTimeKey) ?? true;
    
    User? user = _firebaseService.getCurrentUser();
    if (user != null) {
      await _loadUserProfile(user.uid);
      Get.offNamed('/home');
    } else if (isFirstTime) {
      Get.offNamed('/onboarding');
    } else {
      Get.offNamed('/login');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      UserCredential? credential = await _firebaseService.signInWithEmailPassword(email, password);
      
      if (credential?.user != null) {
        await _loadUserProfile(credential!.user!.uid);
        await _updateLastLogin(credential.user!.uid);
        Get.offNamed('/home');
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      UserCredential? credential = await _firebaseService.signUpWithEmailPassword(email, password);
      
      if (credential?.user != null) {
        // Create user profile
        UserModel newUser = UserModel(
          id: credential!.user!.uid,
          email: email,
          name: name,
          credits: AppConstants.initialCredits,
          totalWinnings: 0,
          betsPlaced: 0,
          betsWon: 0,
          followedTeams: [],
          achievements: [],
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        
        await _firebaseService.createUserProfile(newUser);
        currentUser.value = newUser;
        
        // Initialize sample data if needed
        await _firebaseService.initializeSampleData();
        
        Get.offNamed('/home');
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _firebaseService.signOut();
      currentUser.value = null;
      Get.offNamed('/login');
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      if (currentUser.value != null) {
        await _firebaseService.updateUserProfile(currentUser.value!.id, data);
        await _loadUserProfile(currentUser.value!.id);
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      UserModel? user = await _firebaseService.getUserProfile(userId);
      currentUser.value = user;
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firebaseService.updateUserProfile(userId, {
        'lastLoginAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'network-request-failed':
          return AppConstants.networkError;
        default:
          return error.message ?? AppConstants.authError;
      }
    }
    return AppConstants.unknownError;
  }

  void clearError() {
    errorMessage.value = '';
  }
}