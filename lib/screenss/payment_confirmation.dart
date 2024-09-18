
// Payment Confirmation Page
import 'package:flutter/material.dart';

class PaymentConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Confirmed'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              'Your payment has been confirmed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate back to the home or other relevant page
            //     Navigator.pop(context); // Example navigation back
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.teal,
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //   ),
            //   child: Text(
            //     'Go Back',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
