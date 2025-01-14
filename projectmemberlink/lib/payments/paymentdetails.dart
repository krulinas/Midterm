import 'package:flutter/material.dart';
import 'selectpayment.dart';

class PaymentDetails extends StatelessWidget {
  final String membershipName;
  final String membershipPrice;
  final String membershipDescription;

  const PaymentDetails({
    super.key,
    required this.membershipName,
    required this.membershipPrice,
    required this.membershipDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Details",
          style: TextStyle(
            color: Colors.white, // White text
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0066B3), // Domino's Blue
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color(0xFFEC1C24), // Domino's Red background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Membership Details
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Membership: $membershipName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0066B3), // Domino's Blue
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Description: $membershipDescription",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Price: RM $membershipPrice",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Highlighted in red
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Make Payment Button
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC00), // Domino's Yellow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectPayment(),
                      ),
                    );
                  },
                  child: const Text(
                    "Subscribe Now",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Black text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
