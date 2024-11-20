import 'package:flutter/material.dart';
import 'question9.dart'; // Assuming you'll have a Question9, update as needed

class Question8 extends StatefulWidget {
  @override
  _Question8State createState() => _Question8State();
}

class _Question8State extends State<Question8> {
  // Controller for total business expenses
  TextEditingController businessExpensesController = TextEditingController();

  // State variables for each question
  String employeeOrContractor = 'None'; // Tracks whether Employees, Contractors, Both, or None
  bool spentOnMarketing = false;
  bool paysForInsurance = false;
  bool hasRentOrPropertyExpenses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Expenses'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Total business expenses
              Text(
                '1. What were your total business expenses this year?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: businessExpensesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter total expenses in USD',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Question 2: Employees or contractors
              Text(
                '2. Did you pay employees or contractors?',
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
                    title: Text('Employees'),
                    value: 'Employees',
                    groupValue: employeeOrContractor,
                    onChanged: (String? value) {
                      setState(() {
                        employeeOrContractor = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Contractors'),
                    value: 'Contractors',
                    groupValue: employeeOrContractor,
                    onChanged: (String? value) {
                      setState(() {
                        employeeOrContractor = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Both'),
                    value: 'Both',
                    groupValue: employeeOrContractor,
                    onChanged: (String? value) {
                      setState(() {
                        employeeOrContractor = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('None'),
                    value: 'None',
                    groupValue: employeeOrContractor,
                    onChanged: (String? value) {
                      setState(() {
                        employeeOrContractor = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 3: Marketing or advertising
              Text(
                '3. Did you spend money on marketing or advertising?',
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
                      groupValue: spentOnMarketing,
                      onChanged: (bool? value) {
                        setState(() {
                          spentOnMarketing = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: spentOnMarketing,
                      onChanged: (bool? value) {
                        setState(() {
                          spentOnMarketing = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 4: Business insurance
              Text(
                '4. Do you pay for business insurance?',
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
                      groupValue: paysForInsurance,
                      onChanged: (bool? value) {
                        setState(() {
                          paysForInsurance = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: paysForInsurance,
                      onChanged: (bool? value) {
                        setState(() {
                          paysForInsurance = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 5: Rent or property expenses
              Text(
                '5. Did you have any rent or property expenses?',
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
                      groupValue: hasRentOrPropertyExpenses,
                      onChanged: (bool? value) {
                        setState(() {
                          hasRentOrPropertyExpenses = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: hasRentOrPropertyExpenses,
                      onChanged: (bool? value) {
                        setState(() {
                          hasRentOrPropertyExpenses = value!;
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
                    if (businessExpensesController.text.isNotEmpty) {
                      print('Total Expenses: ${businessExpensesController.text}');
                      print('Employee or Contractor: $employeeOrContractor');
                      print('Marketing: $spentOnMarketing');
                      print('Insurance: $paysForInsurance');
                      print('Rent or Property Expenses: $hasRentOrPropertyExpenses');

                      // Navigate to the next question (Question9)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question9(), // Replace with your Question9 widget
                        ),
                      );
                    } else {
                      // Show a message if the business expenses are not provided
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your total business expenses.')),
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

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    businessExpensesController.dispose();
    super.dispose();
  }
}


