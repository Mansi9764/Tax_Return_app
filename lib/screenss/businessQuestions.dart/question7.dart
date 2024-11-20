import 'package:flutter/material.dart';
import 'question8.dart'; // Assuming you'll have a Question8, update as needed

class Question7 extends StatefulWidget {
  @override
  _Question7State createState() => _Question7State();
}

class _Question7State extends State<Question7> {
  // Controller for business income
  TextEditingController businessIncomeController = TextEditingController();

  // Boolean variables to capture responses
  bool hasOtherIncome = false;
  bool hasSoldAssets = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Income'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Total business income
              Text(
                '1. What was your total business income this year?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: businessIncomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter total income in USD',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Question 2: Other income
              Text(
                '2. Did you have any other income not included in your main income?',
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
                      groupValue: hasOtherIncome,
                      onChanged: (bool? value) {
                        setState(() {
                          hasOtherIncome = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: hasOtherIncome,
                      onChanged: (bool? value) {
                        setState(() {
                          hasOtherIncome = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 3: Sold business assets
              Text(
                '3. Did you sell any business assets this year?',
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
                      groupValue: hasSoldAssets,
                      onChanged: (bool? value) {
                        setState(() {
                          hasSoldAssets = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: hasSoldAssets,
                      onChanged: (bool? value) {
                        setState(() {
                          hasSoldAssets = value!;
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
                    if (businessIncomeController.text.isNotEmpty) {
                      print('Business Income: ${businessIncomeController.text}');
                      print('Other Income: $hasOtherIncome');
                      print('Sold Assets: $hasSoldAssets');

                      // Navigate to the next question (Question8)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Question8(), // Replace with your Question8 widget
                        ),
                      );
                    } else {
                      // Show a message if the business income is not provided
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your total business income.')),
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
    businessIncomeController.dispose();
    super.dispose();
  }
}

