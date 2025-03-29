import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todosquared/ui/pages/notification_sound_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = value;
      prefs.setBool('notifications_enabled', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkMode = themeNotifier.isDarkMode;

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          appBar: AppBar(
            backgroundColor:
                isDarkMode ? const Color(0xFF3D3D50) : const Color(0xFF3D3D50),
            title:
                const Text('Settings', style: TextStyle(color: Colors.white)),
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Account'),
                tiles: [
                  SettingsTile.navigation(
                    title: const Text('Profile'),
                    leading: const Icon(Icons.person),
                    value: const Text('guest'),
                  ),
                  SettingsTile.navigation(
                    title: const Text('Email'),
                    leading: const Icon(Icons.email),
                    value: const Text('guest@example.com'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Notifications'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Enable Notifications'),
                    leading: const Icon(Icons.notifications),
                    initialValue: _notificationsEnabled,
                    onToggle: _toggleNotifications,
                  ),
                  SettingsTile.navigation(
                    title: const Text('Notification Sound'),
                    leading: const Icon(Icons.music_note),
                    onPressed: (context) {
                      // Navigate to sound customization page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NotificationSoundPage()),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Theme'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Dark Mode'),
                    leading: const Icon(Icons.dark_mode),
                    initialValue: isDarkMode,
                    onToggle: (value) {
                      themeNotifier.toggleTheme();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
