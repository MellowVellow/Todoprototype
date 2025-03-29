import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSoundPage extends StatefulWidget {
  const NotificationSoundPage({super.key});

  @override
  State<NotificationSoundPage> createState() => _NotificationSoundPageState();
}

class _NotificationSoundPageState extends State<NotificationSoundPage> {
  String _selectedSound = 'default_sound'; // Default sound
  final List<String> _soundOptions = [
    'default_sound',
    'sound_1',
    'sound_2',
    // Add more sound options as needed
  ];

  @override
  void initState() {
    super.initState();
    _loadSound();
  }

  Future<void> _loadSound() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSound = prefs.getString('notification_sound') ?? 'default_sound';
    });
  }

  Future<void> _selectSound(String? sound) async {
    if (sound != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedSound = sound;
        prefs.setString('notification_sound', sound);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Sound')),
      body: Center(
        child: DropdownButton<String>(
          value: _selectedSound,
          onChanged: _selectSound,
          items: _soundOptions.map((String sound) {
            return DropdownMenuItem<String>(
              value: sound,
              child: Text(sound
                  .replaceAll('_', ' ')
                  .capitalize()), // Capitalize for better display
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
