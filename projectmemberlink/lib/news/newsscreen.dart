import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectmemberlink/news/news.dart';
import 'package:projectmemberlink/news/editnews.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:projectmemberlink/news/latestnews.dart';
import 'package:projectmemberlink/views/mydrawer.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  List<News> newsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsletter",
          style: TextStyle(
            color: Colors.white, // Title color
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0066B3), // Domino's Blue
        iconTheme: const IconThemeData(
          color: Colors.white, // Set hamburger menu icon color to white
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadNewsData();
            },
            icon:
                const Icon(Icons.refresh, color: Colors.white), // Refresh icon
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Container(
        color: const Color(0xFFEC1C24), // Domino's Red for background
        child: newsList.isEmpty
            ? const Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white), // Text color white
                ),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Page: $curpage/Result: $numofresult",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFFFFFFFF), // White for cards
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              deleteDialog(index);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  truncateString(
                                      newsList[index].newsTitle.toString(), 30),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0066B3), // Domino's Blue
                                  ),
                                ),
                                Text(
                                  df.format(DateTime.parse(
                                      newsList[index].newsDate.toString())),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87, // Dark gray for date
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              truncateString(
                                  newsList[index].newsDetails.toString(), 100),
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: Colors.black54), // Lighter gray
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color(0xFFEC1C24)), // Domino's Red
                              onPressed: () {
                                showNewsDetailsDialog(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if ((curpage - 1) == index) {
                          color = const Color.fromARGB(
                              255, 255, 255, 255); // Domino's Red
                        } else {
                          color = const Color(0xFF0066B3); // Domino's Blue
                        }
                        return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadNewsData();
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const LatestNewsScreen()),
          );
          loadNewsData();
        },
        backgroundColor: const Color(0xFF0066B3), // Domino's Blue
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadNewsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/loadnews.php?pageno=$curpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }

  void showNewsDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 23, 0, 122), // Dark background for the dialog
          title: Text(
            newsList[index].newsTitle.toString(),
            style: const TextStyle(color: Colors.yellow), // White text
          ),
          content: Text(
            newsList[index].newsDetails.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white70), // Light gray content
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                News news = newsList[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => EditNewsScreen(news: news),
                  ),
                );
              },
              child: const Text("Edit?",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close",
                  style: TextStyle(color: Color.fromARGB(255, 255, 59, 59))),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E), // Dark background
          title: Text(
            "Delete \"${truncateString(newsList[index].newsTitle.toString(), 20)}\"",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this news?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteNews(index);
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.yellow)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: TextStyle(color: Colors.yellow)),
            ),
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/deletenews.php"),
      body: {"newsid": newsList[index].newsId.toString()},
    ).then((response) {
      if (!mounted) return; // Ensure widget is still active
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log("Delete response: $data"); // Use log instead of print
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          loadNewsData(); // Reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error occurred: $error"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }
}
