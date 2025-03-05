import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = "1W";
  List<FlSpot> _graphData = [];

  @override
  void initState() {
    super.initState();
    _generateGraphData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _leafAnimation = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _generateGraphData() {
    setState(() {
      _graphData =
          _selectedFilter == "1W"
              ? [FlSpot(0, 2), FlSpot(1, 2.5), FlSpot(2, 3), FlSpot(3, 3.5)]
              : [FlSpot(0, 2), FlSpot(2, 4), FlSpot(4, 3), FlSpot(6, 5)];
    });
  }

  late AnimationController _controller;
  late Animation<double> _leafAnimation;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
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
          // Stars in upper 40%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.4,
            child: Stack(
              children: List.generate(
                50,
                (index) => Positioned(
                  top: _random.nextDouble() * (screenHeight * 0.4),
                  left: _random.nextDouble() * screenWidth,
                  child: const BlinkingStar(),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.12),
                CircleAvatar(
                  radius: screenWidth * 0.15, // Adjust size dynamically
                  backgroundImage: const AssetImage('assets/profile_pic.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Krishnab Das",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "krishnab@gmail.com",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),

                // Mood Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ), // Add spacing between the containers
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 35, 59),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Mood",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CircleAvatar(
                              radius: screenWidth * 0.08,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/mood_animation.gif", // Your GIF file
                                  fit: BoxFit.cover,
                                  width:
                                      screenWidth *
                                      0.16, // Ensures the image fits within the avatar
                                  height: screenWidth * 0.16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 35, 59),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Streaks",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amberAccent.withOpacity(
                                          0.8,
                                        ),
                                        spreadRadius: 4,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "7", // Replace with dynamic streak count
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.08,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Icon()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = "1W";
                          _generateGraphData();
                        });
                      },
                      child: Text(
                        "1W",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              _selectedFilter == "1W"
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = "1M";
                          _generateGraphData();
                        });
                      },
                      child: Text(
                        "1M",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              _selectedFilter == "1M"
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  width: screenWidth * 0.9,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 1,
                        getDrawingHorizontalLine:
                            (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                        getDrawingVerticalLine:
                            (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "Day ${value.toInt()}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _graphData,
                          isCurved: true,
                          curveSmoothness: 0.5,
                          color: Colors.blue,
                          barWidth: 1,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.3),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter:
                                (spot, percent, barData, index) =>
                                    FlDotCirclePainter(
                                      radius: 2,
                                      color: Colors.blue,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BlinkingStar extends StatefulWidget {
  const BlinkingStar({super.key});

  @override
  _BlinkingStarState createState() => _BlinkingStarState();
}

class _BlinkingStarState extends State<BlinkingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late double size;

  @override
  void initState() {
    super.initState();
    size = _random.nextDouble() * 3 + 2;
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

// Global random instance to prevent hot reload issues
final Random _random = Random();
