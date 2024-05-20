import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';



class PaymentScreen2 extends StatefulWidget {
  final String? sourceScreen;

  const PaymentScreen2({Key? key, this.sourceScreen}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen2> {
  String loginEmail="";
  String ID2=" ";
  String email =" ";
  String rateUrCommunication="";
  String collegeId =" ";
  String yourSkills =" ";
  String status =" ";
  String scheduleDate =" ";
  String scheduleTime =" ";
  String uid = '';
  var uuid = Uuid();
  final TextEditingController _amountController = TextEditingController();
  final Razorpay _razorpay = Razorpay();
  bool _isPaymentInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }
  Future<String> _generateRazorpayOrderId() async {
    // Replace this with your logic to generate a unique order ID
    // You may need to call your backend API to generate the order ID
    // For demonstration purposes, I'll just return a random order ID
    return Uuid().v4();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String razorpayOrderId = await _generateRazorpayOrderId();
    _verifyPayment(response.paymentId, response.signature,razorpayOrderId);
    Fluttertoast.showToast(msg: "payment Succesful"+ response.paymentId!,toastLength: Toast.LENGTH_SHORT);
    print(" ${response.paymentId!}");
    printDataFromSharedPreferences();
    if (widget.sourceScreen =='_EnrollDialogForMentorship') {
      print('User is coming from ${widget.sourceScreen}');
      updatePaymentStatusInMentorship() ;
      print(loginEmail);

    }
    else if(widget.sourceScreen =='_EnrollDialogforRegistration')
    {
      print('User is coming from ${widget.sourceScreen}');
      updatePaymentStatusInRegistration();
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment error: ${response.code.toString()} - ${response.message}');
    print("Payment Error: ${response.code} - ${response.message} ");


    Fluttertoast.showToast(msg: "Payment failed: ${response.message}", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet: ${response.walletName}');
    Fluttertoast.showToast(msg: "External Wallet"+ response.walletName!,toastLength: Toast.LENGTH_SHORT);

  }

  Future<void> _processPayment() async {
    if (_amountController.text.isEmpty || _isPaymentInProgress) {
      return;
    }

    setState(() {
      _isPaymentInProgress = true;
    });

    var options = {
      'key': 'rzp_live_LH9WuEt66nRZh9',
      'amount': int.parse(_amountController.text) * 100, // amount in the smallest currency unit
      'name': 'Flutter Demo',
      'description': 'Payment for some product',
      'prefill': {'contact': '', 'email': ''},
      'external': {'wallets': ['paytm']}
    };

    try {
      _razorpay.open(options);
    }
    catch (e) {
      print('Error: $e');
      setState(() {
        _isPaymentInProgress = false;
      });
    }
  }
  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
    }
  }
  Future<void> submitVerification() async {

    try {
      // Prepare the request body

      uid = uuid.v4().substring(0, 8);
      Map<String, dynamic> body = {
        //"id": generateRandomID(),

        'uid':uid,
        "user_email":email,
        "college_id_number": collegeId,
        "communication_skills": rateUrCommunication,
        "status":status,
        "skills":yourSkills,

      };

      // Make the API request
      final response = await http.post(
        Uri.parse(ApiUrls.verificationDetails),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          // Add other headers as needed
        },
      );


      if (response.statusCode == 201) {

        // Successful API call

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(sourceScreen: 'Screen2', uid: uid, username: '', verificationId: ID2,);
        }
        ),);
        // print('Stored UID: $uid');
        // print('${response.body}');
        // print('API Call Successful');
        //print('Username: ${widget.username}');


