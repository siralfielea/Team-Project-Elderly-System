import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AppThemeMode { light, dark, highContrast }

class UserSettings extends ChangeNotifier {

    AppThemeMode _themeMode = AppThemeMode.light;
    String _mapIcon = 'default';

    AppThemeMode get themeMode => _themeMode;
    String get mapIcon => _mapIcon;

    void setThemeMode(AppThemeMode mode) {
        _themeMode = mode;
        notifyListeners();
        _savePrefs();
    }

    void setMapIcon(String iconName) {
    _mapIcon = iconName;
    notifyListeners();
    _savePrefs();
    }

    Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString('themeMode');
    if (savedTheme != null) {
        _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => AppThemeMode.light,
    );
    }
    _mapIcon = prefs.getString('mapIcon') ?? 'default';
    notifyListeners();
    }

    Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeMode.name);
    prefs.setString('mapIcon', _mapIcon);
    }
} 
