import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'ToDoSquaredApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialPageWidget extends StatefulWidget {
  const TutorialPageWidget({super.key});

  @override
  State<TutorialPageWidget> createState() => _TutorialPageWidgetState();
}

class _TutorialPageWidgetState extends State<TutorialPageWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 39, 39, 58),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 35,
          actions: [
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
              onPressed: () async {
                // Save that user has seen the tutorial
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('has_seen_tutorial', true);

                if (!mounted) return;
                Navigator.pushReplacement(
                  // Use pushReplacement instead of push
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TodoSquaredApp(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildPage(
                          context,
                          title: 'Welcome!',
                          description:
                              'Timebox your activities and routines with this productivity app!',
                          imageUrl: 'assets/images/tutorial1.png',
                          isAsset: true,
                        ),
                        buildPage(
                          context,
                          title: 'Plan Them!',
                          description:
                              "Planning your activities becomes as simple as drag n' drop!",
                          imageUrl: 'assets/images/tutorial2.png',
                          isAsset: true,
                        ),
                        buildPage(
                          context,
                          title: 'Time Them!',
                          description:
                              'Start your task timer just by pressing the timebox for a few seconds!',
                          imageUrl: 'assets/images/tutorial3.png',
                          isAsset: true,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 3,
                          effect: const SlideEffect(
                            spacing: 8.0,
                            radius: 8.0,
                            dotWidth: 8.0,
                            dotHeight: 8.0,
                            dotColor: Colors.grey,
                            activeDotColor: Color.fromARGB(255, 61, 61, 80),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    bool isAsset = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: screenHeight * 0, left: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerLeft, // Align to the left
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 45.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.02,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: isAsset
                ? Image.asset(
                    imageUrl,
                    width: 308.0,
                    height: 380.0,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    width: 308.0,
                    height: 380.0,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 0),
          ),
        ),
      ],
    );
  }
}
