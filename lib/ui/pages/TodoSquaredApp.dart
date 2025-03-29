// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'timer_page.dart';
import 'dashboard_page.dart';
import 'grid_page.dart';

class TodoSquaredApp extends StatefulWidget {
  const TodoSquaredApp({super.key});

  @override
  State<TodoSquaredApp> createState() => _TodoSquaredAppState();
}

class _TodoSquaredAppState extends State<TodoSquaredApp> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    // const TimerScr(initialDuration: Duration(minutes: 1)),
    const GridPage(),
    const DashboardPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavBarV2(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarV2 extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBarV2({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 100,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, (size.width * 0.6).toDouble()),
                    painter: BNBCustomPainter(),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -15),
                          child: _buildNavItem(0, Icons.timer, "Timer"),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: _buildNavItem(1, Icons.dashboard, "Dashboard"),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -15),
                          child: _buildNavItem(2, Icons.settings, "Settings"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = widget.currentIndex == index;
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFFEFF1FF) : const Color(0xFF27273A),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 32,
          color: isSelected ? const Color(0xFF494970) : const Color(0xFFEFF1FF),
        ),
        onPressed: () => widget.onTap(index),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill1 = Paint()
      ..color = const Color(0xFF3D3D50)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_1 = Path();
    path_1.moveTo(size.width * -0.2, size.height * 1.7);
    path_1.cubicTo(size.width * -0.2, size.height * -0.5, size.width * 1.2,
        size.height * -0.5, size.width * 1.2, size.height * 1.7);
    path_1.quadraticBezierTo(size.width * 1.2, size.height * 0.75,
        size.width * 1.2, size.height * 1);
    path_1.lineTo(size.width * -0.2, size.height * 1);
    path_1.quadraticBezierTo(size.width * -0.2, size.height * 0.75,
        size.width * -0.2, size.height * 0.5);
    path_1.close();

    canvas.drawPath(path_1, paintFill1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
