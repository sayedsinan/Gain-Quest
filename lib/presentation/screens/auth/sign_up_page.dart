import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/core/widgets/custom_text_field.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Get.theme.colorScheme.secondary,
              Get.theme.colorScheme.secondary.withOpacity(0.8),
              Get.theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Join Sales Bets',
                            style: Get.theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start winning with zero risk!',
                            style: Get.theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Sign up Form
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create Account',
                              style: Get.theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 24),
                            
                            CustomTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              hintText: 'Enter your full name',
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Name is required';
                                }
                                if (value!.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Email is required';
                                }
                                if (!GetUtils.isEmail(value!)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hintText: 'Enter your password',
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Password is required';
                                }
                                if (value!.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hintText: 'Confirm your password',
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Terms agreement
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Get.theme.colorScheme.secondary.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Get.theme.colorScheme.secondary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'By signing up, you agree to our Terms of Service and Privacy Policy. Start with 1,000 free credits!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 24),
                            
                            Obx(() => CustomButton(
                              text: 'Create Account',
                              onPressed: _authController.isLoading.value ? null : _signUp,
                              isLoading: _authController.isLoading.value,
                            )),
                            
                            Obx(() {
                              if (_authController.errorMessage.value.isNotEmpty) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.error.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Get.theme.colorScheme.error.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Get.theme.colorScheme.error,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _authController.errorMessage.value,
                                            style: TextStyle(
                                              color: Get.theme.colorScheme.error,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Sign in option
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              'Sign In',
                              style: Get.theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.clearError();
      _authController.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }
}