import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isStreaming = true;
  bool _showCodeBlocks = true;
  bool _enableAnimation = true;

  late final SharedPreferences _prefs;

  AppState() {
    _loadPreferences();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isStreaming => _isStreaming;
  bool get showCodeBlocks => _showCodeBlocks;
  bool get enableAnimation => _enableAnimation;

  // Init preferences
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = _prefs.getString('theme_mode') == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    _isStreaming = _prefs.getBool('is_streaming') ?? true;
    _showCodeBlocks = _prefs.getBool('show_code_blocks') ?? true;
    _enableAnimation = _prefs.getBool('enable_animation') ?? true;
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(
        'theme_mode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  // Toggle streaming
  void toggleStreaming() {
    _isStreaming = !_isStreaming;
    _prefs.setBool('is_streaming', _isStreaming);
    notifyListeners();
  }

  // Toggle code blocks
  void toggleCodeBlocks() {
    _showCodeBlocks = !_showCodeBlocks;
    _prefs.setBool('show_code_blocks', _showCodeBlocks);
    notifyListeners();
  }

  // Toggle animation
  void toggleAnimation() {
    _enableAnimation = !_enableAnimation;
    _prefs.setBool('enable_animation', _enableAnimation);
    notifyListeners();
  }
}
