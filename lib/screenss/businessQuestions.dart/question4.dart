import 'package:flutter/material.dart';
import 'question5.dart'; // Assuming you'll have a Question5, update as needed

class Question4 extends StatefulWidget {
  @override
  _Question4State createState() => _Question4State();
}

class _Question4State extends State<Question4> {
  // Controller for the business tax ID input
  TextEditingController taxIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Business Tax ID (EIN)'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '4. What’s Your Business Tax ID (EIN)?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please enter the Employer Identification Number (EIN) of your business.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: taxIDController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Business Tax ID (EIN)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (taxIDController.text.isNotEmpty) {
                      print('Business Tax ID (EIN): ${taxIDController.text}');

                      // Navigate to the next question (Question5)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question5(), // Redirect to Question5
                        ),
                      );
                    } else {
                      // Show a message if the tax ID is not provided
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter your business tax ID (EIN).'),
                      ));
                    }
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

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    taxIDController.dispose();
    super.dispose();
  }
}


