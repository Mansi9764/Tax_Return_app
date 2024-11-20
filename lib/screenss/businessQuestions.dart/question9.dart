import 'package:flutter/material.dart';
import 'question10.dart'; // Assuming you'll have a Question10, update as needed

class Question9 extends StatefulWidget {
  @override
  _Question9State createState() => _Question9State();
}

class _Question9State extends State<Question9> {
  // State variables to store user selections
  List<String> selectedDeductions = [];
  bool claimVehicleDeduction = false;
  String eligibleForCredits = 'Not Sure';
  TextEditingController _otherDeductionController = TextEditingController(); // Controller for "Other" input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deductions and Credits'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Deductions
              Text(
                '1. Are you claiming any deductions? (Choose all that apply)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  CheckboxListTile(
                    title: Text('Office supplies'),
                    value: selectedDeductions.contains('Office supplies'),
                    onChanged: (bool? value) {
                      setState(() {
                        _onDeductionsChanged(value, 'Office supplies');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Rent'),
                    value: selectedDeductions.contains('Rent'),
                    onChanged: (bool? value) {
                      setState(() {
                        _onDeductionsChanged(value, 'Rent');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Travel/Meals'),
                    value: selectedDeductions.contains('Travel/Meals'),
                    onChanged: (bool? value) {
                      setState(() {
                        _onDeductionsChanged(value, 'Travel/Meals');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Other'),
                    value: selectedDeductions.contains('Other'),
                    onChanged: (bool? value) {
                      setState(() {
                        _onDeductionsChanged(value, 'Other');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('None'),
                    value: selectedDeductions.contains('None'),
                    onChanged: (bool? value) {
                      setState(() {
                        _onDeductionsChanged(value, 'None');
                      });
                    },
                  ),
                ],
              ),
              if (selectedDeductions.contains('Other')) ...[
                SizedBox(height: 10),
                TextField(
                  controller: _otherDeductionController,
                  decoration: InputDecoration(
                    labelText: 'Please specify your other deductions',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 20),

              // Question 2: Vehicle or mileage deduction
              Text(
                '2. Do you want to claim a vehicle or mileage deduction?',
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
                      groupValue: claimVehicleDeduction,
                      onChanged: (bool? value) {
                        setState(() {
                          claimVehicleDeduction = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: claimVehicleDeduction,
                      onChanged: (bool? value) {
                        setState(() {
                          claimVehicleDeduction = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 3: Eligible for tax credits
              Text(
                '3. Are you eligible for any tax credits?',
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
                    title: Text('Yes'),
                    value: 'Yes',
                    groupValue: eligibleForCredits,
                    onChanged: (String? value) {
                      setState(() {
                        eligibleForCredits = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('No'),
                    value: 'No',
                    groupValue: eligibleForCredits,
                    onChanged: (String? value) {
                      setState(() {
                        eligibleForCredits = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Not Sure'),
                    value: 'Not Sure',
                    groupValue: eligibleForCredits,
                    onChanged: (String? value) {
                      setState(() {
                        eligibleForCredits = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Next button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedDeductions.contains('Other') &&
                        _otherDeductionController.text.isEmpty) {
                      // Show a message if "Other" is selected but no input is provided
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please specify your other deductions.'),
                      ));
                    } else {
                      // Navigate to the next question (Question10)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question10(), // Replace with your Question10 widget
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

  // Helper function to handle changes in deductions checkboxes
  void _onDeductionsChanged(bool? value, String deduction) {
    if (value == true) {
      // If "None" is selected, clear other deductions
      if (deduction == 'None') {
        selectedDeductions = ['None'];
      } else {
        selectedDeductions.remove('None');
        selectedDeductions.add(deduction);
      }
    } else {
      selectedDeductions.remove(deduction);
    }
  }
}
