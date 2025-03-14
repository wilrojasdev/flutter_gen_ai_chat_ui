import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
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

  late SharedPreferences _prefs;
  bool _isInitialized = false;

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
  bool get isInitialized => _isInitialized;

  // Init preferences
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeString = _prefs.getString('theme_mode');
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    } else {
      _themeMode = ThemeMode.system;
    }

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

    _isInitialized = true;
    notifyListeners();
  }

  // Toggle theme
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

    _saveThemeMode();
    notifyListeners();
  }

  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }

  void _saveThemeMode() {
    switch (_themeMode) {
      case ThemeMode.light:
        _prefs.setString('theme_mode', 'light');
        break;
      case ThemeMode.dark:
        _prefs.setString('theme_mode', 'dark');
        break;
      case ThemeMode.system:
        _prefs.setString('theme_mode', 'system');
        break;
    }
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

  // Toggle welcome message
  void toggleWelcomeMessage() {
    _showWelcomeMessage = !_showWelcomeMessage;
    _prefs.setBool('show_welcome_message', _showWelcomeMessage);
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

  // Reset all preferences to defaults
  void resetToDefaults() {
    _themeMode = ThemeMode.system;
    _isStreaming = true;
    _showCodeBlocks = true;
    _enableAnimation = true;
    _showWelcomeMessage = true;
    _persistentExampleQuestions = false;
    _chatMaxWidth = 900;
    _fontSize = 15;
    _messageBorderRadius = 16;

    // Save all defaults
    _saveThemeMode();
    _prefs.setBool('is_streaming', _isStreaming);
    _prefs.setBool('show_code_blocks', _showCodeBlocks);
    _prefs.setBool('enable_animation', _enableAnimation);
    _prefs.setBool('show_welcome_message', _showWelcomeMessage);
    _prefs.setBool('persistent_example_questions', _persistentExampleQuestions);
    _prefs.setDouble('chat_max_width', _chatMaxWidth);
    _prefs.setDouble('font_size', _fontSize);
    _prefs.setDouble('message_border_radius', _messageBorderRadius);

    notifyListeners();
  }
}
