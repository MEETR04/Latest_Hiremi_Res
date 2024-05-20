import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPagee extends StatefulWidget {
  final String? sourceScreen;

  const RazorPayPagee({Key? key, this.sourceScreen}) : super(key: key);

  @override
  State<RazorPayPagee> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPagee> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> openCheckout(int amount) async {
    try {
      var options = {
        'key': "rzp_test_1DP5mmOlF5G5ag",
        'amount': amount*100,
        'name': 'Company Name.',
        'description': 'Description for order',
        'timeout': 60,
        'prefill': {
          'contact': '1234567', // Replace with user's contact number
          'email': 'test@gmail.com' // Replace with user's email
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Errors: $e');
      // Handle error
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful. Payment ID: ${response.paymentId}",
        toastLength: Toast.LENGTH_SHORT);
    print("Payment successful. Payment ID: ${response.paymentId}");
    // Handle successful payment, update status, etc.
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message} ");
    Fluttertoast.showToast(
        msg: "Payment failed: ${response.message}", toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet: ${response.walletName}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay Payment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome to Razorpay",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: amtController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount to be paid',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (amtController.text.isNotEmpty) {
                  int amount = int.parse(amtController.text);
                  openCheckout(amount);
                }
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
