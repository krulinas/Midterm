import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectmemberlink/membership/memberscreen.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({super.key});

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  int _redirectCounter = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startRedirectTimer();
  }

  void _startRedirectTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_redirectCounter > 0) {
          _redirectCounter--;
        } else {
          _timer.cancel();
          _redirectToMemberScreen();
        }
      });
    });
  }

  Future<void> _updateMembershipStatus() async {
    try {
      final url = Uri.parse(
          "http://192.168.1.13/mymemberlink/api/donepayment.php"); // Replace with your actual URL
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final responseData = response.body;
        print("Server Response: $responseData");
      } else {
        print("Error updating membership status: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void _redirectToMemberScreen() async {
    try {
      final url =
          Uri.parse("http://192.168.1.13/mymemberlink/api/donepayment.php");
      final response = await http.post(url, body: {
        'user_id': '13', // Replace with actual user ID
        'order_id': 'KAFC250142769978',
        'amount': '29.90',
        'payment_method': 'Boost',
        'membership_plan': 'Platinum',
      });

      if (response.statusCode == 200) {
        final responseData = response.body;
        print("Server Response: $responseData");
      } else {
        print("Error: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MemberScreen()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066B3),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "08:17",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Boost Red Banner
            Container(
              color: const Color(0xFFEC1C24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/boost_logo.png', // Replace with your asset
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Boost",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Successful",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your payment was successful. Thank you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),
            // Payment Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Paid To",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "MyMemberLink",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Text(
                  "Trans. ID",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "KAFC250142769978",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "RM 29.99",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Redirection Message
            Text(
              "You will be automatically redirected back to our partner's page in $_redirectCounter seconds. If not, please click the button below.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
            const Spacer(),
            // Return to Partner Page Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1C24), // Red color
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _redirectToMemberScreen,
              child: const Text(
                "Return to Partner Page",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> storePaymentData({
    required String userId,
    required String orderId,
    required double amount,
    required String paymentMethod,
    required String membershipPlan,
  }) async {
    final url = Uri.parse(
        'http://192.168.1.13/mymemberlink/api/storepayment.php'); // Replace with actual URL
    final response = await http.post(
      url,
      body: {
        'user_id': userId,
        'order_id': orderId,
        'amount': amount.toString(),
        'payment_method': paymentMethod,
        'membership_plan': membershipPlan,
      },
    );

    if (response.statusCode == 200) {
      print('Payment data stored successfully');
    } else {
      print('Error storing payment data: ${response.body}');
    }
  }
}
