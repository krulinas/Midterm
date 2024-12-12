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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "MyMemberLink",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 57, 104),
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "A beginner-friendly application",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 141, 127, 0),
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 1, 58, 105),
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
