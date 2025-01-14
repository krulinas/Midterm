import 'package:flutter/material.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  List<Map<String, String>> paymentList = []; // Simulating payment data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment List"),
        backgroundColor: const Color(0xFF0066B3),
      ),
      body: paymentList.isEmpty
          ? Center(
              child: const Text(
                "No membership payment records found.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: paymentList.length,
              itemBuilder: (context, index) {
                final payment = paymentList[index];
                return ListTile(
                  title: Text(payment['membership_name'] ?? ""),
                  subtitle: Text("Paid: RM ${payment['amount'] ?? "0.00"}"),
                  trailing: Text(payment['payment_date'] ?? ""),
                );
              },
            ),
    );
  }
}
