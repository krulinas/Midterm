import 'package:flutter/material.dart';
import 'package:projectmemberlink/views/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0066B3), // Domino's Blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "MyMemberLink",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White for contrast
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "A beginner-friendly application",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Correct way to bold the text
                color: Color(0xFFEC1C24), // Domino's Red
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white, // White spinner
                ),
                strokeWidth: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
