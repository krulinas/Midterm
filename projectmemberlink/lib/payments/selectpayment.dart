import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projectmemberlink/payments/processingpayment.dart';

class SelectPayment extends StatefulWidget {
  const SelectPayment({super.key});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final paymentMethods = {
    "Online Banking": null,
    "Credit / International Card": "https://example.com/credit-card",
    "Debit Card / ATM": "https://example.com/debit-card",
    "Touch 'n Go eWallet": "https://www.touchngo.com.my/ewallet/",
    "Boost": "https://myboost.co/",
    "DuitNow QR": "https://example.com/duitnow-qr",
  };

  final banks = [
    {"name": "Maybank2u", "url": "https://www.maybank2u.com.my"},
    {"name": "CIMB Clicks", "url": "https://www.cimbclicks.com.my"},
    {"name": "Public Bank", "url": "https://www.pbebank.com"},
    {"name": "RHB Now", "url": "https://onlinebanking.rhbgroup.com/my/login"},
    {"name": "Ambank", "url": "https://www.ambank.com.my"},
    {"name": "MyBSN", "url": "https://www.mybsn.com.my"},
    {"name": "Bank Rakyat", "url": "https://www.irakyat.com.my"},
    {"name": "UOB", "url": "https://www.uob.com.my"},
    {"name": "Affin Bank", "url": "https://www.affinonline.com"},
    {"name": "Bank Islam", "url": "https://www.bankislam.biz"},
    {"name": "HSBC Online", "url": "https://www.hsbc.com.my"},
  ];

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload == 'navigate_to_processing') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProcessingPayment(),
        ),
      );
    }
  }

  Future<void> _showPendingPaymentNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'boost_payment_channel',
      'Boost Payments',
      channelDescription: 'Channel for pending payment notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Boost App',
      'You have a pending payment!',
      notificationDetails,
      payload: 'navigate_to_processing',
    );
  }

  Future<void> _onSelectNotification(String? payload) async {
    if (payload == 'navigate_to_processing') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProcessingPayment(),
        ),
      );
    }
  }

  void _handleBoostButton() {
    Timer(const Duration(seconds: 10), () {
      _showPendingPaymentNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Payment Method",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0066B3),
      ),
      body: Container(
        color: const Color(0xFFEC1C24),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                iconColor: const Color(0xFF0066B3),
                textColor: const Color(0xFF0066B3),
                title: const Text(
                  "Online Banking",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: banks.map((bank) {
                  return ListTile(
                    title: Text(
                      bank['name']!,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentWebView(
                            title: bank['name']!,
                            url: bank['url']!,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            ...paymentMethods.entries.map((entry) {
              if (entry.key == "Online Banking") {
                return Container();
              }
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0066B3),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF0066B3),
                  ),
                  onTap: () {
                    if (entry.key == "Boost") {
                      _handleBoostButton();
                    }
                    if (entry.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentWebView(
                            title: entry.key,
                            url: entry.value!,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class PaymentWebView extends StatefulWidget {
  final String title;
  final String url;

  const PaymentWebView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  PaymentWebViewState createState() => PaymentWebViewState();
}

class PaymentWebViewState extends State<PaymentWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0066B3),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        onWebResourceError: (error) {
          print("WebView Error: ${error.description}");
        },
        navigationDelegate: (NavigationRequest request) {
          print("Navigating to: ${request.url}");
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
