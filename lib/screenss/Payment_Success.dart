import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendPaymentReceipt');
      final response = await callable.call({
        'email': email,
        'transactionId': widget.transactionId,
      });

      if (response.data['success']) {
        setState(() {
          selectedReceiptMethod = "Email ($email)";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your payment receipt has been sent to $email.')),
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $error')),
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
              ElevatedButton(
                onPressed: () => _askForEmail(context),
                child: Text('Gmail'),
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
