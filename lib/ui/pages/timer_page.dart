import 'package:flutter/material.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../services/notif_service.dart';

class TimerScr extends StatefulWidget {
  final Duration initialDuration;

  const TimerScr({super.key, required this.initialDuration});

  @override
  _TimerScrState createState() => _TimerScrState();
}

class _TimerScrState extends State<TimerScr> {
  late final CountDownController _controller;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
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
            title: const Text(
              'Timer',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeonCircularTimer(
                backgroundColor:
                    isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
                width: 200,
                duration: widget.initialDuration.inSeconds,
                controller: _controller,
                isTimerTextShown: true,
                neumorphicEffect: true,
                autoStart: false,
                textStyle: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? const Color(0xFFEFF1FF) : Colors.black,
                  fontFamily: GoogleFonts.interTight().fontFamily,
                ),
                outerStrokeColor:
                    isDarkMode ? const Color(0xFF27273A) : Colors.blue,
                innerFillGradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
                neonGradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
                strokeWidth: 10,
                isReverse: true,
                isReverseAnimation: true,
                textFormat: TextFormat.HH_MM_SS,
                onComplete: () {
                  // Notify when the timer is done
                  LocalNotifications.showSimpleNotification(
                    title: 'Timer Done!',
                    body: 'Your timer has completed.',
                    payload: 'timer_done',
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller.pause();
                      _isPaused = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27273A),
                      shape: const CircleBorder(),
                      minimumSize: const Size(60, 60),
                    ),
                    child:
                        const Icon(Icons.pause, color: Colors.white, size: 30),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isPaused) {
                        _controller.resume();
                      } else {
                        _controller.start();
                        _isPaused = true;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27273A),
                      shape: const CircleBorder(),
                      minimumSize: const Size(60, 60),
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 30),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.restart(
                          duration: widget.initialDuration.inSeconds);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27273A),
                      shape: const CircleBorder(),
                      minimumSize: const Size(60, 60),
                    ),
                    child: const Icon(Icons.restart_alt,
                        color: Colors.white, size: 30),
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
