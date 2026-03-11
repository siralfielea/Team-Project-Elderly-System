
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_app/models/user_settings.dart';

class SettingsPage extends StatelessWidget{
    const SettingsPage({super.key});

    @override
    Widget build(BuildContext context) {
        final settings = context.watch<UserSettings>();
        return Scaffold( 
            appBar: AppBar( 
                title: const Text('Settings'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(24),
                child: Center( 
                    child: Column( 
                        children: [ 
                            Text('Appearance'),
                            SegmentedButton<AppThemeMode>(
                            segments: const [
                                 ButtonSegment( 
                                    value: AppThemeMode.dark,
                                    label: const Text('Dark Mode'),
                                    icon: Icon(Icons.dark_mode),
                                    ),
                                ButtonSegment( 
                                    value: AppThemeMode.light,
                                    label: const Text('Light Mode'),
                                    icon: Icon(Icons.light_mode),
                                    ),
                                ButtonSegment( 
                                    value: AppThemeMode.highContrast,
                                    label: const Text('High Contrast'),
                                    icon: Icon(Icons.contrast),
                                    ),
                                ], 
                            selected: {settings.themeMode},
                            onSelectionChanged: (Set<AppThemeMode> selection) {
                                context.read<UserSettings>().setThemeMode(selection.first);
                                },
                            ),
                            Text('Map Icon'),
                            RadioGroup<MapIcon>(
                              groupValue: settings.mapIcon,
                              onChanged: (value) {
                                context.read<UserSettings>().setMapIcon(value!);
                              },
                              child: Column(
                                children: const [
                                  RadioListTile(value: MapIcon.circle, title: Icon(Icons.circle)),
                                  RadioListTile(value: MapIcon.woman, title: Icon(Icons.girl)),
                                  RadioListTile(value: MapIcon.man, title: Icon(Icons.boy)),
                                  RadioListTile(value: MapIcon.wheelchair, title: Icon(Icons.accessible)),
                                ],
                              ),
                            )
                        ],
                    ),
                ),
                ),
        );
}
}
