import 'package:flutter/material.dart';
import 'question12.dart'; // Assuming you'll have a Question12, update as needed

class Question11 extends StatefulWidget {
  @override
  _Question11State createState() => _Question11State();
}

class _Question11State extends State<Question11> {
  // State variables to store user responses
  String? numberOfEmployees; // Tracks number of employees
  bool filedPayrollTaxes = false; // Tracks payroll tax filing status
  TextEditingController _otherEmployeeController = TextEditingController(); // Controller for "Other" input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees and Payroll'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Number of employees
              Text(
                '1. How many employees do you have?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text('1-10'),
                    value: '1-10',
                    groupValue: numberOfEmployees,
                    onChanged: (String? value) {
                      setState(() {
                        numberOfEmployees = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('11-50'),
                    value: '11-50',
                    groupValue: numberOfEmployees,
                    onChanged: (String? value) {
                      setState(() {
                        numberOfEmployees = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Other'),
                    value: 'Other',
                    groupValue: numberOfEmployees,
                    onChanged: (String? value) {
                      setState(() {
                        numberOfEmployees = value!;
                        if (value != 'Other') {
                          _otherEmployeeController.clear(); // Clear text field if "Other" is deselected
                        }
                      });
                    },
                  ),
                ],
              ),
              if (numberOfEmployees == 'Other') ...[
                SizedBox(height: 10),
                TextField(
                  controller: _otherEmployeeController,
                  decoration: InputDecoration(
                    labelText: 'Please specify the number of employees',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              SizedBox(height: 20),

              // Question 2: Filed payroll taxes
              Text(
                '2. Did you file all required payroll taxes?',
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
                      groupValue: filedPayrollTaxes,
                      onChanged: (bool? value) {
                        setState(() {
                          filedPayrollTaxes = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: filedPayrollTaxes,
                      onChanged: (bool? value) {
                        setState(() {
                          filedPayrollTaxes = value!;
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
                    // Check if "Other" is selected and ensure input is provided
                    if (numberOfEmployees == 'Other' && _otherEmployeeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please specify the number of employees.'),
                      ));
                    } else {
                      String employeeCount = numberOfEmployees == 'Other'
                          ? _otherEmployeeController.text
                          : numberOfEmployees!;
                      
                      print('Number of Employees: $employeeCount');
                      print('Filed Payroll Taxes: $filedPayrollTaxes');

                      // Navigate to the next question (Question12)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question12(), // Replace with your Question12 widget
                        ),
                      );
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
