import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'tutorial_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todosquared/ui/pages/TodoSquaredApp.dart';

class SplashScr extends StatefulWidget {
  const SplashScr({super.key});

  @override
  State<SplashScr> createState() => _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => hasSeenTutorial
            ? const TodoSquaredApp()
            : const TutorialPageWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 39, 39, 58), // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            // Logo
            Image.asset(
              "assets/images/logotodosquared.png",
              width: 150.0, // Adjust logo width
              height: 150.0, // Adjust logo height
            ),
            const SizedBox(height: 10.0), // Spacing between logo and text
            // Animated Text
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "todo-squared",
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 48.0, // Text size
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  speed: const Duration(milliseconds: 100), // Typing speed
                ),
              ],
              repeatForever: true, // Loop animation
            ),
          ],
        ),
      ),
    );
  }
}
