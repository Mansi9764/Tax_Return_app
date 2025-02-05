import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:retail_tax_filing_app/screenss/PaymentService.dart';

class LicenseUploadPage extends StatefulWidget {
  @override
  _LicenseUploadPageState createState() => _LicenseUploadPageState();
}

class _LicenseUploadPageState extends State<LicenseUploadPage> {
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isFront) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _pickFile(bool isFront) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(result.files.single.path!);
        } else {
          _backImage = File(result.files.single.path!);
        }
      });
    }
  }

  Widget _buildImageDisplay(File? imageFile, String title) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: imageFile == null
          ? Center(child: Text('No Image Selected', style: TextStyle(fontSize: 16)))
          : Image.file(imageFile, fit: BoxFit.cover),
    );
  }

  Widget _buildImagePickerButton(String title, bool isFront) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.photo_library, color: Colors.blue),
              onPressed: () => _pickImage(ImageSource.gallery, isFront),
              tooltip: 'Pick from Gallery',
            ),
            IconButton(
              icon: Icon(Icons.folder_open, color: Colors.green),
              onPressed: () => _pickFile(isFront),
              tooltip: 'Pick from File',
            ),
          ],
        ),
      ],
    );
  }

  void navigateToPayments() {
    if (_frontImage != null && _backImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please upload both front and back images of your license."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Driving License'),
        backgroundColor: const Color.fromARGB(255, 246, 125, 88),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildImageDisplay(_frontImage, 'Front of License'),
            _buildImagePickerButton('Front of License', true),
            SizedBox(height: 20),
            _buildImageDisplay(_backImage, 'Back of License'),
            _buildImagePickerButton('Back of License', false),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: navigateToPayments,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
