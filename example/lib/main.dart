import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'simple_chat_screen.dart';
import 'detailed_example.dart';
import 'pagination_example.dart';
import 'custom_styling_example.dart';
import 'streaming_example.dart';
import 'markdown_example.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gen AI Chat UI Examples',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const ExampleList(),
    );
  }

  ThemeData _buildLightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF10A37F),
        brightness: Brightness.light,
        background: Colors.white,
        surface: const Color(0xFFF7F7F8),
        primary: const Color(0xFF10A37F),
        onPrimary: Colors.white,
        secondary: const Color(0xFFEEEEF0),
        onSecondary: const Color(0xFF111111),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF111111),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFE5E5E7),
            width: 1,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF111111),
      ),
      textTheme:
          GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: const Color(0xFF111111),
        displayColor: const Color(0xFF111111),
      ),
    );

    return baseTheme.copyWith(
      extensions: [
        CustomThemeExtension.light,
      ],
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF10A37F),
        brightness: Brightness.dark,
        background: const Color(0xFF1F1F28),
        surface: const Color(0xFF2A2B32),
        primary: const Color(0xFF10A37F),
        onPrimary: const Color(0xFFECECF1),
        secondary: const Color(0xFF40414F),
        onSecondary: const Color(0xFFECECF1),
      ),
      scaffoldBackgroundColor: const Color(0xFF1F1F28),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(0xFF2A2B32),
        foregroundColor: Color(0xFFECECF1),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: const Color(0xFF2A2B32),
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFECECF1),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFECECF1),
        displayColor: const Color(0xFFECECF1),
      ),
    );

    return baseTheme.copyWith(
      extensions: [
        CustomThemeExtension.dark,
      ],
    );
  }
}

class ExampleList extends StatelessWidget {
  const ExampleList({super.key});

  static final List<ExampleItem> examples = [
    ExampleItem(
      title: 'Simple Chat',
      subtitle: 'Basic chat implementation',
      icon: Icons.chat_outlined,
      route: const SimpleChatScreen(),
    ),
    ExampleItem(
      title: 'Detailed Example',
      subtitle: 'Advanced features demonstration',
      icon: Icons.chat_bubble_outline,
      route: const DetailedExample(),
      featured: true,
    ),
    ExampleItem(
      title: 'Pagination Example',
      subtitle: 'Load historical messages on scroll',
      icon: Icons.history,
      route: const PaginationExample(),
    ),
    ExampleItem(
      title: 'Custom Styling',
      subtitle: 'Theme customization with dark mode',
      icon: Icons.palette_outlined,
      route: const CustomStylingExample(),
    ),
    ExampleItem(
      title: 'Streaming Example',
      subtitle: 'Real-time message streaming',
      icon: Icons.stream,
      route: const StreamingExample(),
    ),
    ExampleItem(
      title: 'Markdown Support',
      subtitle: 'Rich text formatting in messages',
      icon: Icons.text_fields,
      route: const MarkdownExample(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Gen AI Chat UI',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: examples.length,
        itemBuilder: (context, index) {
          final example = examples[index];
          return Semantics(
            button: true,
            label: '${example.title} - ${example.subtitle}',
            child: _ExampleCard(
              example: example,
              onTap: () => _navigateToExample(context, example),
            ),
          );
        },
      ),
    );
  }

  void _navigateToExample(BuildContext context, ExampleItem example) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => example.route,
        settings: RouteSettings(name: example.title),
      ),
    );
  }
}

@immutable
class ExampleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget route;
  final bool featured;

  const ExampleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.featured = false,
  });
}

class _ExampleCard extends StatelessWidget {
  final ExampleItem example;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.example,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: example.featured
              ? BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary
                        .withOpacity(isDark ? 0.5 : 0.2),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Row(
            children: [
              _buildIcon(theme),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContent(theme),
              ),
              _buildTrailing(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        example.icon,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          example.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          example.subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(ThemeData theme, bool isDark) {
    if (example.featured) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Featured',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Icon(
      Icons.chevron_right,
      color: theme.colorScheme.onSurface.withOpacity(0.4),
    );
  }
}
