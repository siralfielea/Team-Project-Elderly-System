import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends ChangeNotifier {
    bool _darkMode = false;
    bool _highContrast = false;
    String _mapIcon = 'default';

    bool get darkMode => _darkMode;
    bool get highContrast => _highContrast;
    String get mapIcon => _mapIcon;

    void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
    _savePrefs();
    }

    void toggleHighContrast() {
    _highContrast = !_highContrast;
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
    _darkMode = prefs.getBool('darkMode') ?? false;
    _highContrast = prefs.getBool('hihContrast') ?? false;
    _mapIcon = prefs.getString('mapIcon') ?? 'default';
    notifyListeners();
    }

    Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkMode);
    prefs.setBool('highContrast', _highContrast);
    prefs.setString('mapIcon', _mapIcon);
    }
} 
