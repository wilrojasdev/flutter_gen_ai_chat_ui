import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application state model for the comprehensive AI Chat example
class AppState extends ChangeNotifier {
  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  bool _isStreaming = true;
  bool _showCodeBlocks = true;
  bool _enableAnimation = true;
  bool _showWelcomeMessage = true;
  bool _persistentExampleQuestions = false;

  // UI customization
  double _chatMaxWidth = 900;
  double _fontSize = 15;
  double _messageBorderRadius = 16;
  String _aiName = 'Insight AI';

  // State
  bool _isInitialized = false;
  late SharedPreferences _prefs;

  // Constructor
  AppState() {
    _loadPreferences();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isStreaming => _isStreaming;
  bool get showCodeBlocks => _showCodeBlocks;
  bool get enableAnimation => _enableAnimation;
  bool get showWelcomeMessage => _showWelcomeMessage;
  bool get persistentExampleQuestions => _persistentExampleQuestions;
  double get chatMaxWidth => _chatMaxWidth;
  double get fontSize => _fontSize;
  double get messageBorderRadius => _messageBorderRadius;
  String get aiName => _aiName;
  bool get isInitialized => _isInitialized;

  // Load preferences from storage
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeString = _prefs.getString('theme_mode');
    _themeMode = _parseThemeMode(themeModeString);

    // Load feature flags
    _isStreaming = _prefs.getBool('is_streaming') ?? true;
    _showCodeBlocks = _prefs.getBool('show_code_blocks') ?? true;
    _enableAnimation = _prefs.getBool('enable_animation') ?? true;
    _showWelcomeMessage = _prefs.getBool('show_welcome_message') ?? true;
    _persistentExampleQuestions =
        _prefs.getBool('persistent_example_questions') ?? false;

    // Load UI customization
    _chatMaxWidth = _prefs.getDouble('chat_max_width') ?? 900;
    _fontSize = _prefs.getDouble('font_size') ?? 15;
    _messageBorderRadius = _prefs.getDouble('message_border_radius') ?? 16;
    _aiName = _prefs.getString('ai_name') ?? 'Insight AI';

    _isInitialized = true;
    notifyListeners();
  }

  // Parse theme mode from string
  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Convert theme mode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  // Toggle between theme modes
  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }
    _prefs.setString('theme_mode', _themeModeToString(_themeMode));
    notifyListeners();
  }

  // Set a specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setString('theme_mode', _themeModeToString(_themeMode));
    notifyListeners();
  }

  // Toggle streaming mode
  void toggleStreaming() {
    _isStreaming = !_isStreaming;
    _prefs.setBool('is_streaming', _isStreaming);
    notifyListeners();
  }

  // Toggle animation
  void toggleAnimation() {
    _enableAnimation = !_enableAnimation;
    _prefs.setBool('enable_animation', _enableAnimation);
    notifyListeners();
  }

  // Toggle welcome message
  void toggleWelcomeMessage() {
    _showWelcomeMessage = !_showWelcomeMessage;
    _prefs.setBool('show_welcome_message', _showWelcomeMessage);
    notifyListeners();
  }

  // Toggle code blocks
  void toggleCodeBlocks() {
    _showCodeBlocks = !_showCodeBlocks;
    _prefs.setBool('show_code_blocks', _showCodeBlocks);
    notifyListeners();
  }

  // Toggle persistent example questions
  void togglePersistentExampleQuestions() {
    _persistentExampleQuestions = !_persistentExampleQuestions;
    _prefs.setBool('persistent_example_questions', _persistentExampleQuestions);
    notifyListeners();
  }

  // Update chat max width
  void setChatMaxWidth(double width) {
    _chatMaxWidth = width;
    _prefs.setDouble('chat_max_width', width);
    notifyListeners();
  }

  // Update font size
  void setFontSize(double size) {
    _fontSize = size;
    _prefs.setDouble('font_size', size);
    notifyListeners();
  }

  // Update message border radius
  void setMessageBorderRadius(double radius) {
    _messageBorderRadius = radius;
    _prefs.setDouble('message_border_radius', radius);
    notifyListeners();
  }

  // Update AI name
  void setAiName(String name) {
    _aiName = name;
    _prefs.setString('ai_name', name);
    notifyListeners();
  }
}
