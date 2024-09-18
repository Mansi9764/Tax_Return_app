import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:retail_tax_filing_app/screenss/package_selection.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold user input
  String? fullName;
  String? ssn;
  String? filingStatus;
  bool isCitizen = true;
  bool receivedWages = false;
  bool receivedUnemployment = false;
  bool hasDependents = false;
  int? dependentsCount;
  bool madeEstimatedTaxPayments = false;
  bool receivedPriorYearRefund = false;
  List<String> selectedIncomeSources = [];
  List<String> selectedContributions = [];
  List<String> selectedSpecialSituations = [];
  bool eligibleTaxCredits = false;
  String? stateOfResidence;
  bool paidStateTaxes = false;

  // Available filing statuses, income sources, contribution types, and special situations
  final List<String> filingStatuses = ['Single', 'Married', 'Head of Household'];
  final List<String> incomeSources = ['Freelance', 'Interest', 'Dividends', 'Rental', 'Investment'];
  final List<String> contributionTypes = ['Retirement', 'Charity', 'Education', 'Mortgage', 'Medical'];
  final List<String> specialSituations = ['Bought/Sold Home', 'New Business', 'Moved States', 'Inherited Property'];
  final List<String> states = ['California', 'Texas', 'New York', 'Florida', 'Other'];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle submission of questionnaire data
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PackageSelectionScreen()), // Redirect to PackageSelectionScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Tax Questionnaire'),
        backgroundColor: Color.fromARGB(255, 245, 209, 180), // Change to orange shade
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
                  color: Colors.orange.shade100, // Use orange shade for shadow
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Subtle shadow
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get some details to help us prepare your taxes!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),

                  // Full Name Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
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
                        fullName = value;
                      });
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your full name' : null,
                  ),
                  SizedBox(height: 15),

                  // SSN Input
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
                        ssn = value;
                      });
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your SSN' : null,
                  ),
                  SizedBox(height: 15),

                  // Filing Status Dropdown
                  DropdownButtonFormField<String>(
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
                    items: filingStatuses
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        filingStatus = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select your filing status' : null,
                  ),
                  SizedBox(height: 15),

                  // Other Income Multi-select Dropdown
                  MultiSelectDialogField(
                    items: incomeSources
                        .map((source) => MultiSelectItem<String>(source, source))
                        .toList(),
                    title: Text("Other Income Sources"),
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
                      "Select Other Income",
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                    onConfirm: (values) {
                      setState(() {
                        selectedIncomeSources = values;
                      });
                    },
                    validator: (values) =>
                        values == null || values.isEmpty ? 'Please select at least one income source' : null,
                  ),
                  SizedBox(height: 15),

                  // Special Situations Multi-select Dropdown
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
                  ),
                  SizedBox(height: 15),

                  // State of Residence Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'State of Residence',
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
                        stateOfResidence = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select your state of residence' : null,
                  ),
                  SizedBox(height: 15),

                  // State/Local Taxes Switch
                  _buildSwitch('Did you pay state/local taxes?', paidStateTaxes, (value) {
                    setState(() {
                      paidStateTaxes = value;
                    });
                  }),

                  // Other sections from the previous code...

                  // U.S. Citizen or Resident?
                  _buildSwitch('Are you a U.S. Citizen/Resident?', isCitizen, (value) {
                    setState(() {
                      isCitizen = value;
                    });
                  }),

                  // Employment Status
                  _buildSwitch('Did you receive wages (W-2)?', receivedWages, (value) {
                    setState(() {
                      receivedWages = value;
                    });
                  }),

                  // Unemployment Benefits
                  _buildSwitch('Did you receive unemployment benefits?', receivedUnemployment, (value) {
                    setState(() {
                      receivedUnemployment = value;
                    });
                  }),

                  // Claiming Dependents
                  _buildSwitch('Are you claiming dependents?', hasDependents, (value) {
                    setState(() {
                      hasDependents = value;
                    });
                  }),
                  if (hasDependents)
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
                          dependentsCount = int.tryParse(value);
                        });
                      },
                    ),
                  SizedBox(height: 15),

                  // Eligible Tax Credits
                  _buildSwitch('Eligible for tax credits (Child Tax, EITC, Education)?', eligibleTaxCredits, (value) {
                    setState(() {
                      eligibleTaxCredits = value;
                    });
                  }),

                  // Payments & Refunds Section
                  _buildSwitch('Did you make estimated tax payments?', madeEstimatedTaxPayments, (value) {
                    setState(() {
                      madeEstimatedTaxPayments = value;
                    });
                  }),
                  _buildSwitch('Did you receive a prior year refund?', receivedPriorYearRefund, (value) {
                    setState(() {
                      receivedPriorYearRefund = value;
                    });
                  }),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 240, 159, 93), // Change to orange shade
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Submit',
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
            style: TextStyle(fontSize: 14, color: Colors.black), // Change to orange shade
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color.fromARGB(255, 235, 155, 90), // Change to orange shade
        ),
      ],
    );
  }
}
