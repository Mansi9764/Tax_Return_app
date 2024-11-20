import 'package:flutter/material.dart';
import 'question11.dart'; // Assuming you'll have a Question11, update as needed

class Question10 extends StatefulWidget {
  @override
  _Question10State createState() => _Question10State();
}

class _Question10State extends State<Question10> {
  // State variables to store user responses
  bool hasBusinessLoans = false;
  bool boughtNewAssets = false;
  bool leasedEquipment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assets and Loans'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 135),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1: Business loans
              Text(
                '1. Do you have any business loans?',
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
                      groupValue: hasBusinessLoans,
                      onChanged: (bool? value) {
                        setState(() {
                          hasBusinessLoans = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: hasBusinessLoans,
                      onChanged: (bool? value) {
                        setState(() {
                          hasBusinessLoans = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 2: Bought new equipment or assets
              Text(
                '2. Did you buy new equipment or assets this year?',
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
                      groupValue: boughtNewAssets,
                      onChanged: (bool? value) {
                        setState(() {
                          boughtNewAssets = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: boughtNewAssets,
                      onChanged: (bool? value) {
                        setState(() {
                          boughtNewAssets = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Question 3: Leased or rented equipment
              Text(
                '3. Did you lease or rent any equipment?',
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
                      groupValue: leasedEquipment,
                      onChanged: (bool? value) {
                        setState(() {
                          leasedEquipment = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('No'),
                      value: false,
                      groupValue: leasedEquipment,
                      onChanged: (bool? value) {
                        setState(() {
                          leasedEquipment = value!;
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
                    print('Business Loans: $hasBusinessLoans');
                    print('Bought New Assets: $boughtNewAssets');
                    print('Leased Equipment: $leasedEquipment');

                    // Navigate to the next question (Question11)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Question11(), // Replace with your Question11 widget
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


