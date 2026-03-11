import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AppThemeMode { light, dark, highContrast }
enum MapIcon { circle, man, woman, wheelchair }

class UserSettings extends ChangeNotifier {

    AppThemeMode _themeMode = AppThemeMode.light;
    MapIcon _mapIcon = MapIcon.circle;

    AppThemeMode get themeMode => _themeMode;
    MapIcon get mapIcon => _mapIcon;

    void setThemeMode(AppThemeMode mode) {
        _themeMode = mode;
        notifyListeners();
        _savePrefs();
    }

    void setMapIcon(MapIcon iconName) {
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
    final savedMapIcon = prefs.getString('mapIcon');
    if (savedMapIcon != null) {
        _mapIcon = MapIcon.values.firstWhere( 
            (e) => e.name == savedMapIcon,
            orElse: () => MapIcon.circle,
            );
            }
    notifyListeners();
    }

    Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeMode.name);
    prefs.setString('mapIcon', _mapIcon.name);
    }
} 
