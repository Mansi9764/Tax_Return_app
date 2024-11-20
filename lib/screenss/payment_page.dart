// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:retail_tax_filing_app/screenss/PaymentService.dart'; // Ensure path is correct

// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final storage = FlutterSecureStorage();
//   List<Map<String, String>> savedCards = [
//     {'cardNumber': '4242 4242 4242 4242', 'expiryDate': '08/24', 'cardHolderName': 'John Doe', 'cvvCode': '123'},
//     {'cardNumber': '5555 5555 5555 4444', 'expiryDate': '10/24', 'cardHolderName': 'Jane Doe', 'cvvCode': '456'},
//   ];
//   int? selectedCardIndex;
//   late PaymentService paymentService;

//   @override
//   void initState() {
//     super.initState();
//     paymentService = PaymentService(
//       onSuccess: (transactionId) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Payment Successful'),
//             content: Text(transactionId),
//             actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
//           ),
//         );
//       },
//       onError: (error) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Payment Error'),
//             content: Text(error),
//             actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment Options')),
//       body: Column(
//         children: [
//           ElevatedButton(onPressed: showPaymentOptions, child: Text('Continue to Pay')),
//           if (selectedCardIndex != null)
//             CreditCardWidget(
//               cardNumber: savedCards[selectedCardIndex!]['cardNumber']!,
//               expiryDate: savedCards[selectedCardIndex!]['expiryDate']!,
//               cardHolderName: savedCards[selectedCardIndex!]['cardHolderName']!,
//               cvvCode: savedCards[selectedCardIndex!]['cvvCode']!,
//               showBackView: false, onCreditCardWidgetChange: (CreditCardBrand ) {  },
//             ),
//           if (selectedCardIndex != null)
//             ElevatedButton(onPressed: () => submitPayment(selectedCardIndex!), child: Text('Pay with Selected Card')),
//         ],
//       ),
//     );
//   }

//   void showPaymentOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 300,
//           child: Column(
//             children: [
//               ListTile(
//                 title: Text('Pay with New Card'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   showNewCardForm(); // Trigger the new card form
//                 },
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: savedCards.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text('**** **** **** ' + savedCards[index]['cardNumber']!.substring(15)),
//                       subtitle: Text('Expires ' + savedCards[index]['expiryDate']!),
//                       onTap: () {
//                         setState(() { selectedCardIndex = index; });
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void showNewCardForm() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCardForm(paymentService: paymentService)));
//   }

//   void submitPayment(int index) {
//     Map<String, String> cardDetails = savedCards[index];
//     paymentService.submitPayment(
//       cardNumber: cardDetails['cardNumber']!,
//       expiryDate: cardDetails['expiryDate']!,
//       cvvCode: cardDetails['cvvCode']!,
//       amount: 10.0, // Example amount to charge
//     );
//   }
// }

// class NewCardForm extends StatelessWidget {
//   final PaymentService paymentService;

//   NewCardForm({required this.paymentService});

//   final cardNumberController = TextEditingController();
//   final expiryDateController = TextEditingController();
//   final cardHolderNameController = TextEditingController();
//   final cvvController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('New Card Details')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CreditCardForm(
//               formKey: GlobalKey<FormState>(), // Handle form key
//               cardNumber: cardNumberController.text,
//               expiryDate: expiryDateController.text,
//               cardHolderName: cardHolderNameController.text,
//               cvvCode: cvvController.text,
//               onCreditCardModelChange: (CreditCardModel data) {}, // Update fields
//             ),
//             ElevatedButton(
//               onPressed: () => submitNewCard(context),
//               child: Text('Submit New Card'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void submitNewCard(BuildContext context) {
//     if (cardNumberController.text.isEmpty ||
//         expiryDateController.text.isEmpty ||
//         cardHolderNameController.text.isEmpty ||
//         cvvController.text.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('All fields are required'),
//           actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
//         ),
//       );
//       return;
//     }

//     paymentService.submitPayment(
//       cardNumber: cardNumberController.text,
//       expiryDate: expiryDateController.text,
//       cvvCode: cvvController.text,
//       amount: 10.0,
//     );
//     Navigator.of(context).pop();
//   }
// }
