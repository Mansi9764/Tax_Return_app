import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:retail_tax_filing_app/screenss/Licence_page.dart';
import 'package:retail_tax_filing_app/screenss/PaymentService.dart';
import 'package:retail_tax_filing_app/screenss/document_upload_screen.dart';
import 'package:retail_tax_filing_app/screenss/Payment_Success.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; 

//import 'package:retail_tax_filing_app/screenss/payment_screen.dart';
import 'package:retail_tax_filing_app/screenss/upload_success.dart'; // Import success page

class QuestionnaireScreen extends StatefulWidget {
  final Set<String> selectedPackages;
  

  var maskFormatter = MaskTextInputFormatter(mask: '###-##-####', filter: {"#": RegExp(r'[0-9]')});
  final VoidCallback onComplete;  // Correctly defining the onComplete callback

  QuestionnaireScreen({required this.selectedPackages, required this.onComplete});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();

  List<String> availableYears = [
  DateTime.now().year.toString(),
  (DateTime.now().year - 1).toString(),
  (DateTime.now().year - 2).toString(),
  (DateTime.now().year - 3).toString(),
  (DateTime.now().year - 4).toString(),
  (DateTime.now().year - 5).toString(),
  (DateTime.now().year - 6).toString(),
  (DateTime.now().year - 7).toString(),
];

  TextEditingController _dateController = TextEditingController();
  TextEditingController _ssnController = TextEditingController();
  TextEditingController _spousessnController = TextEditingController();
  TextEditingController _spouseDateController = TextEditingController();

  

  DateTime? selectedDate;
  String? fullName, lastName, ssn, filingStatus;
 
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
  String? dependentsType = 'Children';  
  String? selectedYears;
  List<TextEditingController> _dobControllers = [];

 @override
  void initState() {
    super.initState();
    _dateController.text = ""; // Initialize the date controller with an empty string
  }
    @override
  void dispose() {
    _dateController.dispose();
    _ssnController.dispose();
    super.dispose();
  }

  var maskFormatter = new MaskTextInputFormatter(
  mask: '###-##-####', 
  filter: { "#": RegExp(r'[0-9]') }
);



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
        MaterialPageRoute(builder: (context) => LicenseUploadPage()),
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

                  //adding extra
                  _buildSpouseInfoSeparatelySection(),
                  SizedBox(height: 15),

                  // Income Info SectionFjointlt
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
                  _buildTaxYearSection(),
                  //_buildTaxYearMultiSelect(),
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

