import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:retail_tax_filing_app/screenss/payment.dart';
import 'package:retail_tax_filing_app/screenss/upload_success.dart';

class DocumentUploadScreen extends StatefulWidget {
  final String packageName;

  DocumentUploadScreen({required this.packageName});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Initialize _pickedFiles as Map<String, List<String>> for multiple files
  Map<String, List<String>> _pickedFiles = {
    'W2': [],
    'W4': [],
    '1099': [],
    '1040': [],
    'I-9': [],
    '4868': [],
  };

  // Allows picking multiple files for each form type
  Future<void> _pickFile(String formType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allows multiple file selection
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _pickedFiles[formType]?.addAll(result.paths.whereType<String>()); // Add selected files
      });
    } else {
      print('User canceled file picking');
    }
  }

  // Deletes a selected file
  void _deleteFile(String formType, String fileName) {
    setState(() {
      _pickedFiles[formType]?.remove(fileName);
    });
  }

  // Handles the upload action
  void _uploadFiles() {
    if (_pickedFiles.values.any((files) => files.isNotEmpty)) {
      _pickedFiles.forEach((formType, files) {
        if (files.isNotEmpty) {
          print('Uploading $formType documents: $files');
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UploadSuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload at least one document.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents for ${widget.packageName}'),
        backgroundColor: const Color.fromARGB(255, 238, 192, 155), // Orange theme
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Compact layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 10),
              _buildFormUploadOption('W2', 'W2 Form'),
             
              SizedBox(height: 10),
              _buildFormUploadOption('1099', '1099 Form'),
              SizedBox(height: 10),
              _buildFormUploadOption('1040', '1040 Form'),
              SizedBox(height: 10),
              _buildFormUploadOption('I-9', 'I-9 Form'),
              SizedBox(height: 10),
              _buildFormUploadOption('4868', 'Form 4868'),
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

  // Form upload option allowing multiple files
  Widget _buildFormUploadOption(String formType, String formLabel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formLabel,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Column(
              children: _pickedFiles[formType]?.map((fileName) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            fileName,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 16),
                          onPressed: () => _deleteFile(formType, fileName),
                        ),
                      ],
                    );
                  }).toList() ??
                  [],
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
