import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/businessQuestions.dart/question4.dart';
import 'question3.dart'; // Assuming you'll have a Question3, update as needed

class Question3 extends StatefulWidget {
  @override
  _Question3State createState() => _Question3State();
}

class _Question3State extends State<Question3> {
  // List of business types to select from
  List<String> businessTypes = [
    'Consulting',
    'Ecommerce',
    'Manufacturing',
    'Retail',
    'Technology',
    'Healthcare',
    'Other'
  ];

  String? selectedBusinessType; // Holds the selected business type
  TextEditingController _otherBusinessController = TextEditingController(); // Controller for "Other" input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Business Category'),
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
                '3. What Category Does Your Business Fall Under?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Select the category that best describes your business.',
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
                  child: Column(
                    children: businessTypes.map((String type) {
                      return RadioListTile<String>(
                        title: Text(
                          type,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        value: type,
                        groupValue: selectedBusinessType,
                        activeColor: const Color.fromARGB(255, 240, 153, 127),
                        onChanged: (String? value) {
                          setState(() {
                            selectedBusinessType = value;
                            if (value != "Other") {
                              _otherBusinessController.clear(); // Clear the text field if "Other" is deselected
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (selectedBusinessType == 'Other') ...[
                SizedBox(height: 20),
                TextField(
                  controller: _otherBusinessController,
                  decoration: InputDecoration(
                    labelText: 'Please specify your business category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedBusinessType != null) {
                      String businessCategory = selectedBusinessType == 'Other'
                          ? _otherBusinessController.text
                          : selectedBusinessType!;
                      if (businessCategory.isEmpty && selectedBusinessType == 'Other') {
                        // Show a message if "Other" is selected but no input is provided
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please provide your business category.'),
                        ));
                        return;
                      }

                      print('Selected Business Category: $businessCategory');

                      // Navigate to the next question (Question4)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question4(), // Redirect to Question4
                        ),
                      );
                    } else {
                      // Show a message if no category is selected
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select a business category.'),
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
}
