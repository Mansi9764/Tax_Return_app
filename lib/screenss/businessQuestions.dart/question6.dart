import 'package:flutter/material.dart';
import 'question7.dart'; // Assuming you'll have a Question7, update as needed

class Question6 extends StatefulWidget {
  @override
  _Question6State createState() => _Question6State();
}

class _Question6State extends State<Question6> {
  String? selectedBusinessType;
  TextEditingController _otherBusinessController = TextEditingController(); // Controller for "Other" input
  
  // List of business structures for selection
  List<String> businessStructures = [
    'Sole Proprietorship',
    'Partnership',
    'Corporation',
    'LLC',
    'Non-Profit',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Business Structure'),
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
                '6. What Type of Business Structure Do You Have?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please select the structure that best describes your business.',
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
                    children: businessStructures.map((String type) {
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
                    labelText: 'Please specify your business structure',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedBusinessType != null) {
                      String businessStructure = selectedBusinessType == 'Other'
                          ? _otherBusinessController.text
                          : selectedBusinessType!;
                      if (businessStructure.isEmpty && selectedBusinessType == 'Other') {
                        // Show a message if "Other" is selected but no input is provided
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please provide your business structure.'),
                        ));
                        return;
                      }

                      print('Business Structure: $businessStructure');

                      // Navigate to the next question (Question7)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question7(), // Redirect to Question7
                        ),
                      );
                    } else {
                      // Show a message if no business structure is selected
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select a business structure.'),
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
