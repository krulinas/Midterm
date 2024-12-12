import 'package:flutter/material.dart';
import 'package:projectmemberlink/events/eventscreen.dart';
import 'package:projectmemberlink/views/mainscreen.dart';
import 'package:projectmemberlink/products/productscreen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.yellow, // Set the background color to yellow
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black, // Black background for the header
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.yellow, // Yellow text for header
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MainScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Slide in from the right
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              title: const Text(
                "Newsletter",
                style: TextStyle(
                  color: Colors.black, // Black font for list items
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const EventScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Slide in from the right
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              title: const Text(
                "Events",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProductScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Slide in from the right
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              title: const Text(
                "Products",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Members",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Payments",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Vetting",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Settings",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black, // Black font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
