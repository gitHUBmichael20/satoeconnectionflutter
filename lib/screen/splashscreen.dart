import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 60,
                width: 60,
                color: const Color(0xFF1D7874), // Teal/green color similar to image
              ),
              const SizedBox(height: 12), // Spacing between logo and text
              const Text(
                'Satoe Connection',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  color: Color(0xFF1D7874),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}