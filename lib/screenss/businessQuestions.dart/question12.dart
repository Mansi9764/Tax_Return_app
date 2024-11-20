import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/payment_screen.dart';
//import 'question13.dart'; // Assuming you'll have a Question13, update as needed

class Question12 extends StatefulWidget {
  @override
  _Question12State createState() => _Question12State();
}

class _Question12State extends State<Question12> {
  // State variables to store user responses
  bool businessOwnershipChanged = false;
  bool receivedGovernmentRelief = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Questions'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Business change of ownership or structure
              Text(
                '1. Did your business change ownership or structure this year?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Yes'),
                      value: true,
                      groupValue: businessOwnershipChanged,
                      onChanged: (bool? value) {
                        setState(() {
                          businessOwnershipChanged = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: businessOwnershipChanged,
                      onChanged: (bool? value) {
                        setState(() {
                          businessOwnershipChanged = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 2: Received government relief
              Text(
                '2. Did you receive any government grants, loans, or relief (e.g., COVID-related)?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Yes'),
                      value: true,
                      groupValue: receivedGovernmentRelief,
                      onChanged: (bool? value) {
                        setState(() {
                          receivedGovernmentRelief = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: receivedGovernmentRelief,
                      onChanged: (bool? value) {
                        setState(() {
                          receivedGovernmentRelief = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Next button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('Business Ownership Changed: $businessOwnershipChanged');
                    print('Received Government Relief: $receivedGovernmentRelief');

                    // Navigate to the next question (Question13)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(), // Replace with your Question13 widget
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 242, 154, 127),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy Question13Page for demonstration (you'll replace this with your actual Question13Page)
class Question13 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question 13 Page'),
      ),
      body: Center(
        child: Text('This is Payments Page'),
      ),
    );
  }
}
