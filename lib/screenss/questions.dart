import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:retail_tax_filing_app/screenss/PaymentService.dart';
import 'package:retail_tax_filing_app/screenss/document_upload_screen.dart';
import 'package:retail_tax_filing_app/screenss/Payment_Success.dart';

//import 'package:retail_tax_filing_app/screenss/payment_screen.dart';
import 'package:retail_tax_filing_app/screenss/upload_success.dart'; // Import success page

class QuestionnaireScreen extends StatefulWidget {
  final Set<String> selectedPackages;


  final VoidCallback onComplete;  // Correctly defining the onComplete callback

  QuestionnaireScreen({required this.selectedPackages, required this.onComplete});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();

 

  // Variables to hold user input
  String? fullName;
  String? lastName;
  String? ssn;
  String? filingStatus;
  String? spouseFirstName;
  String? spouseLastName;
  String? spouseSSN;
  String? spouseDOB;
  bool isCitizen = true;
  bool receivedWages = false;
  bool receivedUnemployment = false;
  bool hasDependents = false;
  int? dependentsCount;
  List<Map<String, String>> dependents = [];
  bool madeEstimatedTaxPayments = false;
  bool receivedPriorYearRefund = false;
  List<String> selectedIncomeSources = [];
  List<String> selectedContributions = [];
  bool eligibleTaxCredits = false;
  List<String> selectedSpecialSituations = [];
  String? selectedState;
  bool paidStateTaxes = false;

  final List<String> filingStatuses = [
    'Single',
    'Married Filing Jointly',
    'Married Filing Separately',
    'Head of Household',
    'Qualifying Widow with dependent'
  ];
  final List<String> incomeSources = ['Freelance', 'Interest', 'Dividends', 'Rental', 'Investment'];
  final List<String> contributionTypes = ['Retirement', 'Charity', 'Education', 'Mortgage', 'Medical'];
  final List<String> specialSituations = ['Bought Home', 'Sold Home', 'New Business', 'Moved States', 'Inherited Property'];
  final List<String> states = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 
    'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 
    'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 
    'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 
    'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 
    'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 
    'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
  ];
  
  var calculatedTotal = 0.1;
  
  

