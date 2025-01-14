import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:projectmemberlink/events/myevent.dart';
import 'package:projectmemberlink/events/newevent.dart';
import 'package:projectmemberlink/views/mydrawer.dart';
import 'package:http/http.dart' as http;

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});
  @override
  State<EventScreen> createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  List<MyEvent> eventsList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadEventsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
            color: Colors.white, // White text
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0066B3), // Domino's Blue
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: loadEventsData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFEC1C24), // Domino's Red for background
        child: eventsList.isEmpty
            ? Center(
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white, // White text
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: eventsList.length,
                itemBuilder: (context, index) {
                  return buildEventCard(index);
                },
              ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const NewEventScreen()),
          );
        },
        backgroundColor: const Color(0xFF0066B3), // Domino's Blue
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildEventCard(int index) {
    final event = eventsList[index];
    return Card(
      color: Colors.white, // White card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        splashColor: const Color(0xFFEC1C24), // Domino's Red
        onTap: () {
          showEventDetailsDialog(index);
        },
        onLongPress: () {
          deleteDialog(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.eventTitle ?? "No Title",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066B3), // Domino's Blue
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "${MyConfig.servername}/memberlink/assets/events/${event.eventFilename}",
                  width: double.infinity,
                  height: screenHeight / 6,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.eventType ?? "No Type",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                df.format(DateTime.parse(event.eventDate.toString())),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                truncateString(event.eventDescription ?? "No Description", 45),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
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

  void loadEventsData() {
    http
        .get(Uri.parse("${MyConfig.servername}/mymemberlink/api/loadevent.php"))
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          final List<dynamic> result = data['data']['events'];
          setState(() {
            eventsList = result
                .map((item) => MyEvent.fromJson(item))
                .toList()
                .cast<MyEvent>();
            status = "Loaded";
          });
        } else {
          setState(() {
            status = "No events available";
          });
        }
      } else {
        setState(() {
          status = "Error loading data";
        });
      }
    }).catchError((error) {
      setState(() {
        status = "Error: $error";
      });
    });
  }

  void showEventDetailsDialog(int index) {
    final event = eventsList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            event.eventTitle ?? "No Title",
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${MyConfig.servername}/memberlink/assets/events/${event.eventFilename}",
                    width: double.infinity,
                    height: screenHeight / 4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.eventType ?? "No Type",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  df.format(DateTime.parse(event.eventDate.toString())),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  event.eventDescription ?? "No Description",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
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
          backgroundColor: const Color(0xFF1E1E1E),
          title:
              const Text("Delete Event", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Are you sure you want to delete this event?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                deleteEvent(index);
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteEvent(int index) {
    final event = eventsList[index];
    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/deleteevent.php"),
      body: {"eventid": event.eventId.toString()},
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Event deleted successfully"),
            backgroundColor: Colors.green,
          ));
          loadEventsData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to delete event"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
