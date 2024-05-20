import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
import 'dart:ui';
import 'package:hiremi/api_services/base_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/signin.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}


class _PaymentGatewayState extends State<PaymentGateway>{
  String environment="PRODUCTION";
  String appId="df7123e0baa843adba802e3878b5c986";//Debug
  //String appId="0f844b54f3fa4a4ea32845cc3cfb20d4";//Release
  //String appId="4c6ba5bb3fef4a648c66f5c6d66fddb3";
  String merchantId="CRTDONLINE";
  bool enableLogging=true;
  String checksum="";
  String saltKey="655db522-30cd-4bcd-8826-c91e30f66c45";
  String saltIndex="1";
   //String callbackUrl="http://15.206.79.74:8000/callback/";
  //String callbackUrl="http://15.206.79.74:8000/payment_data";
 String callbackUrl="https://webhook.site/bf5553d5-2dfb-41ce-9dcd-784874afcb98";
  String body="";
  String apiEndPoint="/pg/v1/pay";
  Object? result;
  String Status="";
  String uniqueId = "";
  String loginEmail="";
  int amount=100;
  // get http => null;
  getcheckSum(){
    final requestData= {
      "merchantId": merchantId,
      "merchantTransactionId":uniqueId,
      "merchantUserId": "MUID123",
      "amount": amount,
      "mobileNumber": "9165363913",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE",},
    };
    String base64Body=base64.encode(utf8.encode(json.encode(requestData)));
  checksum='${sha256.convert(utf8.encode(base64Body+apiEndPoint+saltKey)).toString()}###$saltIndex';
  return base64Body;
  }
    void showStatusDialog(String status, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actions: [
            Column(
              children: [
                SizedBox(height: 30,),
                Center(
                  child: Text(
                    "Your Transaction is a $status and $error ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "FontMain",
                      fontSize: 18,
                      color: Color(0xFFBD232B),
                    ),
                  ),
                ),
                SizedBox(height: 35,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF13640),
                    minimumSize: Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
    void  updatePaymentStatusInMentorship() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}api/mentorship/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['email'];

              if (email == loginEmail) {
                print("We are in the updatePaymentStatus $Status");

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
    final apiUrl = '${ApiUrls.baseurl}api/mentorship/$mentorshipId/';

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
        print("Payment status updated successfully for mentorship ID $mentorshipId");
      } else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, mentorship ID:$mentorshipId");
      }
    } catch (error) {
      handleError(error);
    }
  }


    void updatePaymentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}api/registers/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['email'];

              if (email == loginEmail) {
                print("We are in the updatePaymentStatus $Status");

                setState(() {
                  // Assuming you have the registration ID stored somewhere
                  int registrationId = user['id']; // Replace with the actual registration ID

                  // Make a request to update payment status only if the transaction status is SUCCESS

                   // _updatePaymentStatus(registrationId);

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
    void _updatePaymentStatus(int registrationId) async {
    // Replace the API URL with your actual API endpoint
    final apiUrl = '${ApiUrls.baseurl}api/registers/$registrationId/';

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
        print("Payment status updated successfully for registration ID $registrationId");
      } else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, registration ID:$registrationId");
      }
    } catch (error) {
      handleError(error);
    }
  }


    void updatePaymentStatusInVerification()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });

        // Replace the API URL with your actual API endpoint
        final apiUrl = '${ApiUrls.baseurl}verification-details/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {
                final email = user['email'];

                if (email == loginEmail) {
                  print("We are in the updatePaymentStatus $Status");

                  setState(() {
                    // Assuming you have the registration ID stored somewhere
                    int verifyId = user['id']; // Replace with the actual registration ID

                    // Make a request to update payment status only if the transaction status is SUCCESS

                    _updatePaymentStatusInVerification(verifyId);

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
  void _updatePaymentStatusInVerification(int verifyId) async {
    // Replace the API URL with your actual API endpoint
    final apiUrl = '${ApiUrls.baseurl}api/registers/$verifyId/';

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
        print("Payment status updated successfully for registration ID $verifyId");
      } else {
        print("Failed to update payment status. Status code: ${response.statusCode}, Response: ${response.body}, registration ID:$verifyId");
      }
    } catch (error) {
      handleError(error);
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
  //     print(loginEmail);
  //   }
  // }
  String _generateRandomNumber(int length) {
    final rand = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += rand.nextInt(10).toString();
    }
    return result;
  }

  @override
  void initState() {
    
    super.initState();
    phonepeInit();
    uniqueId = _generateRandomNumber(10);
    //_loadUserEmail();
    // updatePaymentStatus();

    body=getcheckSum().toString();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return true to allow back navigation, false to disable it
        return true;
      },
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Phone pe Gateway"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                startPgTransaction();
              },
              child: Text("Start Transcation"),
            ),
            SizedBox(height: 20,),
            Text("Result\n $result"),
            ElevatedButton(onPressed: ()async{
              var sharedPref=await SharedPreferences.getInstance();
              sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              );
            }, child: Text("Sign out"))
          ],
        ),
      ),
    ),
    );
  }
  void getPackageSignatureForAndroid(){
    if (io.Platform.isAndroid) {
      PhonePePaymentSdk.getPackageSignatureForAndroid()
          .then((packageSignature){
        setState(() {
          String Result;
          Result = "package signature for android is -$packageSignature";
          print(" $Result");
        });
      })
          .catchError((error){
        handleError(error);
        // ignore: invalid_return_type_for_catch_error
        return <dynamic>{};
      });
    }
  }




  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) =>
    {
      setState(() {

        result ='PhonePay SDK Initialised-$val';
        print(checksum);
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
    getPackageSignatureForAndroid();
  }
  void startPgTransaction() async {
    try {
      var response = await PhonePePaymentSdk.startPGTransaction(
          body, callbackUrl, checksum, {}, apiEndPoint, "");

      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();

        if (status == 'SUCCESS') {
          setState(() {
            print("Transaction ID is $uniqueId");
            result = "Flow Complete - status: $status";
            Status = "Success";
            print("SUCCESS");
            //updatePaymentStatus();
            updatePaymentStatusInMentorship();
            updatePaymentStatusInVerification();
            print(checksum);
            showStatusDialog(status, error);
          });
        } else {
          setState(() {
            result = "Flow Incomplete - status: $status and error: $error";
            print("checksum is $checksum");
            print("Failureeeee");
            showStatusDialog(status, error);
          });
        }
      }
    } catch (error) {
      handleError(error);
    }
  }


  void handleError(error){
    setState(() {
      result={"error":error};
    });
  }
}