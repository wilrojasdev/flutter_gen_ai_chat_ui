import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/settings_drawer.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  final List<String> _pageLabels = [
    'Chat Demo',
    'Customization',
    'Advanced Features'
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(_pageLabels[_currentPage]),
              leading: _currentPage == 0
                  ? IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Clear Chat',
                      onPressed: () {
                        // Clear the chat
                        ChatScreen.clearMessages(context);
                      },
                    )
                  : null,
              actions: [
                // Welcome message toggle button (only on chat page)
                if (_currentPage == 0)
                  IconButton(
                    icon: const Icon(Icons.message_outlined),
                    tooltip: 'Toggle Welcome Message',
                    onPressed: () {
                      // Call the toggle method in ChatScreen
                      ChatScreen.toggleWelcomeMessage(context);
                    },
                  ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: IconButton(
                    key: ValueKey<bool>(isDarkMode),
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: isDarkMode ? Colors.amber : Colors.blueGrey,
                    ),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ],
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            endDrawer: const SettingsDrawer(),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                // Main chat demonstration
                ChatScreen(),

                // Customization examples page
                Center(
                  child: Text('Customization Examples - Coming Soon'),
                ),

                // Advanced features page
                Center(
                  child: Text('Advanced Features - Coming Soon'),
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentPage,
              onDestinationSelected: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuint,
                );
              },
              elevation: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  selectedIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Chat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.palette_outlined),
                  selectedIcon: Icon(Icons.palette),
                  label: 'Customize',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: 'Advanced',
                ),
              ],
            ),
            floatingActionButton: null,
          ),
        );
      },
    );
  }
}
