import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
//   

bool _isEmailVerified = false;
  Timer? _timer;

  bool _isOtpSent = false;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
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
                  "Welcome, Please Sign Up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildFirstNameInput(),
               _buildLastNameInput(),
                _buildEmailInput(),
                _buildVerifyEmailButton(),
                _verificationStatus(),
                _buildPhoneInput(),
                SizedBox(height: 20),
                 _buildGetOtpButton(),
                 if (_isOtpSent) _buildOtpInput(),
                 _buildPasswordInput(),
                 SizedBox(height: 20),
                _buildSignUpButton(),
                
              ],
            ),
          ),
        ),
      ),
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
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email';
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
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _signUp(),
      child: Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 12),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildVerifyEmailButton() {
    return Visibility(
      visible: !_isEmailVerified,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () {
          if (!_isEmailVerified) {
            _sendVerificationEmail();
          }
        },
        child: Text('Verify Email'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 12),
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _verificationStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        _isEmailVerified ? "Email has been verified" : "Email not verified yet",
        style: TextStyle(color: _isEmailVerified ? Colors.green : Colors.red),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          _sendVerificationEmail();
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: 'Failed to sign up: ${e.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: 'Verification email has been sent to ${user.email}');
      startCheckingEmailVerification();
    }
  }

  void startCheckingEmailVerification() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      var user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        setState(() {
          _isEmailVerified = true;
        });
        Fluttertoast.showToast(msg: "Email has been verified.");
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

 
  Widget _buildGetOtpButton() {
    return ElevatedButton(
      onPressed: _isOtpSent ? null : _getOtp,
      child: Text('Get OTP'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

   Widget _buildOtpInput() {
    return Column(
      children: [
        TextFormField(
          controller: _otpController,
          decoration: InputDecoration(
            labelText: 'Enter OTP',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.message),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter OTP';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _verifyOtp,
          child: Text('Verify OTP'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }


  void _getOtp() {
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1${_phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() {
            _isOtpSent = false;
            Fluttertoast.showToast(msg: 'Phone verification completed.');
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: 'Phone verification failed: ${e.message}');
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
          });
          Fluttertoast.showToast(msg: 'OTP sent to your phone.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }
  }

  void _verifyOtp() {
    final code = _otpController.text.trim();
    if (_verificationId != null && code.isNotEmpty) {
      final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: code);

      FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
        setState(() {
          Fluttertoast.showToast(msg: 'OTP Verified Successfully!');
          _isOtpSent = false; // Optionally reset this if you want to allow re-verification
        });
      }).catchError((error) {
        Fluttertoast.showToast(msg: 'Failed to verify OTP: ${error.toString()}');
      });
    }
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

}




// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isEmailVerified = false;
//   Timer? _timer;

//   bool _isOtpSent = false;
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   String? _verificationId;
//   bool _isOtpVerified = false;

// @override
// Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text('Sign Up'),
//             backgroundColor: Colors.deepPurple,
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//                 child: Form(
//                     key: _formKey,
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                             Text(
//                                 "Welcome, Please Sign Up",
//                                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//                                 textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 20),
//                             // _buildFirstNameInput(),
//                             // _buildLastNameInput(),
//                             _buildEmailInput(),
//                             _buildVerifyEmailButton(),
//                             _verificationStatus(),
//                             // _buildPhoneInput(),
//                             // _buildGetOtpButton(),
//                             // if (_isOtpSent) _buildOtpInput(),
//                             // SizedBox(height: 20),
//                             // if (_isOtpVerified || _isOtpSent) _otpVerificationStatus(),
//                             _buildPasswordInput(),
//                             SizedBox(height: 20),
//                             _buildSignUpButton(),
//                         ],
//                     ),
//                 ),
//             ),
//         ),
//     );
// }



//   Widget _buildEmailInput() {
//     return TextFormField(
//       controller: _emailController,
//       decoration: InputDecoration(
//         labelText: 'Email',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.email),
//       ),
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty || !value.contains('@')) {
//           return 'Please enter a valid email';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildPasswordInput() {
//     return TextFormField(
//       controller: _passwordController,
//       decoration: InputDecoration(
//         labelText: 'Password',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.lock),
//       ),
//       obscureText: true,
//       validator: (value) {
//         if (value!.isEmpty || value.length < 6) {
//           return 'Password must be at least 6 characters';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildSignUpButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : () => _signUp(),
//       child: Text('Sign Up'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.deepPurple,
//         padding: EdgeInsets.symmetric(vertical: 12),
//         textStyle: TextStyle(fontSize: 18),
//       ),
//     );
//   }

//   Widget _buildVerifyEmailButton() {
//     return Visibility(
//       visible: !_isEmailVerified,
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : () {
//           if (!_isEmailVerified) {
//             _sendVerificationEmail();
//           }
//         },
//         child: Text('Verify Email'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.orange,
//           padding: EdgeInsets.symmetric(vertical: 12),
//           textStyle: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }

//   Widget _verificationStatus() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Text(
//         _isEmailVerified ? "Email has been verified" : "Email not verified yet",
//         style: TextStyle(color: _isEmailVerified ? Colors.green : Colors.red),
//       ),
//     );
//   }

//   Future<void> _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         setState(() {
//           _isLoading = true;
//         });
//         UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//         User? user = userCredential.user;
//         if (user != null && !user.emailVerified) {
//           _sendVerificationEmail();
//         }
//       } on FirebaseAuthException catch (e) {
//         Fluttertoast.showToast(msg: 'Failed to sign up: ${e.message}');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _sendVerificationEmail() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null && !user.emailVerified) {
//       await user.sendEmailVerification();
//       Fluttertoast.showToast(msg: 'Verification email has been sent to ${user.email}');
//       startCheckingEmailVerification();
//     }
//   }

//   void startCheckingEmailVerification() {
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
//       await FirebaseAuth.instance.currentUser!.reload();
//       var user = FirebaseAuth.instance.currentUser;
//       if (user != null && user.emailVerified) {
//         setState(() {
//           _isEmailVerified = true;
//         });
//         Fluttertoast.showToast(msg: "Email has been verified.");
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

 
//   Widget _buildGetOtpButton() {
//     return ElevatedButton(
//       onPressed: _isOtpSent ? null : _getOtp,
//       child: Text('Get OTP'),
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.white, backgroundColor: Colors.blue,
//         padding: EdgeInsets.symmetric(vertical: 12),
//       ),
//     );
//   }

//    Widget _buildOtpInput() {
//     return Column(
//       children: [
//         TextFormField(
//           controller: _otpController,
//           decoration: InputDecoration(
//             labelText: 'Enter OTP',
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(Icons.message),
//           ),
//           keyboardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter OTP';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: _verifyOtp,
//           child: Text('Verify OTP'),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white, backgroundColor: Colors.green,
//             padding: EdgeInsets.symmetric(vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }


//   void _getOtp() {
//     if (_phoneController.text.isNotEmpty) {
//       setState(() {
//         _isLoading = true;
//       });

//       FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '+1${_phoneController.text}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await FirebaseAuth.instance.signInWithCredential(credential);
//           setState(() {
//             _isOtpSent = false;
//             Fluttertoast.showToast(msg: 'Phone verification completed.');
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           Fluttertoast.showToast(msg: 'Phone verification failed: ${e.message}');
//           setState(() {
//             _isLoading = false;
//           });
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//             _isOtpSent = true;
//             _isLoading = false;
//           });
//           Fluttertoast.showToast(msg: 'OTP sent to your phone.');
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     }
//   }

//   // void _verifyOtp() {
//   //   final code = _otpController.text.trim();
//   //   if (_verificationId != null && code.isNotEmpty) {
//   //     final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: code);

//   //     FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
//   //       setState(() {
//   //         Fluttertoast.showToast(msg: 'OTP Verified Successfully!');
//   //         _isOtpSent = false; // Optionally reset this if you want to allow re-verification
//   //       });
//   //     }).catchError((error) {
//   //       Fluttertoast.showToast(msg: 'Failed to verify OTP: ${error.toString()}');
//   //     });
//   //   }
//   // }

// void _verifyOtp() {
//     final code = _otpController.text.trim();
//     if (_verificationId != null && code.isNotEmpty) {
//         final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: code);

//         FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
//             setState(() {
//                 _isOtpVerified = true;  // Set the OTP verified status to true on successful verification
//                 Fluttertoast.showToast(msg: 'OTP Verified Successfully!');
//                 _isOtpSent = false; // Reset this if re-verification is allowed
//             });
//         }).catchError((error) {
//             setState(() {
//                 _isOtpVerified = false; // Set the OTP verified status to false on failure
//             });
//             Fluttertoast.showToast(msg: 'Failed to verify OTP: ${error.toString()}');
//         });
//     } else {
//         Fluttertoast.showToast(msg: 'Please enter a valid OTP');
//     }
// }



//    Widget _buildPhoneInput() {
//     return TextFormField(
//       controller: _phoneController,
//       decoration: InputDecoration(
//         labelText: 'Phone Number',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.phone),
//       ),
//       keyboardType: TextInputType.phone,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your phone number';
//         }
//         if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//           return 'Please enter a valid 10-digit phone number';
//         }
//         return null;
//       },
//     );
//   }

//     Widget _buildFirstNameInput() {
//     return TextFormField(
//       controller: _firstNameController,
//       decoration: InputDecoration(
//         labelText: 'First Name',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.person),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your first name';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildLastNameInput() {
//     return TextFormField(
//       controller: _lastNameController,
//       decoration: InputDecoration(
//         labelText: 'Last Name',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.person),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your last name';
//         }
//         return null;
//       },
//     );
//   }

// Widget _otpVerificationStatus() {
//     return Container(
//         padding: EdgeInsets.all(16),
//         child: Text(
//             _isOtpVerified ? "OTP has been verified successfully" : "OTP not verified yet",
//             style: TextStyle(color: _isOtpVerified ? Colors.green : Colors.red),
//         ),
//     );
// }



// }



