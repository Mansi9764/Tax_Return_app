import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/OTPSuccess.dart';
import 'package:retail_tax_filing_app/screenss/packages_new.dart';

class EnterOtpScreen extends StatefulWidget {
  final String verificationId;

  const EnterOtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  _EnterOtpScreenState createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOTP() async {
    setState(() {
      _isLoading = true; // Show loading indicator during verification
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isLoading = false; // Hide loading indicator on success or failure
      });

      // Navigate to a success screen or homepage after verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OtpSuccessPage()), // Assuming HomePage is your next screen
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                hintText: 'Enter your OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            SizedBox(height: 20),
            _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _verifyOTP,
                  child: Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50), // larger button for better tap target
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// Dummy HomePage for navigation example
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Welcome to the Home Page!")),
    );
  }
}
