import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/screens/habit_tracker/widgets/articles.dart';
import 'package:mental_health_app/screens/profile/profile.dart';

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leafAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller for Leaves (wind effect)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _leafAnimation = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF081423), // Dark blue night sky
                    Color(0xFF000000), // Deep black bottom
                  ],
                  stops: [0.3, 1], // Transition point
                ),
              ),
            ),
          ),

          // Stars positioned only in the top part of the screen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.4, // Restrict stars to upper 40% of screen
            child: Stack(
              children: List.generate(
                50,
                (index) => Positioned(
                  top:
                      Random().nextDouble() * (screenHeight * 0.4), // Upper 40%
                  left: Random().nextDouble() * screenWidth,
                  child: BlinkingStar(),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _leafAnimation,
            builder: (context, child) {
              return Positioned(
                top: 20,
                left:
                    MediaQuery.of(context).size.width / 1.9 +
                    _leafAnimation.value,
                child: Transform.rotate(
                  angle: 80,
                  child: Image.asset(
                    'assets/images/components/leaf.png',
                    fit: BoxFit.cover,
                    width: 210,
                    height: 220,
                  ),
                ),
              );
            },
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ProfilePage());
                            },
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Mar 5",
                        style: TextStyle(color: Colors.grey, fontSize: 16),

                        strutStyle: StrutStyle(height: 1.5),
                      ),
                      SizedBox(height: 30),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 20,
                      //     left: 20,
                      //     right: 20,
                      //   ),
                      //   child: Text(
                      //     "What's new",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 10,
                      //   ),
                      //   padding: EdgeInsets.all(15),
                      //   decoration: BoxDecoration(
                      //     color: Colors.purple.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Mood Tracker Beta",
                      //         style: TextStyle(
                      //           color: Colors.purple,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward_ios,
                      //         color: Colors.purple,
                      //         size: 16,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Text(
                      //     "Check in with your mood\nIncrease emotional awareness by tracking your moods",
                      //     style: TextStyle(color: Colors.white70, fontSize: 14),
                      //   ),
                      // ),

                      // Morning section
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 0,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wb_twilight,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Morning",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      HabitCards(
                        habit: "Breath",
                        mood: "Anger",
                        exercise: "3 min meditation",
                        image: 'assets/images/components/anger.png',
                      ),
                      // articles
                      ArticlesCards(),

                      // Day Section
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 0,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wb_sunny,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Day",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      HabitCards(
                        habit: "Breath",
                        mood: "Anger",
                        exercise: "3 min meditation",
                        image: 'assets/images/components/anger.png',
                      ),

                      // articles
                      ArticlesCards(),
                      // Evening
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 0,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wb_cloudy_sharp,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Evening",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      HabitCards(
                        habit: "Breath",
                        mood: "Anger",
                        exercise: "3 min meditation",
                        image: 'assets/images/components/anger.png',
                      ),

                      // articles
                      ArticlesCards(),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 0,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wb_cloudy_sharp,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Night",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      HabitCards(
                        habit: "Breath",
                        mood: "Anger",
                        exercise: "3 min meditation",
                        image: 'assets/images/components/anger.png',
                      ),

                      // articles
                      ArticlesCards(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlesCards extends StatelessWidget {
  const ArticlesCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 7, 35, 59),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.article, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Articles",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ArticlesScreen());
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "5 healthy ways to release anger",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            "2 min read",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class HabitCards extends StatelessWidget {
  const HabitCards({
    super.key,
    required this.image,
    required this.mood,
    required this.exercise,
    required this.habit,
  });

  final String image, mood, exercise, habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 7, 35, 59),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.air, color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    habit,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                mood,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                exercise,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Image.asset(image, width: 100, fit: BoxFit.cover),
        ],
      ),
    );
  }
}

// Blinking Star Widget
class BlinkingStar extends StatefulWidget {
  @override
  _BlinkingStarState createState() => _BlinkingStarState();
}

class _BlinkingStarState extends State<BlinkingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  final Random _random = Random();
  late double size;

  @override
  void initState() {
    super.initState();

    size = _random.nextDouble() * 3 + 2; // Star size between 2-5

    // Animation setup with random blinking duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _random.nextInt(2000) + 500),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white70.withOpacity(0.1),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
