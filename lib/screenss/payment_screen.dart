import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retail_tax_filing_app/screenss/variables.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Payment Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              height: 175,
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
 CreditCardForm(
  formKey: GlobalKey<FormState>(),  // Global key to uniquely identify the form
  onCreditCardModelChange: onCreditCardModelChange,  // Callback when form fields change
  cardNumber: cardNumber,  // Binding the state-managed card number
  expiryDate: expiryDate,  // Binding the state-managed expiry date
  cardHolderName: cardHolderName,  // Binding the state-managed card holder's name
  cvvCode: cvvCode,  // Binding the state-managed CVV code
  //: Colors.blue,  // You can still set a theme color if this is supported
  obscureCvv: true,  // Optionally obscure the CVV input
  obscureNumber: true,  // Optionally obscure the card number input
),


ElevatedButton(
              onPressed: submitPayment,
              child: Text('Submit Payment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitPayment() async {
    final endpoint = 'https://secure.nmi.com/api/transact.php'; // NMI Endpoint
    final headers = {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'security_key': security_key,
      'type': 'sale',
      'amount': '0.01',
      'ccnumber': cardNumber.replaceAll(' ', ''),
      'ccexp': expiryDate.replaceAll('/', ''),
      'cvv': cvvCode,
    };

    String encodedBody = body.keys.map((key) => '$key=${Uri.encodeComponent(body[key]!)}').join('&');

    try {
      final response = await http.post(Uri.parse(endpoint), headers: headers, body: encodedBody);
      if (response.statusCode == 200) {
        var parsedResponse = Uri.splitQueryString(response.body);
        if (parsedResponse['response_code'] == '100') {
          handleSuccess(parsedResponse);
        } else {
          throw Exception('Failed to process payment: ${parsedResponse['responsetext']}');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      handleError(e);
    }
  }

  void handleSuccess(Map<String, String> response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Transaction ID: ${response['transactionid']}'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleError(dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Error'),
        content: Text(error.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}