        await VerificationID();
        // You can handle the response data here if needed
      }
      else {
        // Handle API error
        print('API Call Failessssd: ${response.body}');
        print('API Call Failed: ${response.statusCode}');
        // You can handle the error response here if needed
      }
    } catch (error) {
      // Handle other errors, e.g., network issues
      print('Error : $error');
      print('Rate of Communication: $rateUrCommunication');

    }
  }
  Future<void> VerificationID() async {
    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}/verification-details/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          // Generate a unique ID based on the index
          final String generatedIdoforAll = (index + 1).toString();

          // Print the generated ID
          // print('Generated ID for index $index: $generatedIdoforAll');
          final String userEmail=data['user_email'];
          if(userEmail==loginEmail)
          {
            ID2=(index+1).toString();
            print(ID2);
            break;
          }
          // Here you can use the generated ID and other data as needed
          // For example:
          // final String uid = data['uid']?.toString() ?? '';
          // final String userEmail = data['user_email']?.toString() ?? '';

          // Now you can use the generated ID and other data as needed
          // For example, you can make your API call or update the UI
        }
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchData: $e');
    }
  }
  void printDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString('email') ?? '';
    collegeId = prefs.getString('collegeId') ?? '';
    rateUrCommunication=prefs.getString('communication_skills') ?? '';
    yourSkills = prefs.getString('yourSkills') ?? '';
    status = prefs.getString('status') ?? '';
    scheduleDate = prefs.getString('scheduleDate') ?? '';
    scheduleTime = prefs.getString('scheduleTime') ?? '';

    print("Data from SharedPreferences:");
    print("Email: $email");
    print("Rate ur communication :$rateUrCommunication");
    print("College ID: $collegeId");
    print("Your Skills: $yourSkills");
    print("Status: $status");
    print("Schedule Date: $scheduleDate");
    print("Schedule Time: $scheduleTime");
    submitVerification();
  }


  void updatePaymentStatusInRegistration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}/api/registers/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['email'];

              if (email == loginEmail) {


                setState(() {
                  // Assuming you have the registration ID stored somewhere
                  int registrationId = user['id']; // Replace with the actual registration ID

                  // Make a request to update payment status only if the transaction status is SUCCESS

                  _updatePaymentStatusInRegistration(registrationId);

                });

                // Exit the loop once a match is found
                break;
              }
            }
          } else {
            print('Email not found on the server.');
          }
        }
      } catch (e) {
        print('Error in PhonePeGateway: $e');
      }

    }
  }
  void _updatePaymentStatusInRegistration(int registrationId) async {
    // Replace the API URL with your actual API endpoint
    final apiUrl = '${ApiUrls.baseurl}/api/registers/$registrationId/';

    try {
      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          //"Authorization": "Bearer YOUR_ACCESS_TOKEN", // Replace with your access token
        },
        body: jsonEncode({

          "payment_status": "Enrolled",

          // Add other existing fields as needed
        }),

      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(sourceScreen: '', uid: uid, username: '', verificationId: ID2,);
        }
        ),);
        print("Payment status updated successfully for registration ID $registrationId");
      } else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, registration ID:$registrationId");
      }
    } catch (error) {
      print(error);
    }
  }
  void  updatePaymentStatusInMentorship() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['email'];

              if (email == loginEmail) {


                setState(() {
                  // Assuming you have the registration ID stored somewhere
                  int mentorshipId = user['id']; // Replace with the actual registration ID

                  // Make a request to update payment status only if the transaction status is SUCCESS

                  _updatePaymentStatusforMentorship(mentorshipId);

                });

                // Exit the loop once a match is found
                break;
              }
            }
          } else {
            print('Email not found on the server.');
          }
        }
      } catch (e) {
        print('Error in PhonePeGateway: $e');
      }

    }
  }
  void _updatePaymentStatusforMentorship(int mentorshipId) async {
    // Replace the API URL with your actual API endpoint
    final apiUrl = '${ApiUrls.baseurl}/api/mentorship/$mentorshipId/';

    try {
      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          //"Authorization": "Bearer YOUR_ACCESS_TOKEN", // Replace with your access token
        },
        body: jsonEncode({

          "payment_status": "Enrolled",

          // Add other existing fields as needed
        }),

      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(sourceScreen: 'Screen1', uid: uid, username: '', verificationId: ID2,);
        }
        ),);
        print("Update payment status. Status code: ${response.statusCode}, Response: ${response.body}, mentorship ID:$mentorshipId");
        print("Payment status updated successfully for mentorship ID $mentorshipId");
      }


      else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, mentorship ID:$mentorshipId");
      }
    } catch (error) {
      print(error);
    }
  }







  Future<void> _verifyPayment(String? paymentId, String? signature,razorpayOrderId) async {
    if (paymentId == null) {
      print('Payment ID is null');
      return;
    }

    final url = 'http://13.127.81.177:8000/api/payments/';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'amount': _amountController.text,
        'payment_id': paymentId,
        'razorpay_order_id': razorpayOrderId,
        'email':loginEmail,
        //'razorpay_signature': signature,
      },
    );

    if (response.statusCode == 200) {
      // Payment successful, you can navigate to success screen or perform further actions
      print('Payment successful');
    } else {
      // Payment failed, you can show error message or retry payment
      print('Payment failed');
    }

    setState(() {
      _isPaymentInProgress = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay Integration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Enter Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment,
              child: _isPaymentInProgress
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
