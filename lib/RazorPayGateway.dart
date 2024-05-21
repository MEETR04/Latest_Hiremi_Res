  import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/widgets/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/signin.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

  import 'package:uuid/uuid.dart';
  class PaymentFailureResponse {
    late int code;
    late String message;
    late String details;

    PaymentFailureResponse({
      required this.code,
      required this.message,
      required this.details,
    });

    factory PaymentFailureResponse.fromMap(Map<dynamic, dynamic>? map) {
      if (map == null) {
        return PaymentFailureResponse(
          code: 0,
          message: '',
          details: '',
        );
      }

      dynamic details = map['details'];
      if (details is String) {
        // If 'details' is a String, you can handle it accordingly.
        // For example, you might want to convert it to a Map or handle the String data.
        details = {}; // You need to provide logic based on your requirements.
      }

      return PaymentFailureResponse(
        code: map['code'] is String ? int.tryParse(map['code']!) ?? 0 : map['code'] ?? 0,
        message: map['message'] ?? '',
        details: details ?? '',
      );
    }



  // Existing code...
  }

  //  class RazorPayPage extends StatefulWidget {
  //
  //    const RazorPayPage({Key? key}) : super(key: key);
  //
  //    @override
  //    State<RazorPayPage> createState() => _RazorPayPageState();
  // }
  class RazorPayPage extends StatefulWidget {
    final String? sourceScreen;

    const RazorPayPage({Key? key, this.sourceScreen}) : super(key: key);

    @override
    State<RazorPayPage> createState() => _RazorPayPageState();
  }



  class _RazorPayPageState extends State<RazorPayPage> {

    String loginEmail="";
    String ID2=" ";
    String email =" ";
    String rateUrCommunication="";
    String collegeId =" ";
    String yourSkills =" ";
    String status =" ";
    String scheduleDate =" ";
    String scheduleTime =" ";
    var uuid = Uuid();
    String uid = '';
    late  Razorpay _razorpay;
    TextEditingController amtController=TextEditingController();


    void openCheckout(amount) async
    {
     amount=amount*100;
     var options={
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

      try{
        _razorpay.open(options);
      }
      catch(e){
        debugPrint('Error: $e');
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
          "schedule_date":scheduleDate,
          "schedule_time":scheduleTime,
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
              //HomePage(sourceScreen: 'Screen2', uid: uid, username: '', verificationId: ID2,);
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
        final response = await http.get(Uri.parse('${ApiUrls.baseurl}verification-details/'));

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
        final apiUrl = '${ApiUrls.baseurl}api/registers/';

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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Bottom();
              //HomePage(sourceScreen: '', uid: uid, username: '', verificationId: ID2,);
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
        final apiUrl = '${ApiUrls.baseurl}api/mentorship/';

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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Bottom();
              //HomePage(sourceScreen: 'Screen1', uid: uid, username: '', verificationId: ID2,);
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
    void handlePaymentSuccess(PaymentSuccessResponse response){
      //razorPayApi(100,"Hello");
      Fluttertoast.showToast(msg: "payment Succesful"+ response.paymentId!,toastLength: Toast.LENGTH_SHORT);
      print("hellllllllllllllllllll000000000000000000000000000000000000000000  ${response.paymentId!}");
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
    void handlePaymentError(PaymentFailureResponse response) {
      print("Payment Error: ${response.code} - ${response.message} - ${response.details}");
      Fluttertoast.showToast(msg: "Payment failed: ${response.message}", toastLength: Toast.LENGTH_SHORT);
    }

    void handleExternalWallet(ExternalWalletResponse response){
      Fluttertoast.showToast(msg: "External Wallet"+ response.walletName!,toastLength: Toast.LENGTH_SHORT);
    }

    @override
    void dispose(){
      super.dispose();
          _razorpay.clear();
    }
    @override
    void initState() {
      // TODO: implement initState
      super.initState();


      _loadUserEmail();
      _razorpay=Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handleExternalWallet);

    }

    @override
    Widget build(BuildContext context) {
      return  Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 180,),
              Text("Wlecome to Razorpay",
                textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,

              ),),
              Padding(padding: EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                style: TextStyle(color:Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),

                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,

                  )
                ),
                controller: amtController,
                validator: (value){
                  if(value==null || value.isEmpty){
                 return 'Please Enter amount to be paid';
                  }
                  return null;
                },

              ),),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                if(amtController.text.toString().isNotEmpty){
                  setState(() {
                    int amount=int.parse(amtController.text.toString());
                    openCheckout(amount);

                  });
                }

              }, child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Make Payments"),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green
              ),
              ),
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
      );
    }
  }
