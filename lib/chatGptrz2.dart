import 'dart:convert';
import 'dart:ui';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/PaymentSuccesful.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/widgets/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Payment',
      // home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String? sourceScreen;
  final int paymentAmount;
  const PaymentScreen({Key? key, this.sourceScreen,required this.paymentAmount}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String loginEmail="";
  String ID2=" ";
  String email =" ";
  var Phone_Number;
  String rateUrCommunication="";
  String collegeId =" ";
  String yourSkills =" ";
  String status =" ";
  String scheduleDate =" ";
  String scheduleTime =" ";
  String uid = '';
  var uuid = Uuid();
  // final TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay;
  bool _isPaymentInProgress = false;
  late TextEditingController _amountController;
  late String _orderId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _loadUserEmailandPhoneNumber();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _amountController =  TextEditingController(text: widget.paymentAmount.toString());
     _generateOrderId();
    //_showVerificationDialog();
     // _startPayment();
   // Generate Order ID when the screen initializes
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
  void _showVerificationDialog() async {
    try {
      // Make HTTP request to get discount data
      final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/discount/'));

      if (response.statusCode == 200) {
        // Parse the response JSON
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final Map<String, dynamic> discountData = data.last; // Access the last element in the list
          final int discount = discountData['discount'];
          final int originalPrice = discountData['original_price'];

          // Calculate discounted price
          final double discountedPrice = originalPrice - (originalPrice * discount / 100);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Stack(
                children: [
                  // Blurred background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  // AlertDialog on top of the blurred background
                  AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Unlock the benefits of our services",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FontMain',
                              fontSize: 18,
                              color: Color(0xFFBD232B),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            "After verification, you can applyfor job and internship opportunities! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FontMain',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed:(){
                            _startPayment();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PaymentScreen(paymentAmount: 1),
                            //   ),
                            // );

                          }

                          // paymentScreen._startPayment
                          // Navigate to payment screen with the discounted price
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PaymentScreen(paymentAmount: 1),
                          //   ),
                          // );
                          ,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF13640),
                            minimumSize: Size(250, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Pay Rs",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),

                                TextSpan(
                                  text: " ${discountedPrice.toInt().toString()}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),

                                // TextSpan(
                                //   text: "1000",
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 20,
                                //     decoration: TextDecoration.lineThrough,
                                //     decorationColor: Colors.black87,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

      }


    } catch (e) {
      // Handle other exceptions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String enteredAmount = _amountController.text;
    double amount = double.parse(enteredAmount);
    _verifyPayment(response.paymentId!, amount);
    print(response.paymentId);
    print("Success");
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
    else if(widget.sourceScreen =='_EnrollDialogForCorporateTraining')
    {
      print('User is coming from ${widget.sourceScreen}');
      updatePaymentStatusInCorporateTraining();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  Future<void>_verifyPayment(String paymentId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.127.81.177:8000/api/generate-verification-token/'),
        body: {'payment_id': paymentId, 'payment_amount': amount.toString()},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print('Payment verified');
          print(response.statusCode);
          print(response.body);
          // Payment verified, proceed with your logic
        } else {
          print('Payment verification failed');
        }
      } else {
        print(response.statusCode);
        print(response.body);
        print('Failed to verify payment');
      }
    } catch (error) {
      print('Error verifying payment: $error');
    }
  }
  Future<void> _generateOrderId() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic cnpwX2xpdmVfTEg5V3VFdDY2blJaaDk6QW1vTEg3R205cnZlNWpNdDJoRFF2Y1Rp', // Replace with your actual API key
        },
        body: json.encode({
          'amount': widget.paymentAmount * 100,
          'currency': 'INR',
          'payment_capture': 1,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _orderId = data['id'];
        });
        print('Order ID generated: $_orderId');
      } else {
        print('Failed to generate order ID');
      }
    } catch (error) {
      print('Error generating order ID: $error');
    }
  }

  // void _startPayment() {
  //   String enteredAmount = _amountController.text;
  //   double amount = double.parse(enteredAmount);
  //
  //   var options = {
  //     'key': 'rzp_live_LH9WuEt66nRZh9',
  //     'amount': amount * 100, // amount in paise (e.g., ₹100)
  //     'name': 'Demo Payment',
  //     'description': 'Test Payment',
  //     'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
  //     'external': {'wallets': ['paytm']}
  //   };
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  void _startPayment() {

    String enteredAmount = _amountController.text;
    double amount = double.parse(enteredAmount);

    var options = {
      'key': 'rzp_live_LH9WuEt66nRZh9',
      'capture': 1,
      'amount': amount * 100,
      'name': 'Hiremi',
      'description': '',
      'prefill': {'contact': Phone_Number, 'email': loginEmail},
      'order_id': _orderId,
      'external': {
        'wallets': ['paytm']
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
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
  // Future<void> _loadUserEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedUsername = prefs.getString('username');
  //
  //   if (savedUsername != null && savedUsername.isNotEmpty) {
  //     setState(() {
  //       loginEmail = savedUsername;
  //     });
  //   }
  // }
  // Update _loadUserEmail method to fetch phone number based on email
  Future<void> _loadUserEmailandPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
      try {
        final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/registers/?email=$loginEmail'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            // Iterate through the data to find the user with matching email
            for (final userData in data) {
              final email = userData['email'];
              if (email == loginEmail) {
                final phoneNumber = userData['phone_number']; // Change 'phone_number' to the actual field name
                // Use the retrieved phone number as needed
                print('Phone Number is: $phoneNumber');
                var Phone_Number=phoneNumber;
                break; // Exit the loop once the user is found
              }
            }
          } else {
            print('No user found with the email $loginEmail.');
          }
        } else {
          print('Failed to load user data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
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
          return Bottom();
            HomePage(sourceScreen: 'Screen2', uid: uid, username: '', verificationId: ID2,);
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
          return Bottom();
            HomePage(sourceScreen: '', uid: uid, username: '', verificationId: ID2,);
        }
        ),);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        //   return PaymentSuccesful();
        // }
        // ),);
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
          }
          else {
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
          return Bottom();
            HomePage(sourceScreen: 'Screen1', uid: uid, username: '', verificationId: ID2,);
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



  void  updatePaymentStatusInCorporateTraining() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}/api/corporatetraining/';

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
                  int corporatetrainingId = user['id']; // Replace with the actual registration ID

                  // Make a request to update payment status only if the transaction status is SUCCESS

                  _updatePaymentStatusforCorporateTraining(corporatetrainingId);

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
  void _updatePaymentStatusforCorporateTraining(int corporatetrainingId) async {
    // Replace the API URL with your actual API endpoint
    final apiUrl = '${ApiUrls.baseurl}/api/corporatetraining/$corporatetrainingId/';

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
          return Bottom();
            HomePage(sourceScreen: 'Screen1', uid: uid, username: '', verificationId: ID2,);
        }
        ),);
        print("Update payment status. Status code: ${response.statusCode}, Response: ${response.body}, mentorship ID:$corporatetrainingId");
        print("Payment status updated successfully for corporatetraining ID $corporatetrainingId");
      }


      else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, mentorship ID:$corporatetrainingId");
      }
    } catch (error) {
      print(error);
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [


                Padding(
                  padding: const EdgeInsets.only(left: 98.0),
                  child: Image.asset(
                    'images/Hiremi_Icon.png',
                    height: 186,
                    width: 186,
                  ),
                )
              ],
            ),
            // Text(
            //   '${_amountController.text}', // Access text from the controller
            //   style: TextStyle(fontSize: 48,fontWeight: FontWeight.bold,),
            // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              children: [
                Image.asset(
                  'images/paymentscreen.png',
                  height: 380, // Adjust the height to increase the size
                  width: 380,  // Adjust the width to increase the size
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed:(){
                    _startPayment();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PaymentScreen(paymentAmount: 1),
                    //   ),
                    // );

                  }

                  // paymentScreen._startPayment
                  // Navigate to payment screen with the discounted price
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentScreen(paymentAmount: 1),
                  //   ),
                  // );
                  ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF13640),
                    minimumSize: Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Proceed to Pay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),

                        // TextSpan(
                        //   text: " ${discountedPrice.toInt().toString()}",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w700,
                        //     fontSize: 20,
                        //   ),
                        // ),

                        // TextSpan(
                        //   text: "1000",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w700,
                        //     fontSize: 20,
                        //     decoration: TextDecoration.lineThrough,
                        //     decorationColor: Colors.black87,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

            // ElevatedButton(
            //   onPressed: _startPayment,
            //   child: Text('Make Payment'),
            // ),

          ],
        ),
      ),
    );
  }
}
