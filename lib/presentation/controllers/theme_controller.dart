import 'package:flutter/material.dart';
import 'package:gain_quest/core/constants/app_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  
  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(themeMode);
    _saveThemeToPrefs();
  }

  void setDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
    _saveThemeToPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(AppConstants.themeKey) ?? false;
    Get.changeThemeMode(themeMode);
  }

  Future<void> _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.themeKey, isDarkMode.value);
  }
}