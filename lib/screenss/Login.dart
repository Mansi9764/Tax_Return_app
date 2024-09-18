import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/questions.dart'; 
import 'package:retail_tax_filing_app/screenss/sign_up.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPhoneLogin = true; // State to toggle between phone and email login

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a login process
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuestionnaireScreen()), // Replace with your next screen
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                  "Sign in to your account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ToggleButtons(
                  isSelected: [_isPhoneLogin, !_isPhoneLogin],
                  onPressed: (int index) {
                    setState(() {
                      _isPhoneLogin = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedBorderColor: Colors.orange.shade200,
                  selectedColor: Colors.white,
                  fillColor: Colors.orange.shade200,
                  color: Colors.black,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Phone"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Email"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _isPhoneLogin
                    ? _buildPhoneInput()
                    : _buildEmailInput(),
                SizedBox(height: 20),
                _buildPasswordInput(),
                SizedBox(height: 30),
                _buildLoginButton(),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                _buildSocialLoginOptions(),
                SizedBox(height: 30),
                _buildSignUpOption(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(Icons.visibility),
          onPressed: () {
            // Toggle password visibility
          },
        ),
      ),
      obscureText: true,
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

  Widget _buildLoginButton() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Login'),
            ),
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        Text(
          "Or continue with",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.red),
              onPressed: () {
                // Handle Google Sign-In
              },
            ),
            IconButton(
              icon: Icon(Icons.apple, color: Colors.black),
              onPressed: () {
                // Handle Apple Sign-In
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpOption() {
    return Center(
      child: Column(
        children: [
          Text(
            "New to EasyTax?",
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            onPressed: () {
              // Navigate to Sign Up Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


