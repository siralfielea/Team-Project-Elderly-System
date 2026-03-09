
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_app/models/user_settings.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

ThemeData getTheme(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return ThemeData.light( 
      );

    case AppThemeMode.dark:
      return ThemeData.dark();

    case AppThemeMode.highContrast:
      return ThemeData(
        colorScheme: const ColorScheme.highContrastLight(),
        useMaterial3: true,
      );
  }
}
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<UserSettings>();

    return MaterialApp(
      title: 'Elderly System',
      theme: getTheme(settings.themeMode),
      debugShowCheckedModeBanner: false,
      home: const RootRouter(),
    );
  }
}

/// RootRouter decides whether to show the Login screen or the App
class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isLoggedIn) {
      return const LoginPage();
    }

    return const HomePage();
  }
}