void _submit() {
  if (_formKey.currentState!.validate()) {
    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    // Navigate based on selected package
    if (widget.selectedPackages.contains('Business Filer')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentUploadScreen(
            packageName: 'Business Filer',
            remainingPackages: [], // No more packages after Business
            selectedPackages: widget.selectedPackages,
            onComplete: widget.onComplete,
          ),
        ),
      );
    } else {
      widget.onComplete();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PaymentsPage()),
      // );

      // Example of navigation after questionnaire completion
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    }
  }
}






  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (widget.selectedPackages.contains('Bronze - Individual Filer')) {
      appBarTitle = 'Tax Questionnaire - Bronze';
    } else if (widget.selectedPackages.contains('Silver - Individual Filer')) {
      appBarTitle = 'Tax Questionnaire - Silver';
    } else if (widget.selectedPackages.contains('Gold - Individual Filer')) {
      appBarTitle = 'Tax Questionnaire - Gold';
    } else {
      appBarTitle = 'Business Questionnaire'; // Default title
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Color.fromARGB(255, 245, 209, 180),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade100,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Section
                  _buildPersonalInfoSection(),
                  SizedBox(height: 15),
                  // Spouse Info Section (conditionally displayed)
                  _buildSpouseInfoSection(),
                  SizedBox(height: 15),
                  // Income Info Section
                  _buildIncomeInfoSection(),
                  SizedBox(height: 15),
                  // Deductions & Credits Section
                  _buildDeductionsCreditsSection(),
                  SizedBox(height: 15),
                  // Payments & Refunds Section
                  _buildPaymentsRefundsSection(),
                  SizedBox(height: 15),
                  // Special Situations Section
                  _buildSpecialSituationsSection(),
                  SizedBox(height: 15),
                  // State Taxes Section
                  _buildStateTaxesSection(),
                  SizedBox(height: 15),
                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 240, 159, 93),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'NEXT',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Reusable Switch Builder
  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange[800],
        ),
      ],
    );
  }

  // Personal Info Section
  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "1. Personal Info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
            contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          ),
          onChanged: (value) {
            setState(() {
              fullName = value;
            });
          },
          validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
        ),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
            contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          ),
          onChanged: (value) {
            setState(() {
              lastName = value;
            });
          },
          validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
        ),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'SSN',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
            contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          ),
          keyboardType: TextInputType.number,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              ssn = value;
            });
          },
          validator: (value) => value!.isEmpty ? 'Please enter your SSN' : null,
        ),
        SizedBox(height: 5),
        //SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (MM/DD/YYYY)',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        keyboardType: TextInputType.datetime,
                        // onChanged: (value) {
                        //   setState(() {
                        //     dependents[index]['dob'] = value;
                        //   });
                        // },
                        validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
                      ),
                      SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: filingStatus,
          decoration: InputDecoration(
            labelText: 'Filing Status',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
          ),
          items: filingStatuses.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              filingStatus = value;
            });
          },
          validator: (value) => value == null ? 'Please select your filing status' : null,
        ),
      ],
    );
  }

  // Spouse Info Section (conditionally displayed)
  Widget _buildSpouseInfoSection() {
    return Visibility(
      visible: filingStatus == 'Married Filing Jointly',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Spouse Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Spouse First Name',
              labelStyle: TextStyle(color: Colors.orange[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[300]!),
              ),
              filled: true,
              fillColor: Colors.orange[50],
              contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            ),
            onChanged: (value) {
              setState(() {
                spouseFirstName = value;
              });
            },
            validator: (value) => value!.isEmpty ? 'Please enter spouse first name' : null,
          ),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Spouse Last Name',
              labelStyle: TextStyle(color: Colors.orange[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[300]!),
              ),
              filled: true,
              fillColor: Colors.orange[50],
              contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            ),
            onChanged: (value) {
              setState(() {
                spouseLastName = value;
              });
            },
            validator: (value) => value!.isEmpty ? 'Please enter spouse last name' : null,
          ),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Spouse SSN',
              labelStyle: TextStyle(color: Colors.orange[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[300]!),
              ),
              filled: true,
              fillColor: Colors.orange[50],
              contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                spouseSSN = value;
              });
            },
            validator: (value) => value!.isEmpty ? 'Please enter spouse SSN' : null,
          ),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Spouse Date of Birth (MM/DD/YYYY)',
              labelStyle: TextStyle(color: Colors.orange[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[300]!),
              ),
              filled: true,
              fillColor: Colors.orange[50],
              contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            ),
            keyboardType: TextInputType.datetime,
            onChanged: (value) {
              setState(() {
                spouseDOB = value;
              });
            },
            validator: (value) => value!.isEmpty ? 'Please enter spouse date of birth' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "2. Income Info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 5),
        _buildSwitch('Did you receive wages (W-2)?', receivedWages, (value) {
          setState(() {
            receivedWages = value;
          });
        }),
        SizedBox(height: 5),
        _buildSwitch('Did you receive unemployment benefits?', receivedUnemployment, (value) {
          setState(() {
            receivedUnemployment = value;
          });
        }),
        SizedBox(height: 5),
        // MultiSelectDialogField(
        //   items: incomeSources.map((source) => MultiSelectItem<String>(source, source)).toList(),
        //   title: Text("Other Income Sources"),
        //   selectedColor: Colors.orange[800],
        //   decoration: BoxDecoration(
        //     color: Colors.orange[50],
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //     border: Border.all(color: Colors.orange[300]!, width: 1),
        //   ),
        //   buttonText: Text("Select Other Income", style: TextStyle(color: Colors.orange[800])),
        //   onConfirm: (values) {
        //     setState(() {
        //       selectedIncomeSources = values;
        //     });
        //   },
        //   // validator: (values) => values == null || values.isEmpty ? 'Please select at least one income source' : null,
        // ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDeductionsCreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "3. Deductions & Credits",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 5),
        _buildSwitch('Are you claiming dependents?', hasDependents, (value) {
          setState(() {
            hasDependents = value;
            if (!hasDependents) {
              dependentsCount = null;
              dependents.clear();
            }
          });
        }),
        if (hasDependents)
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'How many dependents?',
                  labelStyle: TextStyle(color: Colors.orange[800]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.orange[50],
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    dependentsCount = int.tryParse(value) ?? 0;
                    dependents = List.generate(dependentsCount!, (_) => {
                          'firstName': '',
                          'lastName': '',
                          'ssn': '',
                          'dob': ''
                        });
                  });
                },
              ),
              SizedBox(height: 5),
              if (dependentsCount != null && dependentsCount! > 0)
                ...List.generate(dependentsCount!, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Dependent ${index + 1}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        onChanged: (value) {
                          setState(() {
                            dependents[index]['firstName'] = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        onChanged: (value) {
                          setState(() {
                            dependents[index]['lastName'] = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? 'Please enter last name' : null,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'SSN',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            dependents[index]['ssn'] = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? 'Please enter SSN' : null,
                      ),
                      
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (MM/DD/YYYY)',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          setState(() {
                            dependents[index]['dob'] = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
                      ),
                    ],
                  );
                }),
            ],
          ),
        
        SizedBox(height: 15),
        _buildSwitch('Eligible for tax credits (Child Tax, EITC, Education)?', eligibleTaxCredits, (value) {
          setState(() {
            eligibleTaxCredits = value;
          });
        }),
        
        SizedBox(height: 15),
  //       MultiSelectDialogField(
  //         items: contributionTypes.map((type) => MultiSelectItem<String>(type, type)).toList(),
  //         title: Text("Contributions"),
  //         selectedColor: Colors.orange[800],
  //         decoration: BoxDecoration(
  //           color: Colors.orange[50],
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           border: Border.all(color: Colors.orange[300]!, width: 1),
  //         ),
  //         buttonText: Text("Select Contributions", style: TextStyle(color: Colors.orange[800])),
  //         onConfirm: (values) {
  //           setState(() {
  //             selectedContributions = values;
  //           });
  //         },
  //         //validator: (values) => values == null || values.isEmpty ? 'Please select at least one contribution' : null,
  //       ),
        SizedBox(height: 15),
      ],
      
    );
  }

  Widget _buildPaymentsRefundsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "4. Payments & Refunds",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 5),
        _buildSwitch('Made estimated tax payments?', madeEstimatedTaxPayments, (value) {
          setState(() {
            madeEstimatedTaxPayments = value;
          });
        }),
        SizedBox(height: 1),
        _buildSwitch('Received prior year refund?', receivedPriorYearRefund, (value) {
          setState(() {
            receivedPriorYearRefund = value;
          });
        }),
      ],
    );
  }

  Widget _buildSpecialSituationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "5. Special Situations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 15),
        MultiSelectDialogField(
          items: specialSituations
              .map((situation) => MultiSelectItem<String>(situation, situation))
              .toList(),
          title: Text("Special Situations"),
          selectedColor: Colors.orange[800],
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.orange[300]!,
              width: 1,
            ),
          ),
          buttonText: Text(
            "Select Special Situations",
            style: TextStyle(color: Colors.orange[800]),
          ),
          onConfirm: (values) {
            setState(() {
              selectedSpecialSituations = values;
            });
          },
          //validator: (values) => values == null || values.isEmpty ? 'Please select at least one situation' : null,
        ),
      ],
    );
  }

  Widget _buildStateTaxesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "6. State Taxes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 15),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'States lived/worked in',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
          ),
          items: states
              .map((state) => DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedState = value;
            });
          },
          validator: (value) => value == null ? 'Please select the state you lived/worked in' : null,
        ),
        SizedBox(height: 15),
        _buildSwitch('Paid state/local taxes?', paidStateTaxes, (value) {
          setState(() {
            paidStateTaxes = value;
          });
        }),
      ],
    );
  }
}
