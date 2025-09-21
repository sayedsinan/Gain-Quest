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
  final RxString user = 'user'.obs;
  
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _firebaseService.authStateChanges().listen((User? user) async {
      print('Auth state changed: ${user?.uid}');
      print('Auth listener - _isNavigating: $_isNavigating, isLoading: ${isLoading.value}');
      
      if (user != null && !_isNavigating && !isLoading.value) {
        
        try {
          _isNavigating = true; 
          await _loadOrCreateUserProfile(user);
          isLoggedIn.value = true;
          print('Auth listener: navigating to home');
          _navigateToHome();
        } catch (e) {
          print('Error loading user profile in auth listener: $e');
          _isNavigating = false;
        }
      } else if (user == null) {
        currentUser.value = null;
        isLoggedIn.value = false;
        _isNavigating = false;
      } else {
        print('Auth listener: skipping navigation - already in process');
      }
    });
  }

  Future<void> checkAuthState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool(AppConstants.isFirstTimeKey) ?? true;

      User? user = _firebaseService.getCurrentUser();
      if (user != null) {
        await _loadOrCreateUserProfile(user);
        _navigateToHome();
      } else if (isFirstTime) {
        Get.offNamed('/onboarding');
      } else {
        Get.offNamed('/login');
      }
    } catch (e) {
      print('Error checking auth state: $e');
      Get.offNamed('/login');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _isNavigating = true;

      print('Starting sign in for: $email');

     
      try {
        await _firebaseService.signInWithEmailPassword(email, password);
      } catch (e) {
        print('Sign in method threw error, but checking current user...');
      }

      await Future.delayed(Duration(milliseconds: 1000));

    
      User? currentFirebaseUser = _firebaseService.getCurrentUser();
      
      if (currentFirebaseUser != null && currentFirebaseUser.email == email.trim()) {
        print('User is signed in successfully: ${currentFirebaseUser.uid}');
        

        await _loadOrCreateUserProfile(currentFirebaseUser);
        await _updateLastLogin(currentFirebaseUser.uid);

        print('Profile loaded/created in signIn, navigating to home...');
    
        _navigateToHome();
        
      } else {
        throw Exception('Sign in failed: User not authenticated');
      }
      
    } catch (e) {
      print('Sign in error: $e');
      errorMessage.value = _getErrorMessage(e);
      _isNavigating = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _isNavigating = true;

      print('Starting sign up for: $email');

      bool authSuccess = false;
      try {
        await _firebaseService.signUpWithEmailPassword(email, password);
        authSuccess = true;
      } catch (e) {
        print('Sign up method threw error: $e');
       
        if (e.toString().contains('List<Object?>\' is not a subtype of type \'PigeonUserDetails?\'')) {
          print('Known Firebase plugin error, but checking if auth actually succeeded...');
          authSuccess = true;
        } else {
          throw e;
        }
      }

      if (authSuccess) {
       
        await Future.delayed(Duration(milliseconds: 1500));

        User? currentFirebaseUser = _firebaseService.getCurrentUser();
        
        if (currentFirebaseUser != null && currentFirebaseUser.email == email.trim()) {
          print('User signed up successfully: ${currentFirebaseUser.uid}');
          
          UserModel newUser = UserModel(
            id: currentFirebaseUser.uid,
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

          await _firebaseService.initializeSampleData();

          print('Profile created for new user, navigating to home...');
          
          _navigateToHome();
        } else {
          throw Exception('Sign up failed: User not created or not authenticated');
        }
      }
    } catch (e) {
      print('Sign up error: $e');
      
      if (!e.toString().contains('List<Object?>\' is not a subtype of type \'PigeonUserDetails?\'')) {
        errorMessage.value = _getErrorMessage(e);
      }
      _isNavigating = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      _isNavigating = false;
      await _firebaseService.signOut();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offNamed('/login');
    } catch (e) {
      print('Sign out error: $e');
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
      print('Update profile error: $e');
      errorMessage.value = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _loadOrCreateUserProfile(User firebaseUser) async {
    print('Loading or creating user profile for: ${firebaseUser.uid}');
    
    try {

      UserModel? user = await _firebaseService.getUserProfile(firebaseUser.uid);
      
      if (user != null) {
        currentUser.value = user;
        print('Existing user profile loaded successfully');
      } else {
  
        print('No profile found, creating default profile...');
        
        UserModel defaultUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? 'unknown@example.com',
          name: firebaseUser.displayName ?? 'Test User',
          credits: AppConstants.initialCredits,
          totalWinnings: 0,
          betsPlaced: 0,
          betsWon: 0,
          followedTeams: [],
          achievements: [],
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

      
        await _firebaseService.createUserProfile(defaultUser);
        currentUser.value = defaultUser;
        
    
        await _firebaseService.initializeSampleData();
        
        print('Default user profile created successfully');
      }
    } catch (e) {
      print('Error in _loadOrCreateUserProfile: $e');
      throw e;
    }
  }

  void _navigateToHome() {
    print('_navigateToHome called');
    print('_isNavigating: $_isNavigating');
    print('currentUser.value: ${currentUser.value?.id}');
    
    if (currentUser.value != null) {
      print('Navigating to home page...');
      print('Current route before navigation: ${Get.currentRoute}');
  
      try {
      
        Get.offAllNamed('/home');
        print('Navigation attempted with offAllNamed');
      } catch (e) {
        print('offAllNamed failed: $e');
        try {
          Get.offNamed('/home');
          print('Navigation attempted with offNamed');
        } catch (e2) {
          print('offNamed failed: $e2');
          try {
            Get.toNamed('/home');
            print('Navigation attempted with toNamed');
          } catch (e3) {
            print('All navigation methods failed: $e3');
          }
        }
      }
      
      _isNavigating = false;
      print('Navigation completed, _isNavigating set to false');
    } else {
      print('Navigation conditions not met - no current user');
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    print('Loading user profile for: $userId');
    UserModel? user = await _firebaseService.getUserProfile(userId);
    if (user != null) {
      currentUser.value = user;
      print('User profile loaded successfully');
    } else {
      print('No user profile found');
      throw Exception('User profile not found');
    }
  }

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firebaseService.updateUserProfile(userId, {
        'lastLoginAt': DateTime.now().millisecondsSinceEpoch,
      });
      print('Last login updated');
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  String _getErrorMessage(dynamic error) {
    print('Processing error: $error');

  
    if (error.toString().contains('List<Object?>\' is not a subtype of type \'PigeonUserDetails?\'')) {
      return 'Authentication completed successfully. Please wait...';
    }

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
        case 'invalid-credential':
          return 'Invalid email or password. Please check your credentials.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        default:
          return error.message ?? AppConstants.authError;
      }
    }

    if (error.toString().contains('App Check')) {
      return 'Authentication service temporarily unavailable. Please try again.';
    }

    return error.toString().isNotEmpty ? error.toString() : AppConstants.unknownError;
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> retryLastOperation() async {
    errorMessage.value = '';
  }
}