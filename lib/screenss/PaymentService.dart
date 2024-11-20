import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:retail_tax_filing_app/screenss/variables.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String userSourceKey = 'checkout_public_hEM79u2M53q7cn-D569RGWRzEdk66BEPK'; // Replace with your tokenization key
  //final String securityKey = 'your_security_key_here'; // Replace with your security key

  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';
  String cardHolderName = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Payment Details'),
        centerTitle: true,
      ),
      body: isProcessing ? _buildProcessingView() : _buildPaymentForm(),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Processing Payment...', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '4111 1111 1111 1111',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Card number is required';
                }
                if (!isValidCardNumber(value.replaceAll(' ', ''))) {
                  return 'Enter a valid card number';
                }
                return null;
              },
              onChanged: (value) => cardNumber = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
                hintText: '12/25',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Expiry date is required';
                }
                if (!isValidExpiryDate(value)) {
                  return 'Enter a valid expiry date';
                }
                return null;
              },
              onChanged: (value) => expiryDate = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'CVV',
                hintText: '123',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CVV is required';
                }
                if (value.length != 3) {
                  return 'CVV must be 3 digits';
                }
                return null;
              },
              onChanged: (value) => cvvCode = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cardholder name is required';
                }
                return null;
              },
              onChanged: (value) => cardHolderName = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPayment,
              child: Text('Submit Payment'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPayment() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isProcessing = true;
      });

      try {
        // Perform tokenization and payment processing here
        final token = await _tokenizeCardDetails();
        await _processPayment(token);

        setState(() {
          isProcessing = false;
        });

        _showSuccessDialog();
      } catch (e) {
        setState(() {
          isProcessing = false;
        });

        _showErrorDialog(e.toString());
      }
    }
  }

  // Future<String> _tokenizeCardDetails() async {
  //   //const endpoint = 'https://secure.nmi.com/token/Collect.js';

  //   // Here, mock the token for demonstration
  //   return Future.delayed(Duration(seconds: 2), () => 'mock-token-123');
  // }

  Future<String> _tokenizeCardDetails() async {
  //const endpoint = 'https://secure.nmi.com/api/tokenize.php';
  const endpoint = 'https://secure.nmi.com/token/Collect.js';


  final body = {
    'source_key': userSourceKey, // Use the User Source Key provided by NMI
    'ccnumber': cardNumber.replaceAll(' ', ''), // Clean card number of spaces
    'ccexp': expiryDate.replaceAll('/', ''), // Format MMYY
    'cvv': cvvCode,
  };

  try {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = Uri.splitQueryString(response.body);
      if (responseData.containsKey('token')) {
        return responseData['token']!;
      } else {
        throw Exception('Tokenization failed: ${responseData['responsetext']}');
      }
    } else {
      throw Exception('Tokenization failed with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error during tokenization: $e');
  }
}


  Future<void> _processPayment(String token) async {
    const endpoint = 'https://secure.nmi.com/api/transact.php';

    final body = {
      'security_key': security_key,
      'type': 'sale',
      'amount': '0.01',
      'payment_token': token,
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Payment failed with status: ${response.statusCode}');
    }

    final result = Uri.splitQueryString(response.body);
    if (result['response_code'] != '100') {
      throw Exception(result['responsetext'] ?? 'Payment failed');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Your transaction was successful!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Failed'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool isValidCardNumber(String cardNumber) {
    // Luhn Algorithm for card number validation
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool isValidExpiryDate(String expiryDate) {
    final now = DateTime.now();
    final parts = expiryDate.split('/');

    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}');

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final expiry = DateTime(year, month);

    return expiry.isAfter(now);
  }
}
