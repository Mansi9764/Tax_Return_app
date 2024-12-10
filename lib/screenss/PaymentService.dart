import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:retail_tax_filing_app/screenss/Payment_Success.dart';
import 'package:retail_tax_filing_app/screenss/payment_error.dart';
import 'package:retail_tax_filing_app/screenss/variables.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String address1 = 'US'; 
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      firstName = creditCardModel.cardHolderName.split(' ')[0];
      middleName = creditCardModel.cardHolderName.split(' ').length > 2 ? creditCardModel.cardHolderName.split(' ')[1] : '';
      lastName = creditCardModel.cardHolderName.split(' ').last;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
    print('Updated card details: $firstName $middleName $lastName');
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
                cardHolderName: '$firstName ${middleName.isNotEmpty ? '$middleName ' : ''}$lastName'.trim(),
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                height: 175,
                width: MediaQuery.of(context).size.width,
                animationDuration: Duration(milliseconds: 1000),
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {
                  // Handle the change in credit card brand here
                  print('Detected credit card brand: $creditCardBrand');
                },
              ),

            CreditCardForm(
              formKey: formKey,
              onCreditCardModelChange: onCreditCardModelChange,
              obscureCvv: true,
              obscureNumber: true,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: '$firstName $middleName $lastName'.trim(),
              cvvCode: cvvCode,
            ),
            ElevatedButton(
              onPressed: submitPayment,
              child: Text('Submit Payment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitPayment() async {
    const endpoint = 'https://secure.nmi.com/api/transact.php';
    final headers = {
      "accept": "application/x-www-form-urlencoded",
      "content-type": "application/x-www-form-urlencoded"
    };

    final Map<String, String> body = {
      'security_key': security_key,
      'type': 'sale',
      'amount': '0.01',
      'ccnumber': cardNumber.replaceAll(' ', ''),
      'ccexp': expiryDate.replaceAll('/', ''),
      'cvv': cvvCode,
      'zip': '90815',
      'first_name': firstName,
      'last_name': lastName,
      'middle_initial': middleName.isNotEmpty ? middleName[0] : '',
      'address1': address1,
    };

    print('Sending payment request: $body');

    String encodedBody = body.keys
        .map((key) => '$key=${Uri.encodeComponent(body[key]!)}')
        .join('&');

    try {
      final response = await http.post(Uri.parse(endpoint), headers: headers, body: encodedBody);
      print('Received response: ${response.body}');
      if (response.statusCode == 200) {
        handleResponse(response.body);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Payment error: $e');
      handleError(e.toString());
    }
  }

  void handleResponse(String responseBody) {
  print('Processing response: $responseBody');
  var decoded = Uri.splitQueryString(responseBody);
  if (decoded['response'] == '1') {
    String transactionId = decoded['transactionid'] ?? 'N/A';
    print('Payment successful: Transaction ID $transactionId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(transactionId: transactionId),
      ),
    );
  } else {
    print('Payment failed: ${decoded['responsetext']}');
    handleError('Payment failed: ${decoded['responsetext']}');
  }
}


//   void handleError(String error) {
//     print('Error: $error');
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Payment Error'),
//         content: Text(error),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
void handleError(String error) {
  String userFriendlyError = error.contains('Do Not Honor')
      ? 'Your bank declined the transaction. Please contact your bank or try another payment method.'
      : error;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentErrorPage(error: userFriendlyError),
    ),
  );
}
}