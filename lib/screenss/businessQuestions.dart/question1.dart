import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/businessQuestions.dart/question2.dart';
import 'question3.dart'; // Make sure to import Question2

class Question1 extends StatefulWidget {
  @override
  _Question1State createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  // This map stores the selected status for each tax year
  Map<String, bool> taxYears = {
    '2024': false,
    '2023': false,
    '2022': false,
    '2021': false,
    '2020': false,
    '2019': false,
    '2018': false,
    '2017': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Tax Years'),
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
                '1. Which Tax Year Are You Filing For?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Select the tax year you are filing for.',
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
                    children: taxYears.keys.map((String year) {
                      return CheckboxListTile(
                        title: Text(
                          year,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        value: taxYears[year],
                        activeColor: const Color.fromARGB(255, 240, 153, 127),
                        onChanged: (bool? value) {
                          setState(() {
                            taxYears[year] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect selected tax years
                    List<String> selectedYears = [];
                    taxYears.forEach((year, isSelected) {
                      if (isSelected) {
                        selectedYears.add(year);
                      }
                    });

                    // Print the selected tax years
                    print('Selected Tax Years: $selectedYears');

                    // Navigate to Question2Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Question2(), // Redirect to Question2Page
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
                      Icon(Icons.check, size: 20),
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


