import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_routersdk/paytm_routersdk.dart';
import 'package:paytmthree/callbackurl.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String responseText = '';
  final String apiUrl = 'http://13.127.81.177:8000/pay/';
  final String orderStatusUrl = 'http://13.127.81.177:8000/order-status/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Request'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _makeTransactionRequest,
              child: Text('Start Transaction'),
            ),
            SizedBox(height: 20),
            Text('Response: $responseText'),
          ],
        ),
      ),
    );
  }

  Future<void> checkOrderStatus(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$orderStatusUrl'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"order_id": orderId}),
      );

      if (response.statusCode == 200) {
        print("Order is complete");
        print(response.statusCode);
        print(response.body);
      } else {
        print("Order is not complete");
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _makeTransactionRequest() async {
    try {
      // API endpoint
      var url = 'http://13.127.81.177:8000/pay/';

      // Generate a unique order ID
      var orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Parameters
      var params = {'name': 'newcallbackurl', 'amount': '1', 'orderId': orderId};
      print("Order ID is $orderId");

      // Making POST request
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(params),
        headers: {'Content-Type': 'application/json'},
      );

      // Checking response status
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Response data: $responseData'); // Print response data for debugging

        // Check if all required fields are present in the response
        if (responseData.containsKey('txnToken') &&
            responseData.containsKey('orderId') &&
            responseData.containsKey('amount')) {
          var txnToken = responseData['txnToken'];
          var orderId = responseData['orderId'];
          var amount = responseData['amount'];
          var mid = '216820000000000077910';

          var callbackUrl = 'http://13.127.81.177:8000/callback/';
          var isStaging = false; // Set to true for staging environment

          // Use router SDK to initiate transaction
          var transactionResponse =
          await _initiateTransaction(txnToken, orderId, amount, mid, callbackUrl, isStaging);

          // Check if transactionResponse is not null and contains 'TXNID'
          if (transactionResponse != null && transactionResponse.containsKey('TXNID')) {
            // Dynamically create txnDetails based on transactionResponse
            var txnDetails = Map<String, dynamic>.from(transactionResponse);

            setState(() {
              responseText =
              'Transaction successful! Transaction ID: ${transactionResponse['TXNID']}';
            });

            // Post transaction response to callback URL
            await _postTransactionResponse(callbackUrl, txnDetails, orderId);
          } else {
            setState(() {
              responseText =
              'Error: Transaction failed or missing transaction ID in response';
            });
          }
        } else {
          setState(() {
            responseText = 'Error: Missing required data in response';
          });
        }
      } else {
        // Request failed
        setState(() {
          responseText = 'Request failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Error occurred
      setState(() {
        responseText = 'Error: $e';
        print(e);
      });
    }
  }

  Future<Map?> _initiateTransaction(String txnToken, String orderId, String amount, String mid,
      String callbackUrl, bool isStaging) async {
    try {
      // Initiate the transaction using Paytm Router SDK
      var transactionResponse =
      await PaytmRouterSdk.startTransaction(mid, orderId, amount, txnToken, callbackUrl, isStaging);

      // Handle the transaction response
      if (transactionResponse != null && transactionResponse['STATUS'] == 'TXN_SUCCESS') {
        checkOrderStatus(orderId);
        return transactionResponse;

      } else {
        checkOrderStatus(orderId);
        throw Exception('Transaction failed: ${transactionResponse!['RESPMSG']}');

      }

    } catch (e) {
      // Error occurred during transaction initiation
      throw Exception('Error initiating transaction: $e');
    }
  }

  Future<void> _postTransactionResponse(
      String callbackUrl, Map<String, dynamic> response, String orderId) async {
    try {
      // Making POST request to callback URL with transaction response data
      var callbackResponse = await http.post(
        Uri.parse(callbackUrl),
        body: json.encode(response),
        headers: {'Content-Type': 'application/json'},
      );

      // Checking response status
      if (callbackResponse.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CallbackScreen(
              callbackUrl: callbackUrl,
              responseBody: callbackResponse.body,
            ),
          ),
        );
        print('Transaction response posted successfully');
        print(callbackResponse.statusCode);
        print(callbackResponse.body);

        // Redirect to CallbackScreen
      } else {
        print('Failed to post transaction response. Status code: ${callbackResponse.statusCode}');
      }
    } catch (e) {
      // Error occurred while posting transaction response
      print('Error posting transaction response: $e');
    }
  }
}