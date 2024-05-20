import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/CorporateTraining.dart';
import 'package:hiremi/FresherJob.dart';
import 'package:hiremi/FresherJob.dart';
import 'package:hiremi/FreshersJob2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hiremi/Mentorship.dart';
import 'package:hiremi/Payment.dart';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/RazorPayGateway.dart';
  import 'package:hiremi/Settings.dart';
  import 'package:hiremi/SideNavbar.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/chatGptrz.dart';
import 'package:hiremi/internship.dart';
import 'package:hiremi/signin.dart';
  import 'package:hiremi/user_verification_screen.dart';
import 'package:hiremi/widgets/showDialog.dart';
  import 'package:http/http.dart';
  import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:http/http.dart' as http;

import 'chatGptrz2.dart';
  
  
  class HomePage extends StatefulWidget {
    final String sourceScreen;
    final String uid;
  
    final String username;
    const HomePage({Key? key, required this.sourceScreen, required this.uid,required this.username, required String verificationId }) : super(key: key);
  
    @override
    State<HomePage> createState() => _HomePageState();
  }
  
  
  
  
  
  class _HomePageState extends State<HomePage> {
    final PageController _pageController = PageController(initialPage: 0);
     Timer? _timer;

    //  int _currentPageIndex = 0;

    int _currentIndex=0;
    int count=0;
    bool enableGestureDetector = true;
    String discountPrice="";
    String DiscountedPrice="";
    late DateTime currentTime;
    late String  _date;
    late String  _time;
    late final DateTime futureTime;
    late final DateTime futureTimeforCorporatetraining;
    late final DateTime futureTimeforMentorship;
    late Duration timeDifference;


   final List<Color> _iconColors = [
      Colors.red,
      Color(0xFF9B9B9B),
      Color(0xFF9B9B9B)

    ];
  late String uid;
   String ID = "";
   String Intern_Profile="";
   String FN="";
   String FatherNameinHomePage="";
   String COL="";
   String GN="";
    int a=0;
     bool verify=false;
     String UIDforCorporateTraining="";
     String UIDforMentorship="";
     String NewID="";
     bool fresherJob=true;

    bool uidverify= false;
    bool Internship=false;
    bool Experienced=false;
    bool Mentorshiip=false;
    bool corporateTraining=false;

    @override
    void initState() {
      super.initState();
      startTimer();
      _loadUserJobProfile();
      GetAllDetails();
      //refresh();
      _date = '';
      _time = '';
      currentTime = DateTime.now();

      // Calculate initial time difference
      // _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      //   if (_currentPageIndex < 1) {
      //     _currentPageIndex++;
      //   } else {
      //     _currentPageIndex = 0;
      //   }
      //   // Animate to the next page
      //   _pageController.animateToPage(
      //     _currentPageIndex,
      //     duration: Duration(milliseconds: 500),
      //     curve: Curves.easeInOut,
      //   );
      // });

      // Start updating the UI every second
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          // Update the current time every second
          currentTime = DateTime.now();

          // Recalculate the time difference
         // timeDifference = futureTime.difference(currentTime);
        });
      });


      initialize();
    }

    @override
    void dispose() {

      super.dispose();
    }

    Future<void> initialize() async {
      await fetchDiscount();
      await VerificationID();
      await _loadUserFullName();
      await  _CheckStatusInMEntorship();
      await _CheckStatusIncorporatetraining();
      await Details_from_verification_details();
      // await _Interview_Details();
      print("HELLOChangedduhjwduewdhuowehdioh");
      //  await _loadUserJobProfile();
      uid = widget.uid;
      if (await ( Check_for_Verify())){

        if(verify) {

        //  await  ID_is_Verify();
          print("Hello");
        }
        else
        {
          await YouApplicationisUnderreview();
        }

      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.sourceScreen == 'Screen1') {
          _showDialog();
         // retrieveSubmitStatus2();
        }
        else if (widget.sourceScreen == 'Screen2') {
         // retrieveSubmitStatus2();
        } else if (widget.sourceScreen == 'Screen3') {
           _loadUserJobProfile();

        }
        else if(widget.sourceScreen=='Screen4')
        {
          _CheckStatusInVerify();
        }
        else if(widget.sourceScreen=='Screen5')
        {
          _RejectedDialog();
        }
        else if(widget.sourceScreen=="Screen6")
          {
      _showTimeFinishDialog();
            print("${widget.sourceScreen}");
            print("${widget.sourceScreen}"); print("${widget.sourceScreen}");
          }
        // else if(widget.sourceScreen=="Screen10")
        // {
        //   retrieveSubmitStatus3();
        // }
        else if(widget.sourceScreen=="Screen11")
        {
          retrieveSubmitStatus4();
        }
        else if(widget.sourceScreen=="Screen12")
          {
            print("");
          }





      });
    }
    Future<void> GetAllDetails() async {
      print("DJKCDHJBC");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? fullName = prefs.getString('FullName');
      String? fatherName = prefs.getString('FatherName');
      String? gender = prefs.getString('Gender');
      String? college = prefs.getString('College');

      if (fullName != null && fullName.isNotEmpty &&
          fatherName != null && fatherName.isNotEmpty &&
          gender != null && gender.isNotEmpty &&
          college != null && college.isNotEmpty) {
        setState(() {
          FN = fullName;
          FatherNameinHomePage = fatherName;
          GN = gender;
          COL = college;
        });
        print("Full Nameeee: $FN, Father's Name: $FatherName, Gender: $GN, College: $COL");
      }

    }

    Future<bool> _checkVerifyFuture = Future.value(false);


    //bool dialogShown = true;_
    //bool dialogShown2 = false;

    @override


    var Email;

    String loginEmail="";
    String UIDforVerify="";
    String JobProfile="";
    String JobProfile2="";
    String JProfile="";
    String UID="";
    String FullName="";
    String FatherName="";
    String College="";


    String IDforRegistartion="";
    String Gender="";
    String CandidateStatus="";
    String IDCorporatetraining="";
    String IDformentorship="";
    // String _formattedTimeLeft = '';


    @override
    Future<void>YouApplicationisUnderreview() async{
      await retrieveSubmitStatus2();

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
    Future<void>_loadUserInternProfile()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
          print("login email in Internprofileprofile is $loginEmail");
        });

        // Replace the API URL with your actual API endpoint
        final apiUrl = '${ApiUrls.baseurl}/Internship-applications/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {
                final email = user['email'];
                print("email is ssssssssssssssssssssssssss$email");
                final Internship_profile=user['Internship_profile'];

                if (email == loginEmail) {
                  print("We are in the job profile");
                  setState(() {

                    Intern_Profile=Internship_profile;
                  });

                  print("Intern_Profile isssssssssssssssssssssssssssssssssssssss $Intern_Profile");


                  // Exit the loop once a match is found
                }
              }


            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error in Internprofileeeeeeeeeeeeeeeeeeeeeeeeee: $e');
        }
      }
    }
    void startTimer() {
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        if (_pageController.page == 1) {
          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        } else {
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      });
    }
    Future <void> _loadUserJobProfile()async{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
          print("login email in jobprofile is $loginEmail");
        });

        // Replace the API URL with your actual API endpoint
        final apiUrl = '${ApiUrls.baseurl}/job-applications/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {
                final email = user['email'];
                print("email is ssssssssssssssssssssssssss$email");
                final jobProfile=user['job_profile'];

                if (email == loginEmail) {
                  print("We are in the job profile");
                  setState(() {

                    JProfile=jobProfile;
                  });

                  print("Job profile isssssssssssssssssssssssssssssssssssssss $JProfile");


                 // Exit the loop once a match is found
                }
              }


            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error in jobprofileeeeeeeeeeeeeeeeeeeeeeeeee: $e');
        }
      }
    }
    double _parseDiscountedPrice() {
      try {
        return double.parse(DiscountedPrice ?? '0'); // Use '0' as default value if DiscountedPrice is null or empty
      } catch (e) {
        print('Error parsing DiscountedPrice: $e');
        return 0; // Return 0 or any other default value
      }
    }
    Future <void> _Interview_Details()async{
      print(_date);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });

        // Replace the API URL with your actual API endpoint
        final apiUrl = '${ApiUrls.baseurl}/job-applications/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {
                final email = user['email'];


                if (email == loginEmail) {


                  print("$loginEmail is eaqual to $email in job applicarion api");
                  await InterviewDialogBox();

                  // Exit the loop once a match is found
                }
              }


            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error in jobprofile: $e');
        }
      }
    }

    String formatTime(DateTime time) {
      // Format the time as hh:mm:ss
      return DateFormat('HH:mm:ss').format(time);
    }
    String formatDuration(Duration duration) {
      // Format the duration as hh:mm:ss
      int hours = duration.inHours;
      int minutes = duration.inMinutes.remainder(60);
      int seconds = duration.inSeconds.remainder(60);

      return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    }
    String _twoDigits(int n) {

      if (n >= 10) return '$n';
      return '0$n';
    }

    Future<void> _RejectedDialog() async {
      await _GetUidfromVerifyDetails();
      print("Bhai tum log reject ho gye");

      // ... (your dialog code)

      String errormessage = "Your Application is rejected $JobProfile ";
      showCustomDialog(errormessage);
      await _GetUidfromVerifyDetails();
    }

    Future<bool>  _showTimeFinishDialog() async {
      await _GetUidfromVerifyDetails();

      await updateStatusForEXPIRE();
      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              actions: [
                Column(
                  children: [
                    SizedBox(height: 30,),
                    Center(
                      child: Text(
                        "Your Applicationnnn is Expired please Mail to crtd@gmail.com for extra time",
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
                      onPressed: () async {
                        var sharedPref=await SharedPreferences.getInstance();
                        sharedPref.setBool(CongratulationScreenState.KEYLOGIN, true);
                        // Close all screens until the root screen
                        Future.delayed(Duration(seconds: 1), () {
                        //  Navigator.of(context).pop(true); // Close the dialog after 3 seconds
                        });
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
            ),
          );
        },
      );
      return result ?? false; // Return false if the dialog is dismissed without pressing 'OK'
    }
    Future<void>updateStatusForEXPIRE() async {
      final apiUrl = '${ApiUrls.baseurl}/api/registers/$IDforRegistartion';

      // Replace 'NewName' with the actual new name you want to set
      final ChangeStatus = 'EXPIRE';

      try {
        final response = await http.patch(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'candidate_status': ChangeStatus}),
        );

        if (response.statusCode == 200) {
          print('ChangeStatus updated successfully');
        } else {
          
          print("Failed to update ChangeStatus. Response body: ${response.body}");
          print('Failed to update ChangeStatus. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    Future<void> _EnrollDialogforRegistration() async {
      DateTime currentTime = DateTime.now();
      Duration timeDifference = futureTime.difference(currentTime);

      // Check if time left is less than or equal to zero
      if (timeDifference.inSeconds <= 0) {
        bool result = await _showTimeFinishDialog();
            // sourceScreen: 'Screen1',
        if (result) {
            // User pressed 'OK', take necessary actions
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RazorPayPage(),
          //   ),
          // );
          print(result);
        }
        return; // Return early to avoid showing the main dialog
      }

      // Start updating the UI every second
      // Timer.periodic(Duration(seconds: 1), (timer) {
      //   setState(() {
      //     currentTime = DateTime.now();
      //     timeDifference = futureTime.difference(currentTime);
      //
      //     // Check if time left is less than or equal to zero
      //     if (timeDifference.inSeconds <= 0) {
      //
      //       timer.cancel(); // Stop the timer when time is finished
      //       _showTimeFinishDialog().then((result) {
      //         if (result) {
      //
      //           // User pressed 'OK', take necessary actions
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => RazorPayPage(),
      //             ),
      //           );
      //         }
      //       }); // Show the dialog for time finish
      //     }
      //   });
      // });


      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.55), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
             WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  actions: [
                    Column(
                      children: [
                        Image.asset('images/tick.png'),
                        Text(
                          "Congratulations",
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 35,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TimeLeft: ${timeDifference.inHours}:${(timeDifference.inMinutes % 60).toString().padLeft(2, '0')}:${(timeDifference.inSeconds % 60).toString().padLeft(2, '0')}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize:22,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "You have applied for position $JProfile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'FontMain'
                          ),
                        ),
                        SizedBox(height: 35,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(sourceScreen:'_EnrollDialogforRegistration',paymentAmount: 1,),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF13640),
                            minimumSize: Size(250, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Enroll Now >",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

        },
      );


    }
    Future<void> _EnrollDialogForMentorship() async {
      fetchDiscount();
      print("discountPrice is $DiscountedPrice");
      print("_EnrollDialogForMentorshippppppppppppppppppppp");
      DateTime currentTime = DateTime.now();
      Duration timeDifference = futureTimeforMentorship.difference(currentTime);

      // Check if time left is less than or equal to zero
      if (timeDifference.inSeconds <= 0) {
        print("In if statement");
        bool result = await _showTimeFinishDialog();
        // sourceScreen: 'Screen1',
        if (result) {
          print("Result issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $result");

        }
        return; // Return early to avoid showing the main dialog
      }
      else {
        print("In else statement");
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                    // Adjust the opacity as needed
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                  ),
                ),
                WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    actions: [
                      Column(
                        children: [
                          Image.asset('images/tick.png'),
                          Text(
                            "Congratulations",
                            style: TextStyle(
                              fontFamily: 'FontMain',
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 35,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TimeLeft: ${timeDifference
                                    .inHours}:${(timeDifference.inMinutes % 60)
                                    .toString()
                                    .padLeft(2, '0')}:${(timeDifference
                                    .inSeconds % 60).toString().padLeft(
                                    2, '0')}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "You Have Succesfully applied for Mentorship Program",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'FontMain'
                            ),
                          ),
                          SizedBox(height: 35,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    sourceScreen: '_EnrollDialogForMentorship',
                                    paymentAmount:   DiscountedPrice.contains('.') ? double.parse(DiscountedPrice).round() : int.parse(DiscountedPrice),),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF13640),
                              minimumSize: Size(250, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Enroll Now >",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
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
    // Future<void> _EnrollDialogForMentorshipRejection() async {
    //
    //   print("In else statement");
    //   return showDialog<void>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //   return Stack(
    //   children: [
    //   BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //   child: Container(
    //   color: Colors.black.withOpacity(0.55),
    //   // Adjust the opacity as needed
    //   width: MediaQuery
    //       .of(context)
    //       .size
    //       .width,
    //   height: MediaQuery
    //       .of(context)
    //       .size
    //       .height,
    //   ),
    //   ),
    //   WillPopScope(
    //   onWillPop: () async {
    //   return false;
    //   },
    //   child: AlertDialog(
    //   backgroundColor: Colors.white,
    //   surfaceTintColor: Colors.transparent,
    //   actions: [
    //   Column(
    //   children: [
    //   // Image.asset('images/tick.png'),
    //   // Text(
    //   //   "Congratulations",
    //   //   style: TextStyle(
    //   //     fontFamily: 'FontMain',
    //   //     fontSize: 25,
    //   //   ),
    //   // ),
    //   // SizedBox(height: 35,),
    //   // Column(
    //   //   mainAxisAlignment: MainAxisAlignment.center,
    //   //   children: [
    //   //     Text(
    //   //       'TimeLeft: ${timeDifference
    //   //           .inHours}:${(timeDifference.inMinutes % 60)
    //   //           .toString()
    //   //           .padLeft(2, '0')}:${(timeDifference
    //   //           .inSeconds % 60).toString().padLeft(
    //   //           2, '0')}',
    //   //       textAlign: TextAlign.center,
    //   //       style: TextStyle(fontSize: 22,
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    //   // Text(
    //   //   "You Have Succesfully applied for Mentorship Program",
    //   //   textAlign: TextAlign.center,
    //   //   style: TextStyle(
    //   //       fontFamily: 'FontMain'
    //   //   ),
    //   // ),
    //   // SizedBox(height: 35,),
    //   Text(
    //   "You Have Rejected for Mentorship Program",
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //   fontFamily: 'FontMain'
    //   ),
    //   ),
    //   ElevatedButton(
    //   onPressed: () {
    //   Navigator.pop(context);
    //   },
    //   style: ElevatedButton.styleFrom(
    //   backgroundColor: const Color(0xFFF13640),
    //   minimumSize: Size(250, 50),
    //   shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(30),
    //   ),
    //   ),
    //   child: const Text(
    //   "Enroll Now >",
    //   style: TextStyle(
    //   color: Colors.white,
    //   fontWeight: FontWeight.w700,
    //   fontSize: 22,
    //   ),
    //   ),
    //   ),
    //   ],
    //   ),
    //   ],
    //   ),
    //   ),
    //   ],
    //   );
    //   },
    //   );
    //
    //
    // }
    Future<void> _EnrollDialogForMentorshipRejection() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                  ),
                ),
              ),
              // Your dialog
              AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                content: WillPopScope(
                  onWillPop: () async {
                    // Handle back button press here
                    // Returning true allows the dialog to be popped
                    // Returning false prevents the dialog from being popped
                    return true;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Thank you for your interest in the Mentorship program at Hiremi in Bhopal, Madhya Pradesh, India. Unfortunately, we will not be moving forward with your application, but we appreciate your time and interest in Hiremi.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Thank you for applying to Hiremi", // Your leading text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 20,
                            color: Color(0xFFBD232B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    Future<void> _EnrollDialogForCorporatetrainingRejection() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                  ),
                ),
              ),
              // Your dialog
              AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                content: WillPopScope(
                  onWillPop: () async {
                    // Handle back button press here
                    // Returning true allows the dialog to be popped
                    // Returning false prevents the dialog from being popped
                    return true;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Thank you for your interest in the Corporate training program at Hiremi in Bhopal, Madhya Pradesh, India. Unfortunately, we will not be moving forward with your application, but we appreciate your time and interest in Hiremi.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Thank you for applying to Hiremi", // Your leading text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 20,
                            color: Color(0xFFBD232B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    Future<void> _EnrollDialogForcorporatetraining() async {
      fetchDiscount();
      print("discountPrice is $DiscountedPrice");
      print("_EnrollDialogForcorporatetraining");
      DateTime currentTime = DateTime.now();
      Duration timeDifference = futureTime.difference(currentTime);

      // Check if time left is less than or equal to zero
      if (timeDifference.inSeconds <= 0) {
        bool result = await _showTimeFinishDialog();
        // sourceScreen: 'Screen1',
        if (result) {
          print("Result dfvdffdvsissssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $result");

          //User pressed 'OK', take necessary actions
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RazorPayPage(sourceScreen: '_EnrollDialogForMentorship'),
          //   ),
          // );
        }
        return; // Return early to avoid showing the main dialog
      }
      return showDialog<void>(

        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.55), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  actions: [
                    Column(
                      children: [
                        Image.asset('images/tick.png'),
                        Text(
                          "Congratulations",
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 35,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TimeLeft: ${timeDifference.inHours}:${(timeDifference.inMinutes % 60).toString().padLeft(2, '0')}:${(timeDifference.inSeconds % 60).toString().padLeft(2, '0')}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize:22,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "You Have Succesfully applied for Corporate Training Program",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'FontMain'
                          ),
                        ),
                        SizedBox(height: 35,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(sourceScreen: '_EnrollDialogForCorporateTraining',paymentAmount:  DiscountedPrice.contains('.') ? double.parse(DiscountedPrice).round() : int.parse(DiscountedPrice),),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF13640),
                            minimumSize: Size(250, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Enroll Now >",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

        },
      );


    }
    Future<void> _EnrollDialogforVerification() async {

      DateTime currentTime = DateTime.now();
      Duration timeDifference = futureTime.difference(currentTime);

      // Check if time left is less than or equal to zero
      if (timeDifference.inSeconds <= 0) {
        bool result = await _showTimeFinishDialog();
        // sourceScreen: 'Screen1',
        if (result) {
          // User pressed 'OK', take necessary actions
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RazorPayPage(sourceScreen: '_EnrollDialogForMentorship'),
          //   ),
          // );
        }
        return; // Return early to avoid showing the main dialog
      }
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.55), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  actions: [
                    Column(
                      children: [
                        Image.asset('images/tick.png'),
                        Text(
                          "Congratulations",
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 35,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TimeLeft: ${timeDifference.inHours}:${(timeDifference.inMinutes % 60).toString().padLeft(2, '0')}:${(timeDifference.inSeconds % 60).toString().padLeft(2, '0')}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize:22,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "You Have Succesfully applied for Mentorshipppp Program",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'FontMain'
                          ),
                        ),
                        SizedBox(height: 35,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(sourceScreen: '_EnrollDialogForMentorship',paymentAmount: 1,),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF13640),
                            minimumSize: Size(250, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Enroll Now >",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

        },
      );


    }
    // Future<void> _CheckStatusInMEntorship()async{
    //   print("ppppppsamnkn ndn");
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? savedUsername = prefs.getString('username');
    //
    //   if (savedUsername != null && savedUsername.isNotEmpty) {
    //     setState(() {
    //       loginEmail = savedUsername;
    //     });
    //
    //     // Replace the API URL with your actual API endpoint
    //     final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';
    //
    //     try {
    //       final response = await http.get(Uri.parse(apiUrl));
    //
    //       if (response.statusCode == 200) {
    //         final data = json.decode(response.body);
    //
    //         if (data is List && data.isNotEmpty) {
    //           for (final user in data) {
    //
    //             final email = user['email'];
    //             final candidateStatus = user['candidate_status'];
    //             final timeEndString = user['time_end'];
    //             final PaymentStatus=user['payment_status'];
    //
    //             if (email == loginEmail) {
    //               setState(() {
    //
    //                 CandidateStatus = candidateStatus;
    //                 futureTimeforMentorship = DateTime.parse(timeEndString);
    //                 print("dsdcswdcxdc $futureTimeforMentorship");
    //               });
    //               if(PaymentStatus=='Enrolled')
    //               {
    //                 print("Hello payment status is $PaymentStatus");
    //                 break;
    //               }
    //               else if (CandidateStatus == "Select") {
    //                 print("Select me hai");
    //                 print('End time isssssssssssssss $futureTimeforMentorship');
    //                 print("Yashhhhhhhhhhh");
    //                 await _EnrollDialogForMentorship();
    //
    //                 if (data is List && data.isNotEmpty) {
    //                   for (final user in data) {
    //                     final id=user['id'];
    //                     final email = user['email'];
    //
    //                     final candidateStatus = user['candidate_status'];
    //                     final timeEndString = user['time_end'];
    //
    //                     if (email == loginEmail) {
    //                       setState(() {
    //                         IDforRegistartion=id ?? '';
    //                         CandidateStatus = candidateStatus ?? ''; // Use an empty string if candidateStatus is null
    //                         futureTimeforMentorship = timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
    //                       });
    //
    //
    //                       if (CandidateStatus == "Select") {
    //                         print('End time is  mentorship$futureTimeforMentorship');
    //                         await _EnrollDialogForMentorship();
    //                         print("Yash");
    //                       }
    //                       else if(CandidateStatus == "Reject")
    //                       {
    //                         await _EnrollDialogForMentorshipRejection();
    //                       }
    //
    //                       break; // Exit the loop once a match is found
    //                     }
    //                   }
    //
    //                   if (FullName.isEmpty) {
    //                     print('Full Name not found for Email: $loginEmail');
    //                   }
    //                 }
    //
    //
    //                 else {
    //                   print('Email not found on the server.');
    //                 }
    //
    //               }
    //
    //               else if(CandidateStatus == "Reject")
    //               {
    //                 print("Reject me hai");
    //                 await _EnrollDialogForMentorshipRejection();
    //               }
    //
    //
    //
    //               print("Gender is $Gender");
    //
    //               print("Your ID is $verify");
    //
    //               break; // Exit the loop once a match is found
    //             }
    //           }
    //
    //
    //         } else {
    //           print('Email not found on the server.');
    //         }
    //       }
    //     } catch (e) {
    //       print('Error in Mentorship: $e');
    //     }
    //   }
    // }
    Future<void> _updateCandidateStatusforMentorship(String email, String newStatus ,String IDformentorship) async {
      final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';

      try {
        // Fetch all users from the API
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          // Find the user with the specified email in the data
          var userToUpdate;
          for (final user in data) {
            if (user['email'] == email) {
              userToUpdate = user;
              break;
            }
          }

          if (userToUpdate != null) {
            final String uid = userToUpdate['uid'];
            final updateApiUrl = '${ApiUrls.baseurl}/api/mentorship/$IDformentorship/';

            // Perform the update request
            final updateResponse = await http.put(
              Uri.parse(updateApiUrl),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'email': loginEmail,'candidate_status': newStatus}),
            );

            if (updateResponse.statusCode == 200) {
              print('Candidate status updated successfully to $newStatus');
            } else {
              print('Failed to update candidate status: ${updateResponse.body}');
            }
          } else {
            print('User with email $email not found in the API response');
          }
        } else {
          print('Failed to fetch users from API: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating candidate status: $e');
      }
    }
    // Future<void> _CheckStatusInMEntorship() async {
    //   print("ppppppsamnkn ndn");
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? savedUsername = prefs.getString('username');
    //
    //   if (savedUsername != null && savedUsername.isNotEmpty) {
    //     setState(() {
    //       loginEmail = savedUsername;
    //     });
    //
    //     final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';
    //
    //     try {
    //       final response = await http.get(Uri.parse(apiUrl));
    //
    //       if (response.statusCode == 200) {
    //         final data = json.decode(response.body);
    //
    //         if (data is List && data.isNotEmpty) {
    //           for (final user in data) {
    //             final email = user['email'];
    //             final candidateStatus = user['candidate_status'];
    //             final timeEndString = user['time_end'];
    //             final PaymentStatus = user['payment_status'];
    //             final uid=user['uid'];
    //             final id=user['id'];
    //
    //             if (email == loginEmail) {
    //               setState(() {
    //                 UIDforMentorship=uid;
    //                 CandidateStatus = candidateStatus ?? '';
    //                 IDformentorship = id;
    //                 futureTimeforMentorship = timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
    //               });
    //
    //               if (PaymentStatus == 'Enrolled') {
    //                 _showDialogMentorship();
    //                 print("Hello payment status is $PaymentStatus");
    //                 break;
    //               } else if (CandidateStatus == "Select") {
    //                 print("Select me hai");
    //                 print('End time isssssssssssssss $futureTimeforMentorship');
    //                 print("Yashhhhhhhhhhh");
    //                 await _EnrollDialogForMentorship();
    //                 // Additional logic here
    //               } else if (CandidateStatus == "Reject") {
    //                 print("Reject me hai");
    //                 await _updateCandidateStatus(loginEmail,'Rejectt',IDformentorship);
    //                 await _EnrollDialogForMentorshipRejection();
    //
    //               }
    //
    //
    //
    //               print("Gender is $Gender");
    //               print("Your ID is $verify");
    //               break;
    //             }
    //           }
    //         } else {
    //           print('Email not found on the server.');
    //         }
    //       }
    //     } catch (e) {
    //       print('Error in Mentorshippppp: $e');
    //     }
    //   }
    // }
    Future<void> _CheckStatusInMEntorship() async {
      print("ppppppsamnkn ndn");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });

        final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {
                final email = user['email'];
                final candidateStatus = user['candidate_status'];
                final timeEndString = user['time_end'];
                final PaymentStatus = user['payment_status'];
                final uid = user['uid'];
                final id = user['id'];

                if (email == loginEmail) {
                  setState(() {
                    UIDforMentorship = uid;
                    CandidateStatus = candidateStatus ?? '';
                    IDformentorship = id.toString();
                    futureTimeforMentorship =
                    timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
                  });

                  if (PaymentStatus == 'Enrolled') {
                    _showDialogMentorship();
                    print("Hello payment status is $PaymentStatus");
                    break;
                  } else if (CandidateStatus == "Select") {
                    print("Select me hai");
                    print('End time isssssssssssssss $futureTimeforMentorship');
                    print("Yashhhhhhhhhhh");
                    await _EnrollDialogForMentorship();
                    // Additional logic here
                  } else if (CandidateStatus == "Reject") {
                    print("Reject me hai");
                    await _updateCandidateStatusforMentorship(loginEmail, 'Rejectt', IDformentorship);
                    await _EnrollDialogForMentorshipRejection();
                  }

                  print("Gender is $Gender");
                  print("Your ID is $verify");
                  break;
                }
              }
            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error in Mentorshippp: $e');
        }
      }
    }

    Future<void> _updateCandidateStatusforCorporatetraining(String email, String newStatus ,String IDforcorporatetraining) async {
      final apiUrl = '${ApiUrls.baseurl}/api/mentorship/';

      try {
        // Fetch all users from the API
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          // Find the user with the specified email in the data
          var userToUpdate;
          for (final user in data) {
            if (user['email'] == email) {
              userToUpdate = user;
              break;
            }
          }

          if (userToUpdate != null) {
            final String uid = userToUpdate['uid'];
            final updateApiUrl = '${ApiUrls.baseurl}/api/corporatetraining/$IDforcorporatetraining/';

            // Perform the update request
            final updateResponse = await http.put(
              Uri.parse(updateApiUrl),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'email': loginEmail,'candidate_status': newStatus}),
            );

            if (updateResponse.statusCode == 200) {
              print('Candidate status updated successfully to $newStatus');
            } else {
              print('Failed to update candidate status: ${updateResponse.body}');
            }
          } else {
            print('User with email $email not found in the API response');
          }
        } else {
          print('Failed to fetch users from API: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating candidate status: $e');
      }
    }

    Future<void> _CheckStatusIncorporatetraining()async{
      print("I am in corporatetrainingdsjkncdsjkncdfnds");
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
                final candidateStatus = user['candidate_status'];
                final timeEndString = user['time_end'];
                final PaymentStatus=user['payment_status'];
                final UID=user['uid'];
                final id=user['id'];

                if (email == loginEmail) {
                  setState(() {
                    UIDforCorporateTraining=UID;
                    CandidateStatus = candidateStatus;
                    IDCorporatetraining=id.toString();
                    futureTimeforCorporatetraining =
                    timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
                  });
                  if(PaymentStatus=='Enrolled')
                  {
                   _showDialogBox();
                    print("Hello payment status is $PaymentStatus");

                    break;
                  }
                  else if (CandidateStatus == "Select") {
                    print("Hellodc ghjcdygcyucgedax");
                    print('End time is corporatr training$futureTime');
                    await _EnrollDialogForcorporatetraining();
                    if (data is List && data.isNotEmpty) {
                      for (final user in data) {
                        final id=user['id'];
                        final email = user['email'];

                        final candidateStatus = user['candidate_status'];
                        final timeEndString = user['time_end'];

                        if (email == loginEmail) {
                          setState(() {
                            IDforRegistartion=id ?? '';
                            CandidateStatus = candidateStatus ?? ''; // Use an empty string if candidateStatus is null
                            futureTimeforCorporatetraining = timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
                          });


                          if (CandidateStatus == "Select") {
                            print('End time is $futureTimeforCorporatetraining');
                            //await _EnrollDialogForMentorship();
                            await _EnrollDialogForcorporatetraining();
                          }


                          break; // Exit the loop once a match is found
                        }
                      }

                      if (FullName.isEmpty) {
                        print('Full Name not found for Email: $loginEmail');
                      }
                    }


                    else {
                      print('Email not found on the server.');
                    }

                  }
                  else if(CandidateStatus == "Reject"){
                    await _updateCandidateStatusforCorporatetraining(loginEmail, 'Rejectt', IDCorporatetraining);
                    await _EnrollDialogForCorporatetrainingRejection();

                  }

                  else
                  {
                    print("Candidate is reject or pending");
                  }



                  print("Gender is $Gender");

                  print("Your ID is $verify");

                  break; // Exit the loop once a match is found
                }
              }


            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error in corporatetraining: $e');
        }
      }
    }
    Future<void> _CheckStatusInVerify()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });

        // Replace the API URL with your actual API endpoint
        final apiUrl = '${ApiUrls.baseurl}/verification-details/';

        try {
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data is List && data.isNotEmpty) {
              for (final user in data) {

                final email = user['email'];
                final candidateStatus = user['candidate_status'];
                final timeEndString = user['time_end'];
                final PaymentStatus=user['payment_status'];

                if (email == loginEmail) {
                  setState(() {
                    CandidateStatus = candidateStatus;
                    futureTime = DateTime.parse(timeEndString);
                  });
                  if(PaymentStatus=='Enrolled')
                  {
                    print("Hello payment status is $PaymentStatus");
                    enableGestureDetector = false;
                    print("$enableGestureDetector");
                    break;
                  }
                  if (CandidateStatus == "Select") {
                    print('End time is $futureTime');
                    await _EnrollDialogforVerification();
                    if (data is List && data.isNotEmpty) {
                      for (final user in data) {
                        final id=user['id'];
                        final email = user['email'];

                        final candidateStatus = user['candidate_status'];
                        final timeEndString = user['time_end'];

                        if (email == loginEmail) {
                          setState(() {
                            IDforRegistartion=id ?? '';
                            CandidateStatus = candidateStatus ?? ''; // Use an empty string if candidateStatus is null
                            futureTime = timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
                          });


                          if (CandidateStatus == "Select") {
                            print('End time is $futureTime');
                            await _EnrollDialogforVerification();
                          }
                          break; // Exit the loop once a match is found
                        }
                      }

                      if (FullName.isEmpty) {
                        print('Full Name not found for Email: $loginEmail');
                      }
                    }


                    else {
                      print('Email not found on the server.');
                    }

                  }
                  else if ( Gender=="Male")
                  {
                    print('Gender is is is is si is is is is $Gender');


                  }
                  else
                  {
                    print("Candidate is reject or pending");
                  }



                  print("Gender is $Gender");

                  print("Your ID is $verify");

                  break; // Exit the loop once a match is found
                }
              }

              if (FullName.isEmpty) {
                print('Full Name not found for Email: $loginEmail');
              }
            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error inregister: $e');
        }
      }
    }
    Future<void> _loadUserFullName() async {
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
                final name = user['full_name'];
                final fathername=user['father_name'];
                final verifyData = user['verified'];
                final gender = user['gender'];
                final collegeName=user['college_name'];
                final candidateStatus = user['candidate_status'];
                final timeEndString = user['time_end'];
                final PaymentStatus=user['payment_status'];

                if (email == loginEmail) {
                  setState(() {

                   // FullName = name;
                    FullName = name;
                    College=collegeName;
                    FatherName=fathername;
                    verify = verifyData;
                    Gender = gender;
                    CandidateStatus = candidateStatus;
                    futureTime = DateTime.parse(timeEndString);
                  });
                  saveFullNameToSharedPreferences(FullName,FatherName,Gender,College,);
                if(PaymentStatus=='Enrolled')
                {
                 print("Hello payment status is $PaymentStatus");
                 break;
                }
                  if (CandidateStatus == "Select") {
                    print('End time is $futureTime');
                    await _EnrollDialogforRegistration();
                    if (data is List && data.isNotEmpty) {
                      for (final user in data) {
                        final id=user['id'];
                        final email = user['email'];
                        final name = user['full_name'];
                        final verifyData = user['verified'];
                        final gender = user['gender'];
                        final candidateStatus = user['candidate_status'];
                        final timeEndString = user['time_end'];

                        if (email == loginEmail) {
                          setState(() {
                            IDforRegistartion=id ?? '';
                            FullName = name ?? ''; // Use an empty string if name is null
                            print("FullName");
                            verify = verifyData ?? ''; // Use an empty string if verifyData is null
                            Gender = gender ?? ''; // Use an empty string if gender is null
                            CandidateStatus = candidateStatus ?? ''; // Use an empty string if candidateStatus is null
                            futureTime = timeEndString != null ? DateTime.parse(timeEndString) : DateTime.now();
                          });


                          if (CandidateStatus == "Select") {
                            print('End time is $futureTime');
                            await _EnrollDialogforRegistration();
                            print("Gender is $Gender");
                            print("Your ID is $verify");

                          }



                          break; // Exit the loop once a match is found
                        }
                      }

                      if (FullName.isEmpty) {
                        print('Full Name not found for Email: $loginEmail');
                      }
                    }


                    else {
                      print('Email not found on the server.');
                    }

                  }
                  else if ( Gender=="Male")
                  {
                    print('Gender is is is is si is is is is $Gender');


                  }
                  else
                    {
                      print("Candidate is reject or pending");
                    }



                  print("Gender is $Gender");
                  print('Full Name: $name');
                  print(FullName);
                  print("Your ID is $verify");

                  break; // Exit the loop once a match is found
                }
              }

              if (FullName.isEmpty) {
                print('Full Name not found for Email: $loginEmail');
              }
            } else {
              print('Email not found on the server.');
            }
          }
        } catch (e) {
          print('Error inregister: $e');
        }
      }
    }
    Future<void> saveFullNameToSharedPreferences(String FullName,String FatherName,String Gender,String College) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('FullName', FullName);
      prefs.setString('FatherName', FatherName);
      prefs.setString('Gender', Gender);
      prefs.setString('College', College);

  //    GetFullName();

    }
    Future<void> GetFullName() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedFullName = prefs.getString('FullName');

      if (savedFullName != null && savedFullName.isNotEmpty) {
        setState(() {
          FN = savedFullName;
        });
        print("FN is $FN");
      }
    }


    void showCustomDialog( String errorMessage) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.55), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // CustomDialogBox on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return false;
                },
                child: CustomDialogBox(
                  title: 'Error',
                  message: errorMessage,
                  onOkPressed: () {
                    // Add your custom logic here
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),

            ],
          );
        },
      );
    }

    Future<void> VerificationID() async {
      await _loadUserEmail();

      try {
        final response = await http.get(Uri.parse('${ApiUrls.baseurl}/api/registers/'));

        if (response.statusCode == 200) {
          final List<dynamic> dataList = json.decode(response.body);

          // Counter for verified records


          for (int index = 0; index < dataList.length; index++) {
            final Map<String, dynamic> data = dataList[index];

            final String userEmail = data['email'];
            final bool verified = data['verified'];

            if (userEmail == loginEmail && verified) {
            await postVerifiedEmail();
            await VerificationID2();
              // Increment the counter for the next verified record

            }
          }
        }
        else {
          print('Status code: ${response.statusCode}');
          throw Exception('Failed to load data');
        }
      } catch (e) {
        print('Error in fetchData: $e');
      }
    }

   // Declare NewID as String
    Future<void> postVerifiedEmail() async {
      final url = Uri.parse("${ApiUrls.baseurl}/verified-emails/");

      // Prepare the data to be sent in the request body
      Map<String, String> data = {"email": loginEmail};

      try {
        // Make the POST request
        final response = await http.post(
          url,
          body: data,
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Request successful
          print("POST request successful");
          print("Response: ${json.decode(response.body)}");


        } else {
          // Request failed

          print("Error: ${response.statusCode}, ${response.body}");
        }
      } catch (error) {
        // An error occurred
        print("Error: $error");
      }
    }
    Future<void> VerificationID2() async {
      try {
        final response = await http.get(
          Uri.parse('${ApiUrls.baseurl}/verified-emails/'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> dataList = json.decode(response.body);

          for (int index = 0; index < dataList.length; index++) {
            final Map<String, dynamic> data = dataList[index];

            final String userEmail = data['email'];
            final dynamic ID = data['id']; // Use dynamic type for ID

            if (userEmail == loginEmail) {
              setState(() {
                NewID = ID.toString(); // Convert ID to String
              });
              break; // Break the loop once the ID is found
            }
          }

          print("New ID is: $NewID");
        } else {
          print('Status code: ${response.statusCode}');
          throw Exception('Failed to load data');
        }
      } catch (e) {
        print('Error in VerificationID2: $e');
      }
    }
    Future<void> fetchDiscount() async {
      final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/discount/'));

      if (response.statusCode == 200) {
        // Parse the response JSON
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final Map<String, dynamic> discountData = data.last; // Access the last element in the list
          final int discount = discountData['discount'];
          final int originalPrice = discountData['original_price'];

          // Calculate discounted price
          final double discountPrice = originalPrice - (originalPrice * discount / 100);

          setState(() {
            DiscountedPrice = discountPrice.toString(); // Convert ID to String
          });


        }

      }
    }

    Future<void>  _showDialog() async {
      fetchDiscount();
      print("discountPrice is $DiscountedPrice");
      int spaceIndex = FullName.indexOf(' ');
      String firstName = FullName.substring(0, spaceIndex);
      if (!(await Check_for_Verify())){


        showDialog<void>(
          context: context,
          barrierDismissible: false, // Set this to false to prevent closing on outside tap
          builder: (BuildContext context) {
            return Stack(
              children: [
                // Blurred background
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                // AlertDialog on top of the blurred background
                WillPopScope(
                  onWillPop: () async {
                    // Handle back button press here
                    // Returning true allows the dialog to be popped
                    // Returning false prevents the dialog from being popped
                    return false;
                  },
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,// Set the background color to transparent
                    actions: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset("images/Hiremi_Icon.png"),
                          Container(
                            width: 150, // Set your desired width here
                            height: 150, // Set your desired height here
                            child: Image.asset('images/Hiremi_Icon.png'),
                          ),

                          RichText(

                            text: TextSpan(
                              children: [

                                TextSpan(
                                  text: ' Hello $firstName',
                                  style: TextStyle(
                                    fontFamily: "FontMain",
                                    fontSize: 19,
                                    color: Colors.black, // Set FullName color to black
                                  ),
                                ),
                                TextSpan(
                                  text: ', Verify Your Account!',
                                  style: TextStyle(
                                    fontFamily: "FontMain",
                                    fontSize: 19,
                                    color: Color(0xFFBD232B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(height: 25),
                              Text(
                                "\u2022  Verified members can access job & internship opportunities at Hiremi",
                                textAlign: TextAlign.start,
                                style: TextStyle(

                                  fontSize: 16,

                                ),
                              ),
                              SizedBox(height: 25),
                              Text(
                                "\u2022  Verified users also get personalized career guidance",
                                textAlign: TextAlign.start,
                                style: TextStyle(

                                  fontSize: 16,

                                ),
                              ),
                              SizedBox(height: 35),
                              // Container(
                              //   width: 90, // Set your desired width here
                              //   height: 50, // Set your desired height here
                              //   decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.redAccent,
                              //       width: 3.0,
                              //     ),
                              //     // Red accent border
                              //
                              //     borderRadius: BorderRadius.circular(12.0),
                              //
                              //     // Rounded corners
                              //   ),
                              //   padding: EdgeInsets.all(12.0), // Padding inside the container
                              //   child: Center(
                              //     child: Text(
                              //       '₹${double.parse(DiscountedPrice).toInt()}', // Text content
                              //       style: TextStyle(
                              //         fontSize: 16.0, // Font size of the text
                              //         fontWeight: FontWeight.bold, // Bold text
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserVerificationScreen(username: widget.username),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF13640),
                                  minimumSize: Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "Get Verified",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Pay one-time verification fee ₹${_parseDiscountedPrice()}', // Text content
                                style: TextStyle(
                                  fontSize: 12.0, // Font size of the text
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );




      }
      else{
         if(verify) {

         await  ID_is_Verify();
         }
           else
             {
              // await retrieveSubmitStatus2();
               print("Hello");
             }

           }
    }


   Future<void> _showDialogBox()async{
     showDialog<void>(
       context: context,
       barrierDismissible: false, // Set this to false to prevent closing on outside tap
       builder: (BuildContext context) {
         return Stack(
           children: [
             // Blurred background
             BackdropFilter(
               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
               child: Container(
                 color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height,
               ),
             ),
             // AlertDialog on top of the blurred background
             WillPopScope(
               onWillPop: () async {
                 // Handle back button press here
                 // Returning true allows the dialog to be popped
                 // Returning false prevents the dialog from being popped
                 return false;
               },
               child: AlertDialog(
                 backgroundColor: Colors.white,
                 surfaceTintColor: Colors.transparent,// Set the background color to transparent
                 actions: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       // Image.asset("images/Hiremi_Icon.png"),
                       Container(
                         width: 150, // Set your desired width here
                         height: 150, // Set your desired height here
                         child: Image.asset('images/tick.png'),
                       ),
                       // Text(
                       //   "Hello ${FullName},Verify Your Account!",
                       //   textAlign: TextAlign.start,
                       //   style: TextStyle(
                       //     fontFamily: "FontMain",
                       //     fontSize: 19,
                       //     color: Color(0xFFBD232B),
                       //   ),
                       // ),


                       Column(
                         children: [
                           SizedBox(height: 25),
                           Text(
                             "Congratulations",
                             textAlign: TextAlign.start,
                             style: TextStyle(
                               color:Colors.black,
                               fontSize: 22,
                               fontFamily: 'FontMain',
                             ),
                           ),
                           SizedBox(height: 15),

                           Text("Your UID is:$UIDforCorporateTraining",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 fontFamily:'FontMain',
                                 color:Colors.redAccent,
                               fontSize: 20,
                             ),),
                           SizedBox(height: 15),
                           Text("You've successfully enrolled in the Corporate Training Program. ",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 fontFamily:'FontMain'
                           ),),
                           SizedBox(height: 14,),
                           Center(
                             child: Text(
                               "For any queries:support@hiremi.in",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontFamily: "FontMain",
                                 fontSize: 12,
                                 color: Colors.black,
                               ),
                             ),

                           ),
                           SizedBox(height: 14,),
                           GestureDetector(
                             onTap: () {
                               launch('https://api.whatsapp.com/send?phone=+919302707264');
                             },
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(
                                   "For chat support, click here",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                     fontFamily: "FontMain",
                                     fontSize: 12,
                                     color: Colors.black,
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 8.0), // Adjust spacing as needed
                                   child: Image.asset("images/whatsapp.png"),
                                 ),
                               ],
                             ),
                           ),

                         ],
                       ),

                     ],
                   ),
                 ],
               ),
             ),
           ],
         );
       },
     );

   }
    Future<void> _showDialogMentorship()async{
      showDialog<void>(
        context: context,
        barrierDismissible: false, // Set this to false to prevent closing on outside tap
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // AlertDialog on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,// Set the background color to transparent
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset("images/Hiremi_Icon.png"),
                        Container(
                          width: 150, // Set your desired width here
                          height: 150, // Set your desired height here
                          child: Image.asset('images/tick.png'),
                        ),
                        // Text(
                        //   "Hello ${FullName},Verify Your Account!",
                        //   textAlign: TextAlign.start,
                        //   style: TextStyle(
                        //     fontFamily: "FontMain",
                        //     fontSize: 19,
                        //     color: Color(0xFFBD232B),
                        //   ),
                        // ),


                        Column(
                          children: [
                            SizedBox(height: 25),
                            Text(
                              "Congratulations",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color:Colors.black,
                                fontSize: 22,
                                fontFamily: 'FontMain',
                              ),
                            ),
                            SizedBox(height: 15),

                            Text("Your UID is:$UIDforMentorship",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:'FontMain',
                                color:Colors.redAccent,
                                fontSize: 20,
                              ),),
                            SizedBox(height: 15),
                            Text("You've successfully enrolled in the Mentorship Program. ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:'FontMain'
                              ),),
                            SizedBox(height: 14,),
                            Center(
                              child: Text(
                                "Our Team will connect with you shortly to provide furthur details and guidance",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "FontMain",
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),

                            ),
                            SizedBox(height: 14,),

                            ElevatedButton(
                              onPressed: () {
                                // Pop the current route (the AlertDialog)
                                Navigator.of(context).pop();

                                // Add any additional logic here

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF13640),
                                minimumSize: Size(250, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Continue",
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
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );

    }

    Future<bool> Details_from_verification_details() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });
      }

      final apiUrl = '${ApiUrls.baseurl}/verification-details/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['user_email'];
              final date=user['schedule_date'];
              final time=user['schedule_time'];

              if (email == loginEmail) {
                print("Time is $time");
                // User is found in the verification details
                setState(() {
                  _date =  DateTime.parse(date).toString();
                  _time = DateTime.parse(time).toString();

                });
                print("$_date in verificatiion details");
                print("$_time in verification details");
                return true;

              }
            }

            // User not found in the verification details
            return false;
          } else {
            print('Email not found on the server.');
          }
        }
      } catch (e) {
        print('Error in Details_from_verification_details: $e');
      }

      // Handle other error cases
      return false;
    }
    Future<bool> Check_for_Verify() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          loginEmail = savedUsername;
        });
      }

      final apiUrl = '${ApiUrls.baseurl}/verification-details/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['user_email'];


              if (email == loginEmail) {
                // User is found in the verification details

                return true;

              }
            }

            // User not found in the verification details
            return false;
          } else {
            print('Email not found on the server.');
          }
        }
      } catch (e) {
        print('Error in verification details: $e');
      }

      // Handle other error cases
      return false;
    }
    Future<void> _GetUidfromVerifyDetails()async{
      uidverify=true;
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

                final email = user['user_email'];
                //  print('emails ismncdwh $email');

                if (email == loginEmail){

                   final uid=user['uid'];

                   setState(() {
                   //   print("uid is $uid");
                     UIDforVerify=uid;
                   });

                }
              }

              if (FullName.isEmpty) {
                print('Full Name not found for Email: $loginEmail');
              }
            } else {
              print('Email not found on the serxsxssver.');
            }
          }
        } catch (e) {
          print('Error in verification details: $e');
        }
      }
    }

    Future<void> retrieveSubmitStatus2() async {
      await _GetUidfromVerifyDetails();
    var sharedPref=await SharedPreferences.getInstance();
    sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // AlertDialog on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,// Set the background color to transparent
                  actions: [
                    Column(
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Your application is under review ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: 18,
                              color: Color(0xFFBD232B),
                            ),
                          ),

                        ),
                        Center(
                          child: Text(
                            "Our team will contact you\nshortly",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),

                        ),
                        SizedBox(height: 35),
                        Image.asset('images/hourglass.png'),
                        SizedBox(height: 35),
                        Center(
                          child: Text(
                            "For any queries:support@hiremi.in",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),

                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Center(
                        //       child: Text(
                        //         "For chat supprot,cllick here",
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(
                        //           fontFamily: "FontMain",
                        //           fontSize: 14,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //
                        //     ),
                        //     Image.asset("images/whatsapp.png")
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: () {
                            launch('https://api.whatsapp.com/send?phone=+918815165433');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "For chat support, click here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "FontMain",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0), // Adjust spacing as needed
                                child: Image.asset("images/whatsapp.png"),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 35),
                        Text("UID is $UIDforVerify", style: TextStyle(
                    fontFamily: "FontMain",
                    fontSize: 18,
                   color: Color(0xFFBD232B),
                     ),),
                        // Add any additional widgets or buttons here
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );



    }
    Future<void> retrieveSubmitStatus4() async {
   await _loadUserInternProfile();

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // AlertDialog on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return true;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,// Set the background color to transparent
                  actions: [
                    Column(
                      children: [
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: 15,
                                color: Colors.black, // Default color for other text
                              ),
                              children: [
                                TextSpan(
                                  text: "You have applied for ",
                                ),
                                TextSpan(
                                  text: Intern_Profile,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Make JobProfile text bold
                                    color: Color(0xFFBD232B), // Desired color for JobProfile text
                                  ),
                                ),
                                TextSpan(
                                  text: " internship position. We will update you after the interview.",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                  content: Text(
                    "Thank you for applying to hiremi", // Your leading text
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "FontMain",
                      fontSize: 20,
                      color: Color(0xFFBD232B),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );


    }
    Future<void> retrieveSubmitStatus3() async {
      await _loadUserJobProfile();

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // AlertDialog on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,// Set the background color to transparent
                  actions: [
                    Column(
                      children: [
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: 15,
                                color: Colors.black, // Default color for other text
                              ),
                              children: [
                                TextSpan(
                                  text: "You have applied for ",
                                ),
                                TextSpan(
                                  text: JobProfile,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Make JobProfile text bold
                                    color: Color(0xFFBD232B), // Desired color for JobProfile text
                                  ),
                                ),
                                TextSpan(
                                  text: " position. We will update you after the interview.",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                  content: Text(
                    "Thank you for applying to hiremi", // Your leading text
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "FontMain",
                      fontSize: 20,
                      color: Color(0xFFBD232B),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );


    }
    Future<void> ID_is_Verify() async {
      print("Id is verified");
      String errormessage="Your Id is verified";
      showCustomDialog(errormessage);
      await _GetUidfromVerifyDetails();


    }
    Future<void> InterviewDialogBox() async{
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // AlertDialog on top of the blurred background
              WillPopScope(
                onWillPop: () async {
                  // Handle back button press here
                  // Returning true allows the dialog to be popped
                  // Returning false prevents the dialog from being popped
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,// Set the background color to transparent
                  actions: [
                    Column(
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Interview Date:$_date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: 18,
                              color: Color(0xFFBD232B),
                            ),
                          ),

                        ),

                        SizedBox(height: 35),

                        Text("Interview Time:$_time", style: TextStyle(
                          fontFamily: "FontMain",
                          fontSize: 18,
                          color: Color(0xFFBD232B),
                        ),),
                        SizedBox(height: 35),
                        Text("Job Profile:", style: TextStyle(
                          fontFamily: "FontMain",
                          fontSize: 18,
                          color: Color(0xFFBD232B),
                        ),),
                        // Add any additional widgets or buttons here
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }



    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    Widget build(BuildContext context) {
      double screenWidth=MediaQuery.of(context).size.width;
      double screenHeight=MediaQuery.of(context).size.height;
      // print("Width is $screenWidth");
      // print("Height is $screenHeight");



      return Scaffold(
          key: _scaffoldKey,
       drawer: SideNavBar(),
          body: SafeArea(
          child: screenWidth<900?SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                children: [
            
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                      child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF13640), Color(0xFF8E3E42)],
                            stops: [0.1454, 1.0],
                          )
                      ),
                      width:screenWidth,
                      height:211,
            
            
                    ),
            
            
                  ),
            
                  Column(children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth*0.08,),
                        Container(
                          child: Container(
                            height: 150,
                            child: FractionalTranslation(
                              translation: Offset(0.19, 0),
                              child: Gender == 'Male'
                                  ? Image.asset(
                                'images/TheFace.png',
                                height: 150,
                                width: 91,
                              )
                                  : (Gender == 'Female'
                                  ? Image.asset(
                                'images/female.png',
                                height: 150,
                                width: 91,
                              )
                              //     : Image.asset(
                              //   'images/placeholder.png', // Use a placeholder image
                              //   height: 150,
                              //   width: 91,
                              // )),
                                  :Center(child: CircularProgressIndicator())),
                            ),
                          ),


                        ),
                        SizedBox(width: screenWidth*0.062,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hii!!",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),),
                            Row(
                              children: [
                                Visibility(
                                    visible: uidverify == true || verify==true,
                                    child: Text(FN, style: TextStyle(color: Colors.white, fontFamily: "FontMain", fontSize: 20))),
                                Visibility(
                                  visible: uidverify == true || verify==true,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Image.asset('images/verified.png')
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Visibility(
                              visible: uidverify == true || verify==true,
                              child: Builder(
                                builder: (BuildContext context) {
                                 _GetUidfromVerifyDetails();
                                  return Row(
                                   children: [
                                    Column(
                                     children: [
                                      Row(
                                       children: [
                                        Text('UID: ${UIDforVerify?.toString().padLeft(8, '0') ?? "00000000"}', style: TextStyle(fontSize: 20,
                                        fontFamily: 'FontMain',
                                        color: Colors.white
                                       )),
                                     ],
                                     ),
                                  // Text('UID: ${UID}', style: TextStyle(fontSize: 19)),
                                    ],
                                  ),

                                  SizedBox(width: 10),

                                  ],
                                  );
                                }
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],)
                ],
              ),
                SizedBox(height: 20,),
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.179,
                    width: screenWidth * 0.95,
                    child: CarouselSlider.builder(
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        if (index == 0) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  Mentorship(),
                                ),
                              );
                            },
                            child: Image.asset(
                              height:40,
                              "images/HomePage01.png",
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  CorporateTraining(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3.0,
                              child: Image.asset(
                                "images/HomePage2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                      options: CarouselOptions(
                        autoPlay: true, // Enable auto play
                        enlargeCenterPage: true, // Optionally increase the focused image size
                        aspectRatio: 16 / 9, // Aspect ratio for each image
                        viewportFraction: 0.8, // Fraction of viewport width occupied by each image
                        autoPlayInterval: Duration(seconds: 3), // Interval for automatic sliding
                        autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
                        autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.005,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!Internship) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InternScreen(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                        //  String errormessage="You are only allowed for Fresher Jobs";
            
                         // showCustomDialog(errormessage);
                        }
                      },
                      child: Image.asset('images/Internship2.png',
                        width: screenWidth*0.438, // Set your desired width
                        height: screenHeight*0.213,
                      ),
                    ),
            
                    InkWell(
                      onTap: () {
                        if (fresherJob) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FresherJobScreen(),
                            ),
                          );
                        } else {
                         // String errormessage = "Not allowed for freshers Jobs";
                         // showCustomDialog(errormessage);
                        }
                      },
                      child: Image.asset(
                        'images/Fresherjob2.png',
                        width: screenWidth*0.438, // Set your desired width
                        height: screenHeight*0.213,
                      ),
                    )
            
            
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (Experienced) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FresherJobScreen(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                         // String errormessage="You are only allowed for Fresher Jobs";
                          //showCustomDialog(errormessage);
                        }
                      },
                      child: Image.asset('images/lockex.png',
                        width: screenWidth*0.438, // Set your desired width
                        height: screenHeight*0.213,
                      ),
            
                    ),
                    InkWell(
                      onTap: () {
                        if (!Mentorshiip) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  Mentorship(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                         // String errormessage="You are only allowed for Fresher Jobs";
                         // showCustomDialog(errormessage);
                        }
                      },
                      child: Image.asset('images/Mentorship2.png',
                        width: screenWidth*0.438, // Set your desired width
                        height: screenHeight*0.213,
                      ),
                    )
            
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if (Experienced) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FresherJobScreen(),
                                ),
                              );
                            } else {
                              // Show dialog box indicating not eligible for Fresher Job
                              // String errorMessage = "You are only allowed for Fresher Jobs";
                              // showCustomDialog(errorMessage);
                            }
                          },
                          child: Image.asset(
                            'images/lockcou.png',
                            width: screenWidth*0.438, // Set your desired width
                            height: screenHeight*0.213,
                          ),
                        ),
            
                      ],
                    ),
            
                    InkWell(
                      onTap: () {
                        if (!corporateTraining) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  CorporateTraining(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                         // String errorMessage = "You are only allowed for Fresher Jobs";
                         // showCustomDialog(errorMessage);
                        }
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            'images/CorTra2.png',
                            width: screenWidth*0.438, // Set your desired width
                            height: screenHeight*0.213,
                          ),
            
            
                        ],
                      ),
            
            
                    )
            
            
            
                  ],
                ),
                SizedBox(height:screenHeight*0.008 ,),
                // AspectRatio(
                //   aspectRatio: 39/9,
                //   child: CurvedNavigationBar(
                //     backgroundColor: Colors.white10,
                //     color: Color(0xFFEDEDED),
                //     items:[
                //       Icon(Icons.home,size: 50,color: _iconColors[0] ),
                //       //Icon(Icons.mail,size: 50,color: _iconColors[1]),
                //       InkWell(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => const Settings(),
                //               ),
                //             );
                //             // Callback function to be executed when InkWell is tapped
                //             // Place your code here
                //           },
                //           child: Icon(Icons.manage_accounts,size: 50,color: _iconColors[1])),
                //
                //     ],
                //     onTap: (index){
                //       setState(() {
                //         _currentIndex=index;
                //         for (int i = 0; i < _iconColors.length; i++) {
                //           if (i == index) {
                //             _iconColors[i] =
                //                 Colors.red; // Change the color for the tapped icon
                //           } else {
                //             _iconColors[i] =
                //                 Color(0xFF43485E); // Reset the color for other icons
                //           }
                //         }
                //         if(_currentIndex==1){
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => const Settings(),
                //             ),
                //           );
                //         }
                //         if(_currentIndex==0){
                //           _iconColors[0] =
                //               Colors.red; // Change the color for the tapped icon
                //         }
                //       });
                //     },
                //   ),
                // ),
                Stack(
                  children: [
                    // Container(
                    //   height: 70,
                    //   width: double.infinity,
                    //   color: Colors.grey.shade300,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey.shade300),
                            child: Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.grey.shade100),
                                  child: const Center(
                                    child: Icon(Icons.home, size: 50, color: Colors.red),
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 30),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey.shade100),
                            child: Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.grey.shade300),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return const Settings();
                                              }));
                                        },
                                        icon: const Icon(Icons.settings,
                                            size: 45, color: Colors.grey)),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ):

























          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: screenWidth*0.08,),
                    GestureDetector(
                      onTap: () {
                        // Open the drawer
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset('images/ThreeLine.png')),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: screenWidth*0.28,),
                    Container(
                      child: Container(
                        height: 200, // Increase the height
                        child: FractionalTranslation(
                          translation: Offset(0.19, 0),
                          child: Gender == 'Male'
                              ? Image.asset(
                            'images/TheFace.png',
                            height: 200, // Increase the height
                            width: 121,   // Increase the width
                          )
                              : (Gender == 'Female'
                              ? Image.asset(
                            'images/female.png',
                            height: 200, // Increase the height
                            width: 121,   // Increase the width
                          )
                              : Center(child: CircularProgressIndicator())
                          ),
                        ),
                      ),



                    ),
                    SizedBox(width: screenWidth*0.032,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hii!!",style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),),
                        Row(
                          children: [
                            Text(FN, style: TextStyle(color: Colors.black, fontFamily: "FontMain", fontSize: 20)),
                            Visibility(
                              visible: verify == true,
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Image.asset('images/verified.png')
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   'ID: ${ID?.toString().padLeft(8, '0') ?? "00000000"}',
                        //   style: TextStyle(fontSize: 20),
                        // ),
                        Visibility(
                          visible: verify == true,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('UID: ${NewID?.toString().padLeft(8, '0') ?? "00000000"}', style: TextStyle(fontSize: 20,
                                          fontFamily: 'FontMain'
                                      )),
                                    ],
                                  ),
                                  // Text('UID: ${UID}', style: TextStyle(fontSize: 19)),
                                ],
                              ),

                              SizedBox(width: 10),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),

                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 35,
                        right: 15,
                        bottom: 10,
                      ),
                      child: Container(
                        height: 194,
                        width: 410,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          gradient: LinearGradient(
                            transform: GradientRotation(104),
                            colors: [
                              Color(0xFF331A4F),
                              Color(0xFF692C57),
                              Color(0xFF9E3D5C),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 5,
                      child: Image.asset(
                        'images/TheGirl.png',
                        height: 200,
                        width: 90,
                      ),
                    ),
                    Positioned(
                      left: 125,
                      top: 36,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(
                          Size(294, 70),
                        ),
                        child: Text(
                          'Launching assessments on the app!',

                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
             SizedBox(height: 10,),
                    Positioned(
                      left: 130,
                      top: 125,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(
                          Size(310, 104),
                        ),
                        child: Text(
                          'Show your verified skills to recruiters and get ahead in your job search journey',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize:18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.005,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (Internship) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FresherJobScreen(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                          //String errormessage="You are only allowed for Fresher Jobs";

//                          showCustomDialog(errormessage);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ],
                            ),
                          ),
                          width: 220,
                          height: 220,
                          child: Image.asset('images/Intern.png'),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        if (fresherJob) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FresherJobScreen(),
                            ),
                          );
                        } else {
                          String errormessage="Not allowed for freshers Jobs";

                          showCustomDialog(errormessage);

                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ],
                            ),
                          ),
                          width: 220,
                          height: 220,
                          child: Image.asset('images/FresJob.png'),
                        ),
                      ),
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Internship",style: TextStyle(
                        fontFamily: 'FontMain',
                        fontSize: 28
                    ),),
                    Text(" Fresher Job",style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: 28,
                    ),),


                  ],
                ),
                //  SizedBox(height: screenHeight*0.010,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (Experienced) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FresherJobScreen(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                          // String errormessage="You are only allowed for Fresher Jobs";
                          // showCustomDialog(errormessage);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ],
                            ),
                          ),
                          width: 220,
                          height: 220,
                          child: Image.asset('images/Ex.png'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!Mentorshiip) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Mentorship(),
                            ),
                          );
                        } else {
                          // Show dialog box indicating not eligible for Fresher Job
                          // String errormessage="You are only allowed for Fresher Jobs";
                          // showCustomDialog(errormessage);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ],
                            ),
                          ),
                          width: 220,
                          height: 220,
                          child: Image.asset('images/Mentor.png'),
                        ),
                      ),
                    )

                  ],
                ),

                //SizedBox(height:screenHeight*0.078 ,),
                AspectRatio(
                  aspectRatio: 39/9,
                  child: CurvedNavigationBar(
                    backgroundColor: Colors.white10,
                    color: Color(0xFFEDEDED),
                    items:[
                      Icon(Icons.home,size: 50,color: _iconColors[0] ),
                      Icon(Icons.mail,size: 50,color: _iconColors[1]),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Settings(),
                              ),
                            );
                            // Callback function to be executed when InkWell is tapped
                            // Place your code here
                          },
                          child: Icon(Icons.face_2_rounded,size: 50,color: _iconColors[2])),

                    ],
                    onTap: (index){
                      setState(() {
                        _currentIndex=index;
                        for (int i = 0; i < _iconColors.length; i++) {
                          if (i == index) {
                            _iconColors[i] =
                                Colors.red; // Change the color for the tapped icon

                          } else {
                            _iconColors[i] =
                                Color(0xFF43485E); // Reset the color for other icons
                          }
                        }
                      });
                    },
                  ),
                ),


              ],
            ),
          ),
        )
      );
    }
  }
