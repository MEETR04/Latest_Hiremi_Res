import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:hiremi/FresherJob.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/RZ.dart';
import 'package:hiremi/RazorPayGateway.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/api_services/user_services.dart';
import 'package:hiremi/chatGptrz.dart';
import 'package:hiremi/chatGptrz2.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';



class UserVerificationScreen extends StatefulWidget {
  final String username;

  // Add this line

  const UserVerificationScreen({Key? key,required this.username, }) : super(key: key);


  @override
  State<UserVerificationScreen> createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends State<UserVerificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  var uuid = Uuid();

  String uid = '';
  String ID2="";
  TimeOfDay? time = TimeOfDay.now();
  String? times="";
  String? minutes="";
  String? year="";
  int PaymentPrice=0;
  int discountedprice=0;

  void selectTimePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      final finalTime = timeOfDay.hour;
      final finalMinutes = timeOfDay.minute;
      // PaymentScreen paymentScreen = PaymentScreen(paymentAmount: 1,);
      setState(() {
        times = finalTime.toString().padLeft(2, '0'); // Format as two digits
        minutes = finalMinutes.toString().padLeft(2, '0'); // Format as two digits
        schedule_time.text = '$times:$minutes'; // Update schedule_time field only once
      });
    }
  }

  void selectDatePicker() async {
    DateTime currentDate = DateTime.now();

    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate, // Set the first selectable date to the current date
      lastDate: DateTime(2101), // You can adjust the last date as needed
    );

    if (datePicker != null && datePicker != currentDate) {
      setState(() {
        schedule_date.text = datePicker.toString().split(" ")[0];
      });
    }
  }


  String loginEmail="";
 // late int UserID;
  String errorTextVal = '';
  double? rateYourComm;
  final TextEditingController Email = TextEditingController();

  final TextEditingController CollegeID = TextEditingController();
  final TextEditingController YourSkills = TextEditingController();
 // final TextEditingController CommunicationSkills = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController schedule_date = TextEditingController();
  final TextEditingController schedule_time = TextEditingController();
  String generateRandomID() {
    Random random = Random();
    int randomID = random.nextInt(100000000); // Generate a random number from 0 to 99999999
    return randomID.toString().padLeft(8, '0');

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
        "user_email":Email.text,
        "college_id_number": CollegeID.text,
        "communication_skills": rateYourComm.toString(),
        "status":status.text,
        "skills":YourSkills.text,
        "schedule_date": 2024-02-28,
        "schedule_time":schedule_time.text,
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
    }
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(paymentAmount:discountedPrice.toInt() ),
                              ),
                            );
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
  Future<void>  saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', Email.text);
    prefs.setString('collegeId', CollegeID.text);
    prefs.setString('yourSkills', YourSkills.text);
    prefs.setString('communication_skills', rateYourComm.toString());
    prefs.setString('status', status.text);
    prefs.setString('scheduleDate', schedule_date.text);
    prefs.setString('scheduleTime', schedule_time.text);
    print(rateYourComm.toString());

    // Additional logic or feedback after saving data
    print('Data saved to SharedPreferences.');

  _showVerificationDialog();
   //  Navigator.push(
   //    context,
   //    MaterialPageRoute(
   //      builder: (context) => PaymentScreen(paymentAmount: 1,),
   //    ),
   //  );

  }

  Future<void>Apply_Discount() async{
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




  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;




    return Scaffold(
      body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
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
                const Positioned(
                  top: 130,
                  left: 85,
                  child: Text(
                    '  Verify Your Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 45),
                Column(
                  children: [


                  ],
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                'Enter Your Email ID',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextFormField(
                controller: Email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter EmailId';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  hintText: 'Enter Your Email ID',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'FontMain',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                'College ID / Enrollment No/UAN No',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextFormField(
                controller: CollegeID,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Necessary Domain';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  hintText: 'E.g.-0105IT*****',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'FontMain',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(
                'Interested Domain',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextFormField(
              //  controller: CollegeID,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Interested Domain';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  hintText: 'Ex-Software Developer',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'FontMain',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                SizedBox(width: 35),
                Column(
                  children: [
                    Text(
                      'Key Skills',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
//Interested
                  ],
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextFormField(
                controller: YourSkills,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your Skills';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                    hintText: 'Ex-Python',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'FontMain',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),

            Row(
              children: [
                SizedBox(width: 45),
                Column(
                  children: [
                    Text(
                      'Rate Your Communication',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),


                  ],
                ),

              ],
            ),

            SizedBox(height: 15,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(width: 30,),
                RatingBar.builder(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(), // Display numbers 1 to 5
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  onRatingUpdate: (rating) {
                    rateYourComm = rating;
                    print(rateYourComm);

                  },
                )


              ],
            ),



            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 45),
                Column(
                  children: [
                    Text(
                      'Describe Your Experience',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 7.5),
                    Center(
                      child: const Text(
                        "If you don't have any experience, type NA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Describe Yourself';
                  }
                  return null; // Return null if the input is valid
                },
                controller: status,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 234, 234),
                  hintText: 'Type here...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                ),
                maxLength: 300,
                minLines: 2,
                maxLines: 10,
              ),
            ),
            const SizedBox(width: 45),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('Please fix the errors in the form.'),
                      //     ),
                      //   );
                      // }
                      // if (rateYourComm == null && !_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text('Please rate your communication.'),
                      //   ));
                      // }
                      // else {
                      //   // Form is not valid, show error message
                      //   print("AALL is well");
                      //  await _loadUserEmail();
                      //   if (rateYourComm == null && !_formKey.currentState!.validate()) {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text('Please rate your communication.'),
                      //     ));
                      //   }
                      //  else if(Email.text==loginEmail){
                      //
                      //     await saveDataToSharedPreferences();
                      //
                      //   }
                      //   else
                      //     {
                      //       print("Email is incorrect $Email");
                      //       print("hello$loginEmail");
                      //
                      //       showDialog(
                      //         context: context, // The BuildContext from which the dialog should be shown
                      //         barrierDismissible: false,
                      //         builder: (BuildContext context) {
                      //           return WillPopScope(
                      //               onWillPop: () async {
                      //             // Handle back button press here
                      //             // Returning true allows the dialog to be popped
                      //             // Returning false prevents the dialog from being popped
                      //             return true;
                      //           },
                      //           child: AlertDialog(
                      //             backgroundColor: Colors.white,
                      //             surfaceTintColor: Colors.transparent,
                      //             actions: [
                      //               Column(
                      //                 children: [
                      //                   SizedBox(height: screenHeight*0.03,),
                      //                   Container(
                      //                     width: screenWidth * 0.8,
                      //                     child: Center(child: Text("Please Entered your registered Email.",
                      //                       textAlign: TextAlign.center,
                      //                       style: TextStyle(
                      //                       fontFamily: "FontMain",
                      //                       fontSize: 18,
                      //                       color: Color(0xFFBD232B),
                      //                     ),)),
                      //                   ),
                      //                   SizedBox(height: 35,),
                      //                   ElevatedButton(
                      //                     onPressed: () {
                      //                       // Pop the current route (the AlertDialog)
                      //                       Navigator.of(context).pop();
                      //
                      //                       // Navigate to the HomePage
                      //
                      //                     },
                      //                     style: ElevatedButton.styleFrom(
                      //                       backgroundColor: const Color(0xFFF13640),
                      //                       minimumSize: Size(250, 50),
                      //                       shape: RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.circular(30),
                      //                       ),
                      //                     ),
                      //                     child: const Text(
                      //                       "OK",
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontWeight: FontWeight.w700,
                      //                         fontSize: 20,
                      //                       ),
                      //                     ),
                      //                   ),
                      //
                      //
                      //                 ],
                      //               )
                      //             ],
                      //           ),
                      //           );
                      //         },
                      //       );
                      //
                      //     }
                      //
                      //  // await fetchData();
                      // }

                     await _loadUserEmail();

                      if(Email.text==loginEmail){
                        print(Email);
                        print(loginEmail);
                        if ((rateYourComm == null || rateYourComm == 0.0)  || _formKey.currentState!.validate()==false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please Enter  your feilds.'),
                          ));
                          print("!!!!!!!!!!!!!!!1await saveDataToSharedPreferences();");

                        }

                        else{
                          print("await saveDataToSharedPreferences();");
                          await saveDataToSharedPreferences();
                          print(rateYourComm);
                          print(_formKey.currentState!.validate());
                        }

                      }
                      else
                      {

                        print("Email is incorrecttttt $Email");
                        print("login email is $loginEmail");

                        showDialog(
                          context: context, // The BuildContext from which the dialog should be shown
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async {
                                // Handle back button press here
                                // Returning true allows the dialog to be popped
                                // Returning false prevents the dialog from being popped
                                return true;
                              },
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                actions: [
                                  Column(
                                    children: [
                                      SizedBox(height: screenHeight*0.03,),
                                      Container(
                                        width: screenWidth * 0.8,
                                        child: Center(child: Text("Please Entered your registered Email.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "FontMain",
                                            fontSize: 18,
                                            color: Color(0xFFBD232B),
                                          ),)),
                                      ),
                                      SizedBox(height: 35,),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Pop the current route (the AlertDialog)
                                          Navigator.of(context).pop();

                                          // Navigate to the HomePage

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
                                  )
                                ],
                              ),
                            );
                          },
                        );

                      }

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF13640),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
           SizedBox(height: 20,),


          ],
        ),
      ),
            ),
    );
  }
}

