import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retail_tax_filing_app/screenss/EnterOtpScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // void _signUp() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     // Simulate a sign-up process
  //     Future.delayed(Duration(seconds: 2), () {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Sign Up Successful!')),
  //       );
  //       Navigator.pop(context); // Go back to login screen after sign up
  //     });
  //   }
  // }

  void _signUp() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    // Phone verification
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+1${_phoneController.text.trim()}', // Ensure the phone number is in E.164 format
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android only: automatically sign in the user.
        await FirebaseAuth.instance.signInWithCredential(credential);
        _onAuthenticationSuccessful();
      },

      verificationFailed: (FirebaseAuthException e) {
      print("Verification failed: ${e.code}, Message: ${e.message}");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify phone number: ${e.message}')),
      );
    },
    codeSent: (String verificationId, int? resendToken) {
      print("Code sent to the user");
      _onCodeSent(verificationId);
    },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout, handle as needed
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Create your account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildFirstNameInput(),
                SizedBox(height: 20),
                _buildLastNameInput(),
                SizedBox(height: 20),
                _buildEmailInput(),
                SizedBox(height: 20),
                _buildPhoneInput(),
                SizedBox(height: 20),
                _buildPasswordInput(),
                SizedBox(height: 30),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameInput() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameInput() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Please enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Sign Up'),
            ),
    );
  }


void _onAuthenticationSuccessful() {
  setState(() {
    _isLoading = false;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Sign Up Successful!')),
  );
  Navigator.pop(context); // Go back to login screen after sign up
}

void _onCodeSent(String verificationId) {
  // Navigate to a new screen where the user can type the OTP received
  Navigator.push(context, MaterialPageRoute(builder: (context) => EnterOtpScreen(verificationId: verificationId)));
}
}