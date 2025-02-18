import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;

class PaymentSuccessPage extends StatefulWidget {
  final String transactionId;

  PaymentSuccessPage({required this.transactionId});

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  String? selectedReceiptMethod;

Future<void> _sendEmailReceipt(String email) async {
  try {
    print("📩 Attempting to send email...");
    print("📩 Email: $email");
    print("📩 Transaction ID: ${widget.transactionId}");

    final String url = "https://us-central1-tax-app-cf8c9.cloudfunctions.net/sendPaymentReceipt";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email.trim(),
        'transactionId': widget.transactionId.toString(),
      }),
    );

    final responseData = jsonDecode(response.body);
    print("📩 Response received: $responseData");

    if (response.statusCode == 200 && responseData['success']) {
      print("✅ Email sent successfully to $email");

      setState(() {
        selectedReceiptMethod = "Email ($email)";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your payment receipt has been sent to $email.')),
      );
    } else {
      print("❌ Failed to send email. Error: ${responseData['message']}");
      throw Exception(responseData['message']);
    }
  } catch (error) {
    print("❌ Exception occurred: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send email: $error')),
    );
  }
}


Future<void> _sendSmsReceipt(String phoneNumber) async {
  try {
    print("📲 Attempting to send SMS...");
    print("📲 Phone Number: $phoneNumber");
    print("📲 Transaction ID: ${widget.transactionId}");

    final String url = "https://us-central1-tax-app-cf8c9.cloudfunctions.net/sendPaymentReceiptSms";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'phoneNumber': phoneNumber.trim(),
        'transactionId': widget.transactionId.toString(),
      }),
    );

    final responseData = jsonDecode(response.body);
    print("📩 Response received: $responseData");

    if (response.statusCode == 200 && responseData['success']) {
      print("✅ SMS sent successfully to $phoneNumber");

      setState(() {
        selectedReceiptMethod = "SMS ($phoneNumber)";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your payment receipt has been sent to $phoneNumber.')),
      );
    } else {
      print("❌ Failed to send SMS. Error: ${responseData['message']}");
      throw Exception(responseData['message']);
    }
  } catch (error) {
    print("❌ Exception occurred: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send SMS: $error')),
    );
  }
}

  void _askForEmail(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Gmail Address'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'example@gmail.com'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String email = emailController.text.trim();
                if (email.isNotEmpty && email.contains('@')) {
                  Navigator.of(context).pop();
                  _sendEmailReceipt(email);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid email address.')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _askForPhoneNumber(BuildContext context) {
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Phone Number'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'e.g., +1234567890'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty && phoneNumber.length >= 10) {
                  Navigator.of(context).pop();
                  _sendSmsReceipt(phoneNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid phone number.')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Successful'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Transaction ID: ${widget.transactionId}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Thank you! Your tax return has been successfully received. A dedicated tax expert will now take over and handle everything for you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),

              /// Asking for the receipt on the same page
              Text(
                'Would you like to receive a payment receipt?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _askForEmail(context),
                    child: Text('Gmail'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _askForPhoneNumber(context),
                    child: Text('SMS'),
                  ),
                ],
              ),

              if (selectedReceiptMethod != null) ...[
                SizedBox(height: 15),
                Text(
                  'Your payment receipt has been sent to $selectedReceiptMethod.',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
