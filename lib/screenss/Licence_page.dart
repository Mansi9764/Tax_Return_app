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

  Widget _buildImagePickerButton(String title, bool isFront) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera, isFront),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery, isFront),
            ),
            IconButton(
              icon: Icon(Icons.folder_open),
              onPressed: () => _pickFile(isFront),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Driving License'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_frontImage != null)
                Image.file(_frontImage!, width: 300, height: 180),
              _buildImagePickerButton('Front of License', true),
              SizedBox(height: 20),
              if (_backImage != null)
                Image.file(_backImage!, width: 300, height: 180),
              _buildImagePickerButton('Back of License', false),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToPayments,
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
