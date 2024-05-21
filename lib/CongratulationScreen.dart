import 'dart:async';
import 'dart:convert';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/api_services/base_services.dart';

import 'package:hiremi/pageview_screen.dart';
import 'package:hiremi/widgets/bottomnav.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({super.key});

  @override
  State<CongratulationScreen> createState() => CongratulationScreenState();
}

class CongratulationScreenState extends State<CongratulationScreen> {
  static const String KEYLOGIN="login";
  String loginEmail="";
  String CandidateStatus="";
  late int index;
  @override
  void initState() {
    super.initState();
    // Add a delay of 10 seconds and then navigate to the SignIn page
    _loadStatus();
    whereToGo();

  }
  Future<void> _loadStatus() async {
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

              final candidateStatus=user['candidate_status'];

              if (email == loginEmail) {
                setState(() {

                  CandidateStatus=candidateStatus;
                });
                print(CandidateStatus);

                //   print(data);
                // You can store or use the name as needed
                break; // Exit the loop once a match is found
              }
            }

            if (CandidateStatus.isEmpty) {
              print('CandidateStatus not found for Email: $loginEmail');
            }
          } else {
            print('Email not found on the server.');
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
  Future<void> _loadUserEmail() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
      print(loginEmail);
    }
  }
  Future<void> deleteJobApplication() async {
    final String apiUrl = '${ApiUrls.baseurl}job-applications/';

    try {
      final http.Response response = await http.delete(
        Uri.parse('$apiUrl?user_email=$loginEmail'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Job application deleted successfully');
        print('${response.body}');
      } else {
        // Request failed, handle the error
        final error = response.body;
        print("$loginEmail in deletedjjjjjjjjjjjjjjj");
        print('Failed to delete job application. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error deleting job application: $error');
    }
  }


  Future<void> VerificationID() async {
    await _loadUserEmail();

    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}verification-details/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];
          final String userEmail = data['user_email'];

          print('userEmail: $userEmail');
          print('loginEmail: $loginEmail');
          print('CandidateStatus: $CandidateStatus');
          print(index);
          if (userEmail == loginEmail) {
            // Use the CandidateStatus obtained from _loadStatus
           if (CandidateStatus == "Select  ") {
              // Navigate to PaymentGateway
              print('Going to PaymentGateway');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PaymentGateway()),
              );
            }
           else if(CandidateStatus == "Reject")
             {
               deleteJobApplication();
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                   builder: (context) => Bottom()
                   //     HomePage(
                   //   sourceScreen: 'Screen5',
                   //   uid: '',
                   //   username: '',
                   //   verificationId: '',
                   // ),
                 ),
               );
             }
           else if(CandidateStatus == "EXPIRE"){
             print("Login mail is $loginEmail and $CandidateStatus");
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(
                 builder: (context) => Bottom()
                 //     HomePage(
                 //   sourceScreen: 'Screen6',
                 //   uid: '',
                 //   username: '',
                 //   verificationId: '',
                 // ),
               ),
             );
           }

           else {
              // Navigate to HomePage Screen2
              print('Going to HomePage Screen1');
              print("screen1------------------------------------------------------------------------------------------");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Bottom()
                  //     HomePage(
                  //   sourceScreen: '',
                  //   uid: '',
                  //   username: '',
                  //   verificationId: '',
                  // ),
                ),
              );
            }
            return; // Exit the function once a match is found
          }
        }

        // If no match is found after the loop, navigate to HomePage Screen1
        print('Going to HomePage Screen1');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bottom()
            //     HomePage(
            //   sourceScreen: 'Screen1',
            //   uid: '',
            //   username: '',
            //   verificationId: '',
            // ),
          ),
        );
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in VerificationIDd: $e');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/Hiremi_Icon.png'),
            // Image.asset('images/seceondCongratulations.png'),

          ],
        ),
      ),
    );
  }
  void whereToGo() async{
     var sharedPref= await SharedPreferences.getInstance();
     var isLoggedIn=sharedPref.getBool(KEYLOGIN);
     Timer(Duration(seconds: 2),() async
     {
       if(isLoggedIn!=null){
         if(isLoggedIn){
          await  VerificationID();
         }
         else{
           Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => PageViewScreen(),));
         }
       }
       else
         {
           Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => PageViewScreen(),));
         }

     },);
  }
}