  // // Personal Info Section
  // Widget _buildPersonalInfoSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "1. Personal Info",
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
  //       ),
  //       SizedBox(height: 10),
  //       TextFormField(
  //         decoration: InputDecoration(
  //           labelText: 'First Name',
  //           labelStyle: TextStyle(color: Colors.orange[800]),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Colors.orange[300]!),
  //           ),
  //           filled: true,
  //           fillColor: Colors.orange[50],
  //           contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
  //         ),
  //         onChanged: (value) {
  //           setState(() {
  //             fullName = value;
  //           });
  //         },
  //         validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
  //       ),
  //       SizedBox(height: 5),
  //       TextFormField(
  //         decoration: InputDecoration(
  //           labelText: 'Last Name',
  //           labelStyle: TextStyle(color: Colors.orange[800]),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Colors.orange[300]!),
  //           ),
  //           filled: true,
  //           fillColor: Colors.orange[50],
  //           contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
  //         ),
  //         onChanged: (value) {
  //           setState(() {
  //             lastName = value;
  //           });
  //         },
  //         validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
  //       ),
  //       SizedBox(height: 5),
  //       // TextFormField(
        //   decoration: InputDecoration(
        //     labelText: 'Your SSN (XXX-XX-XXXX)',
        //     labelStyle: TextStyle(color: Colors.orange[800]),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       borderSide: BorderSide(color: Colors.orange[300]!),
        //     ),
        //     filled: true,
        //     fillColor: Colors.orange[50],
        //     contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
        //   ),
        //   keyboardType: TextInputType.number,
        //   obscureText: true,
        //   onChanged: (value) {
        //     setState(() {
        //       ssn = value;
        //     });
        //   },
        //   validator: (value) {
        //     if (value == null || value.isEmpty) {
        //       return 'Please enter your SSN';
        //     } else if (!RegExp(r'^\d{3}-\d{2}-\d{4}$').hasMatch(value)) {
        //       return 'Enter a valid SSN (XXX-XX-XXXX)';
        //     }
        //     return null;
        //   },
        // ),
  //           
  



 
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
        onChanged: (value) => setState(() => fullName = value),
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
        onChanged: (value) => setState(() => lastName = value),
        validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
      ),
      SizedBox(height: 5),
      TextFormField(
        controller: _ssnController,
        decoration: InputDecoration(
          labelText: 'Your SSN (XXX-XX-XXXX)',
          labelStyle: TextStyle(color: Colors.orange[800]),
          hintText: 'Enter your SSN',
          // suffixIcon: IconButton(
          //   icon: Icon(Icons.visibility_off),
          //   onPressed: () => _ssnController.clear(),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[300]!),
          ),
          filled: true,
          fillColor: Colors.orange[50],
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
        ],
        onChanged: (value) => setState(() => ssn = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your SSN';
          } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
            return 'Enter a valid SSN (9 digits)';
          }
          return null;
        },
      ),
      SizedBox(height: 5),
      TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: 'Date of Birth (MM/DD/YYYY)',
          labelStyle: TextStyle(color: Colors.orange[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[300]!),
          ),
          filled: true,
          fillColor: Colors.orange[50],
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // Prevents keyboard from opening
          _selectDate(context);
        },
        validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
      ),
      SizedBox(height: 10),
      DropdownButtonFormField<String>(
        value: filingStatus,
        isExpanded: true,
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
        items: ['Single', 'Married Filing Jointly', 'Married Filing Separately', 'Head of Household', 'Qualifying Widow with Dependent']
            .map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (value) => setState(() => filingStatus = value),
        validator: (value) => value == null ? 'Please select your filing status' : null,
      ),
    ],
  );
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
      _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
    });
  }
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
          controller: _spousessnController,
          decoration: InputDecoration(
            labelText: 'Spouse SSN (XXX-XX-XXXX)',
            labelStyle: TextStyle(color: Colors.orange[800]),
            hintText: 'Enter your spouse SSN',
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.visibility_off),
            //   onPressed: () => _spousessnController.clear(),
            // ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          onChanged: (value) => setState(() => spouseSSN = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your spouse SSN';
            } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
              return 'Enter a valid SSN (9 digits)';
            }
            return null;
          },
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: _spouseDateController,
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
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                // Format the date and update the field.
                spouseDOB = DateFormat('MM/dd/yyyy').format(picked);
                _spouseDateController.text = spouseDOB!;
              });
            }
          },
          validator: (value) => value!.isEmpty ? 'Please enter spouse date of birth' : null,
        ),
      ],
    ),
  );
}



 Widget _buildSpouseInfoSeparatelySection() {
  return Visibility(
    visible: filingStatus == 'Married Filing Separately',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spouse Information (Separate Filing)",
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
        // Updated Spouse SSN Field:
        TextFormField(
          controller: _spousessnController,
          decoration: InputDecoration(
            labelText: 'Spouse SSN (XXX-XX-XXXX)',
            labelStyle: TextStyle(color: Colors.orange[800]),
            hintText: 'Enter your spouse SSN',
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.visibility_off),
            //   onPressed: () => _spousessnController.clear(),
            // ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[300]!),
            ),
            filled: true,
            fillColor: Colors.orange[50],
            contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          onChanged: (value) => setState(() => spouseSSN = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter spouse SSN';
            } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
              return 'Enter a valid SSN (9 digits)';
            }
            return null;
          },
        ),
        SizedBox(height: 5),
        // Updated Spouse Date of Birth Field:
        TextFormField(
          controller: _spouseDateController,
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
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                spouseDOB = DateFormat('MM/dd/yyyy').format(picked);
                _spouseDateController.text = spouseDOB!;
              });
            }
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





  /// The deductions & credits section of the form.
  Widget _buildDeductionsCreditsSection() {
    final List<String> relationships = ['Child', 'Spouse', 'Parent', 'Sibling', 'Other'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "3. Deductions & Credits",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 20),
        _buildSwitch('Are you claiming dependents?', hasDependents, (value) {
          setState(() {
            hasDependents = value;
            if (!hasDependents) {
              dependentsCount = null;
              dependents.clear();
              _dobControllers.clear();
            }
          });
        }),
        if (hasDependents)
          Column(
            children: [
              SizedBox(height: 20),
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
                          'dob': '',
                          'relationship': 'Child', // Default relationship
                          'otherDetails': '',      // Extra field for 'Other' details
                        });
                    // Initialize a DOB controller for each dependent.
                    _dobControllers = List.generate(dependentsCount!, (_) => TextEditingController());
                  });
                },
              ),
              SizedBox(height: 20),
              if (dependentsCount != null && dependentsCount! > 0)
                ...List.generate(dependentsCount!, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Dependent ${index + 1}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      _dependentFormField('First Name', index, 'firstName'),
                      SizedBox(height: 10),
                      _dependentFormField('Last Name', index, 'lastName'),
                      SizedBox(height: 10),
                      // SSN field: visible, accepts only 9 digits, and validated.
                      _dependentFormField(
                        'Dependent SSN (XXX-XX-XXXX)',
                        index,
                        'ssn',
                        isNumber: true,
                        obscureText: false, // SSN is visible
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter SSN';
                          }
                          final RegExp ssnRegex = RegExp(r'^\d{9}$');
                          if (!ssnRegex.hasMatch(value)) {
                            return 'Enter SSN in format: XXX-XX-XXXX';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      // DOB field: read-only, shows a hint, opens a date picker.
                      _dependentFormField(
                        'Date of Birth (MM/DD/YYYY)',
                        index,
                        'dob',
                        readOnly: true,
                        controller: _dobControllers[index],
                        hintText: 'MM/DD/YYYY',
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            String formattedDate = DateFormat('MM/dd/yyyy').format(picked);
                            setState(() {
                              dependents[index]['dob'] = formattedDate;
                              _dobControllers[index].text = formattedDate;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: dependents[index]['relationship'],
                        decoration: InputDecoration(
                          labelText: 'Relationship',
                          labelStyle: TextStyle(color: Colors.orange[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.orange[50],
                        ),
                        items: relationships.map((relationship) {
                          return DropdownMenuItem(
                            value: relationship,
                            child: Text(relationship),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dependents[index]['relationship'] = value!;
                            if (value != 'Other') {
                              dependents[index]['otherDetails'] = '';
                            }
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a relationship' : null,
                      ),
                      if (dependents[index]['relationship'] == 'Other') ...[
                        SizedBox(height: 10),
                        TextFormField(
                          key: ValueKey(index),
                          decoration: InputDecoration(
                            labelText: 'Details for Other',
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
                              dependents[index]['otherDetails'] = value;
                            });
                          },
                          validator: (value) => value!.isEmpty ? 'Please enter details for other' : null,
                        ),
                        SizedBox(height: 20),
                      ],
                    ],
                  );
                }),
            ],
          ),
        _buildSwitch('Eligible for tax credits (Child Tax, EITC, Education)?', eligibleTaxCredits, (value) {
          setState(() {
            eligibleTaxCredits = value;
          });
        }),
        SizedBox(height: 20),
      ],
    );
  }

  /// The dependent form field with additional optional parameters.
  Widget _dependentFormField(
    String labelText,
    int index,
    String field, {
    bool isNumber = false,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: ValueKey('$field-$index'),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.orange[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange[300]!),
        ),
        filled: true,
        fillColor: Colors.orange[50],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      // When using a controller, initialValue should not be used.
      initialValue: controller == null ? dependents[index][field] : null,
      onChanged: (value) {
        setState(() {
          dependents[index][field] = value;
        });
      },
      validator: validator ?? (value) => value!.isEmpty ? 'Please enter $labelText' : null,
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

  Widget _buildTaxYearSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "7. Tax Year",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      SizedBox(height: 10),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Select a tax year',
          labelStyle: TextStyle(color: Colors.orange[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[300]!),
          ),
          filled: true,
          fillColor: Colors.orange[50],
        ),
        value: selectedYears,
        items: availableYears.map((year) {
          return DropdownMenuItem(
            value: year,
            child: Text(year),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedYears = value;
          });
        },
        validator: (value) => value == null ? 'Please select a tax year' : null,
      ),
    ],
  );
}

// // Build the multi-select section
// Widget _buildTaxYearMultiSelect() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "7. Select Tax Years",
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//       ),
//       SizedBox(height: 10),
//       MultiSelectDialogField(
//         items: availableYears.map((year) => MultiSelectItem<String>(year, year)).toList(),
//         title: Text("Tax Years"),
//         selectedColor: Colors.orange[800],
//         decoration: BoxDecoration(
//           color: Colors.orange[50],
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           border: Border.all(color: Colors.orange[300]!, width: 1),
//         ),
//         buttonText: Text("Select Years", style: TextStyle(color: Colors.orange[800])),
//         initialValue: selectedYears,
//         onConfirm: (values) {
//           setState(() {
//             selectedYears = List<String>.from(values);
//           });
//         },
//       ),
//       // Display the selected years in a simple list
//       if (selectedYears.isNotEmpty) ...[
//         Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Text("Selected Years:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(selectedYears.join(", "), style: TextStyle(fontSize: 14)),
//         ),
//       ],
//     ],
//   );
// }

}
class _SSNInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.text.length > oldValue.text.length) {
      if (text.length == 3 || text.length == 6) {
        text += '-';
      }
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}