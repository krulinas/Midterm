import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectmemberlink/views/mydrawer.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:projectmemberlink/payments/paymentdetails.dart'; // Ensure this file exists and is implemented

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List<dynamic> membershipList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembershipData();
  }

  Future<void> fetchMembershipData() async {
    try {
      final response = await http.get(Uri.parse(
          "${MyConfig.servername}/mymemberlink/api/loadmembership.php"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            membershipList = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load membership data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching membership data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Membership Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0066B3),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : membershipList.isEmpty
              ? const Center(
                  child: Text(
                    "No membership data available.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  color: const Color(0xFF1E1E1E),
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: membershipList.length,
                    itemBuilder: (context, index) {
                      final membership = membershipList[index];
                      return membershipCard(
                        context,
                        title: membership['membership_name'],
                        description: membership['membership_description'],
                        price: membership['membership_price'] == '0.00'
                            ? 'FREE'
                            : 'RM ${membership['membership_price']}',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentDetails(
                                membershipName: membership['membership_name'],
                                membershipPrice: membership['membership_price'],
                                membershipDescription:
                                    membership['membership_description'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Widget membershipCard(BuildContext context,
      {required String title,
      required String description,
      required String price,
      required VoidCallback onPressed}) {
    return Card(
      color: const Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: onPressed,
                  child: const Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
