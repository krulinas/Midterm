import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectmemberlink/views/mydrawer.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:projectmemberlink/news/newsscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late double screenWidth, screenHeight;

  String name = "Loading...";
  String email = "Loading...";
  String membershipStatus = "Loading...";
  String phoneNumber = "Loading...";
  String bio = "Loading...";

  List<dynamic> newsList = [];
  bool isLoadingProfile = true;
  bool isLoadingNews = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0066B3), // Domino's blue
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: Container(
        color: const Color(0xFFEC1C24), // Domino's red
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoadingProfile
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : buildProfileSection(),
                const SizedBox(height: 20),
                const Text(
                  "Latest News",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                isLoadingNews
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : newsList.isEmpty
                        ? const Center(
                            child: Text(
                              "No news available.",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : buildNewsList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0066B3),
        child: const Icon(Icons.article, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsScreen()),
          ).then((_) => loadNewsData());
        },
      ),
    );
  }

  Widget buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFFFFFFF),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF0066B3),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text(
            email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailRow("Membership Status", membershipStatus),
                const Divider(color: Color(0xFF0066B3)),
                detailRow("Phone Number", phoneNumber),
                const Divider(color: Color(0xFF0066B3)),
                detailRow("Bio", bio),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return newsCard(
            title: news['news_title'] ?? '',
            description: news['news_details'] ?? '',
          );
        },
      ),
    );
  }

  Widget newsCard({
    required String title,
    required String description,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0066B3), // Domino's Blue
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              color: Color(0xFF0066B3),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loadUserData() async {
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/loaduser.php"),
        body: {"user_email": "sayainas@gmail.com"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          final userData = data['data'];
          setState(() {
            name = userData['full_name'] ?? "N/A";
            email = userData['user_email'] ?? "N/A";
            membershipStatus = userData['membership_status'] ?? "N/A";
            phoneNumber = userData['phone_number'] ?? "N/A";
            bio = userData['bio'] ?? "N/A";
            isLoadingProfile = false;
          });
        } else {
          _showError("Failed to load user data");
        }
      } else {
        _showError("Failed to load user data");
      }
    } catch (error) {
      _showError("An error occurred: $error");
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  void loadNewsData() async {
    try {
      // Request all news items from the backend (or enough to display 4)
      final response = await http.get(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/loadnews.php"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == "success") {
          final allNews = data['data']['news'] ?? [];
          setState(() {
            // Display at least 4 news items or all available if fewer than 4
            newsList = allNews.take(4).toList();
            isLoadingNews = false;
          });
        } else {
          _showError("No news available");
        }
      } else {
        _showError("Failed to load news");
      }
    } catch (error) {
      _showError("An error occurred: $error");
      setState(() {
        isLoadingNews = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
