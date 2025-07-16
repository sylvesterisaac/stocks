import 'dart:async';

import 'package:flutter/material.dart';

import 'Homepage.dart';

// ignore: camel_case_types
class flashScreen extends StatefulWidget {
  const flashScreen({Key? key}) : super(key: key);

  @override
  State<flashScreen> createState() => _flashScreenState();
}

// ignore: camel_case_types
class _flashScreenState extends State<flashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 60),
              const SizedBox(height: 20),
              Text(
                'Stocks',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "We pride in your outfit...",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
