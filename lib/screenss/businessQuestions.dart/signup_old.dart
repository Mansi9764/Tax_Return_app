import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_tax_filing_app/screenss/packages_new.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for User Information
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _otpVerified = false;
  bool _isEmailVerified = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 231, 162, 94),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate Back
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Create Your Account",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      _buildFirstNameInput(),
                      _buildLastNameInput(),
                      _buildEmailInput(),
                      _buildPasswordInput(),
                      _buildVerifyEmailButton(),
                      _verificationStatus(),
                      Divider(thickness: 1, height: 30),
                      _buildPhoneInput(),
                      _buildSendOtpButton(),
                      if (_isOtpSent) _buildOtpInput(),
                      if (_otpVerified) _verificationSymbol(),
                      SizedBox(height: 25),
                      _buildSignUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **📌 First Name Input Field**
  Widget _buildFirstNameInput() {
    return _customTextField(
      controller: _firstNameController,
      label: 'First Name',
      icon: Icons.person,
    );
  }

  /// **📌 Last Name Input Field**
  Widget _buildLastNameInput() {
    return _customTextField(
      controller: _lastNameController,
      label: 'Last Name',
      icon: Icons.person_outline,
    );
  }

  /// **📌 Email Input Field**
  Widget _buildEmailInput() {
    return _customTextField(
      controller: _emailController,
      label: 'Email',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
    );
  }

  /// **📌 Password Input Field**
  Widget _buildPasswordInput() {
    return _customTextField(
      controller: _passwordController,
      label: 'Password',
      icon: Icons.lock,
      obscureText: true,
    );
  }

  /// **📌 Phone Number Input**
  Widget _buildPhoneInput() {
    return _customTextField(
      controller: _phoneController,
      label: 'Phone Number',
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
    );
  }

  /// **📌 OTP Input Field**
  Widget _buildOtpInput() {
    return Column(
      children: [
        SizedBox(height: 10),
        _customTextField(
          controller: _otpController,
          label: 'Enter OTP',
          icon: Icons.message,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _customButton('Verify OTP', Colors.green, _verifyOtp),
      ],
    );
  }

  /// **📌 Verify Email Button**
  Widget _buildVerifyEmailButton() {
    return _customButton('Verify Email', const Color.fromARGB(255, 241, 164, 47), _sendVerificationEmail);
  }

  /// **📌 Send OTP Button**
  Widget _buildSendOtpButton() {
    return _customButton('Send OTP', const Color.fromARGB(255, 122, 187, 241), _getOtp);
  }

  /// **📌 Sign Up Button**
  Widget _buildSignUpButton() {
    return _customButton(
      'Sign Up & Proceed',
      Colors.deepPurple,
      (_isEmailVerified && _otpVerified) ? _completeSignUp : null,
    );
  }

  /// **✅ OTP Verified Symbol**
  Widget _verificationSymbol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 24),
        SizedBox(width: 8),
        Text('OTP Verified', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// **📌 Verification Status UI**
  Widget _verificationStatus() {
    return Column(
      children: [
        Text(
          _isEmailVerified ? "✅ Email Verified" : "❌ Email Not Verified",
          style: TextStyle(color: _isEmailVerified ? Colors.green : Colors.red),
        ),
        if (_isOtpSent) Text("📩 OTP Sent! Enter OTP to verify."),
      ],
    );
  }

  /// **📌 Complete Sign Up & Redirect to Packages Page**
  void _completeSignUp() {
    Fluttertoast.showToast(msg: "✅ Sign Up Successful!");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PackageSelectionScreen()));
  }

  /// **📌 Send Email Verification**
  void _sendVerificationEmail() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();
      Fluttertoast.showToast(msg: '📩 Verification email sent. Check your inbox.');
      _checkEmailVerification();
    } catch (e) {
      Fluttertoast.showToast(msg: '⚠️ Error: ${e.toString()}');
    }
  }

  /// **📌 Check Email Verification Status**
  void _checkEmailVerification() async {
    await _auth.currentUser?.reload();
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });
      Fluttertoast.showToast(msg: '✅ Email Verified Successfully!');
    } else {
      Future.delayed(Duration(seconds: 5), _checkEmailVerification);
    }
  }

  /// **📌 Get OTP from Firebase**
  void _getOtp() {
    _auth.verifyPhoneNumber(
      phoneNumber: '+1${_phoneController.text.trim()}',
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() {
          _isOtpSent = false;
          _otpVerified = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: '⚠️ Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // **📌 Helper Methods for UI Components**
Widget _customTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), prefixIcon: Icon(icon)),
      keyboardType: keyboardType,
      obscureText: obscureText,
    ),
  );
}

Widget _customButton(String text, Color color, VoidCallback? onPressed) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: EdgeInsets.symmetric(vertical: 12)),
      child: Text(text),
    ),
  );
}


/// **📌 Verify OTP**
void _verifyOtp() async {
  final code = _otpController.text.trim();
  print("🔢 User Entered OTP: $code");

  if (_verificationId != null && code.isNotEmpty) {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );

      print("✅ Verifying OTP...");
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // **Debugging: Print raw response**
      print("👤 Raw UserCredential Response: ${userCredential}");

      // **Check if the user is authenticated**
      if (userCredential.user != null) {
        print("✅ User authenticated successfully: ${userCredential.user!.uid}");
        setState(() {
          _otpVerified = true;
          _isOtpSent = false; // Hide OTP input after verification
        });

        Fluttertoast.showToast(msg: '✅ OTP Verified Successfully!');
      } else {
        print("⚠️ Warning: UserCredential.user is NULL!");
        Fluttertoast.showToast(msg: '⚠️ OTP Verification Failed.');
      }
    } catch (error, stacktrace) {
      print("❌ OTP Verification Failed: ${error.toString()}");
      print("🔍 Stack Trace: $stacktrace"); // Logs the exact error location
      Fluttertoast.showToast(msg: 'Failed to verify OTP: ${error.toString()}');
    }
  } else {
    print("⚠️ Invalid OTP or Verification ID is null");
    Fluttertoast.showToast(msg: 'Please enter a valid OTP');
  }
}


}
