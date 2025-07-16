import 'package:flutter/material.dart';
import 'package:stocks/clothing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/nav.jpg',
            fit: BoxFit.cover,
          ),

          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stylized Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        for (int i = 0; i < "ELEGANCE".length; i++)
                          TextSpan(
                            text: "ELEGANCE"[i],
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 5,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Subtitle and Button
                  Column(
                    children: [
                      Text(
                        "Fabulous Look",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: size.width * 0.7,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const clothing(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.explore_outlined),
                          label: const Text("Explore"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
