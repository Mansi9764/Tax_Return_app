import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:retail_tax_filing_app/screenss/businessQuestions.dart/question1.dart';
import 'package:retail_tax_filing_app/screenss/questions.dart';
import 'package:retail_tax_filing_app/screenss/upload_success.dart';

class DocumentUploadScreen extends StatefulWidget {
  final String packageName;
  final List<String> remainingPackages;
  final Set<String> selectedPackages;
  //final double totalPrice; 
  final VoidCallback onComplete;

  DocumentUploadScreen({
    required this.packageName,
    this.remainingPackages = const [],
    required this.selectedPackages,
    //required this.totalPrice,
    required this.onComplete,
  });

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Map to store picked files for each form type
  Map<String, List<PlatformFile>> _pickedFiles = {};

  // Allows picking multiple files for each form type
  Future<void> _pickFile(String formType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Allows multiple file selection
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'], // Allow only specific file types
      );

      if (result != null && mounted) { // Ensure widget is mounted before calling setState
        setState(() {
          _pickedFiles.putIfAbsent(formType, () => []).addAll(result.files);
        });
      } else if (!mounted) {
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File selection was canceled.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }


// //calculate total price
// double _getPriceFromPackageKey(String packageKey) {
//   var priceString = packageKey.split('-').last.trim();
//   return double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
// }
  // Deletes a selected file
  void _deleteFile(String formType, PlatformFile file) {
    if (mounted) {
      setState(() {
        _pickedFiles[formType]?.remove(file);
      });
    }
  }

  // Handles the upload action
  void _uploadFiles() {
    if (_pickedFiles.values.any((files) => files.isNotEmpty)) {
      _pickedFiles.forEach((formType, files) {
        if (files.isNotEmpty) {
          print('Uploading $formType documents: ${files.map((e) => e.name).toList()}');
        }
      });

      if (widget.packageName.contains("Individual Filer") && mounted) {
        // After individual filer, go to its questionnaire
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionnaireScreen(
              selectedPackages: widget.selectedPackages,
              onComplete: () {
                // After individual filer questions, proceed with remaining packages
                _navigateToNextUploadOrQuestions();
              },
            ),
          ),
        );
      } else if (widget.packageName == "Business Filer" && mounted) {
        // After business filer, go to its questions
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Question1(),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload at least one document.')),
        );
      }
    }
  }

  // Navigate to the next package's upload or questions
  void _navigateToNextUploadOrQuestions() {
    if (widget.remainingPackages.isNotEmpty && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentUploadScreen(
            packageName: widget.remainingPackages.first, // Next package
            remainingPackages: widget.remainingPackages.sublist(1),
            selectedPackages: widget.selectedPackages,
            onComplete: widget.onComplete,
          ),
        ),
      );
    } else if (mounted) {
      // No more packages, display success or return to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UploadSuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.packageName}'),
        backgroundColor: const Color.fromARGB(255, 238, 192, 155),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 10),
              _buildPackageSpecificUploadOptions(),
              SizedBox(height: 20),
              _buildUploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Header widget
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.upload_file, size: 50, color: const Color.fromARGB(255, 236, 188, 149)),
        SizedBox(height: 8),
        Text(
          'Upload Your Documents',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'Please upload the required documents for your ${widget.packageName} package.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Dynamically build form upload options based on package
  Widget _buildPackageSpecificUploadOptions() {
    List<String> formsToUpload = _getFormsByPackage(widget.packageName);

    return Column(
      children: formsToUpload.map((formLabel) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildFormUploadOption(formLabel),
        );
      }).toList(),
    );
  }

  // Get forms dynamically based on the package
  List<String> _getFormsByPackage(String packageName) {
    switch (packageName) {
      case 'Bronze - Individual Filer':
        return ['W-2: Wage and Tax Statement', '1098: Mortgage Interest Statement', '2441: Child and Dependent Care Credit', '1095-A: Health Insurance Marketplace Statement'];
      case 'Silver - Individual Filer':
        return ['W-2: Wage and Tax Statement', '1098: Mortgage Interest Statement', '2441: Child and Dependent Care Credit', '1095-A: Health Insurance Marketplace Statement', '1099: Miscellaneous Income Form'];
      case 'Gold - Individual Filer':
        return ['W-2: Wage and Tax Statement', '1098: Mortgage Interest Statement', '2441: Child and Dependent Care Credit','1095-A: Health Insurance Marketplace Statement','1099: Miscellaneous Income Form','Schedule C: Self-Employment Income'];
      case 'Business Filer':
        return ['Profit & Loss Statement', 'Balance Sheet', 'Partnership Statement'];
      default:
        return [];
    }
  }

  // Build the form upload option
  Widget _buildFormUploadOption(String formLabel) {
    final formType = formLabel.split(":")[0];
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formLabel,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: _pickedFiles[formType]?.map((file) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              file.name,
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red, size: 16),
                            onPressed: () => _deleteFile(formType, file),
                          ),
                        ],
                      );
                    }).toList() ?? [],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(formType),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 197, 152),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    icon: Icon(Icons.upload_file, size: 16),
                    label: Text(
                      'Upload Document(s)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Upload button
  Widget _buildUploadButton() {
    return ElevatedButton(
      onPressed: _uploadFiles,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        elevation: 3,
        shadowColor: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NEXT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}
