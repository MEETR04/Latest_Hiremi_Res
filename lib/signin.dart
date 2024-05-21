import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiremi/Accounts.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/ForgetUrPass.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/Register.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/widgets/bottomnav.dart';
import 'package:hiremi/widgets/neo_text.dart';
import 'package:hiremi/widgets/showDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:http/http.dart' as http;


class SignIn extends StatefulWidget {
  static const String routeName = 'signin';
  final isRegistrationSuccessful;

  const SignIn({Key? key, this.isRegistrationSuccessful = false}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  void initState() {
    super.initState();
    _loadUserFullName();
    // Check if registration was successful
    if (widget.isRegistrationSuccessful) {
      // Schedule the dialog to be shown after the build phase is complete
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _showSuccessDialog();

      });
    }
  }

  void _showSuccessDialog() {


    showDialog(
      context: context,
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
            AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,// Set the background color to transparent
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      " Congratulations ! Your account has been successfully created",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "FontMain",
                        fontSize: 18,
                        color: Color(0xFFBD232B),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
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
                      "LogIn",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
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


  var _username=TextEditingController();
  var password=TextEditingController();
  String userUid = '';
  String userEmail = '';
  String loginEmail="";
  String CandidateStatus="";
  bool isPasswordVisible=false;


  Future<void> fetchData() async {
    // Initialize variables
 print("Hellpppo");
    bool authenticationSuccessful = false;
    bool usernameIncorrect = false;
    bool passwordIncorrect = false;

    try {

      final response = await http.get(Uri.parse('${ApiUrls.baseurl}api/registers/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        print("Helloin ");
        print("Hellsds");
        if (dataList.isNotEmpty) {
          for (final data in dataList) {
            if (data is Map<String, dynamic>) {
              final serverUsername = data['email']?.toString() ?? '';
              final serverPassword = data['password']?.toString() ?? '';
              final candidateStatus=data['candidate_status'];
              if (_username.text == serverUsername && password.text == serverPassword)  {
                // Username and password match, navigate to the home page
                saveUsernameToSharedPreferences(_username.text);
                savePasswordToSharedPreferences(password.text);
                userEmail = _username.text;
                loginEmail=userEmail;
                print(serverUsername);
                print(serverPassword);
               CandidateStatus=candidateStatus;
              if(CandidateStatus == "Applied"){
                print(CandidateStatus);
                print("Hello");
                print("Login mail issssssssssssssssssssss $loginEmail and $CandidateStatus");
                var sharedPref=await SharedPreferences.getInstance();
                sharedPref.setBool(CongratulationScreenState.KEYLOGIN, true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Bottom();
                        //HomePage(
                      //   sourceScreen: 'Screen1',
                      //   uid: 'uid',
                      //   username: userEmail, verificationId: '',
                      // );
                    },
                  ),
                );

              }

                 else if(CandidateStatus == "Reject")
                 {
                   print("Login mail isssssssssssssssssssssss $loginEmail and $CandidateStatus");
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

                else if(CandidateStatus == "Select"){
                print("Login mail isssssssssssssssssssssss $loginEmail and $CandidateStatus");
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
              else if(CandidateStatus == "DirectSelect"){
                print("Login mail is $loginEmail and $CandidateStatus");
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
                authenticationSuccessful = true;
                break;
              }



              else if (_username.text == serverUsername) {
                // Username is correct, but password is incorrect
                passwordIncorrect = true;
                print(_username);
              }
              else if (password.text == serverPassword) {
                // Password is correct, but username is incorrect
                usernameIncorrect = true;
                print(password);
              }
              else
              {
               // print("CandidateStatus is $CandidateStatus");
                print("IN ELSE SECTION");

              }
            }

          }
        }
      }
      else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }

      if (!authenticationSuccessful) {
        String errorMessage;

        // Check if both username and password are incorrect
        if (!usernameIncorrect && !passwordIncorrect) {
          errorMessage = 'Both username and password are incorrect';
        } else if (passwordIncorrect) {
          errorMessage = 'Password is incorrect';
        } else if (usernameIncorrect) {
          errorMessage = 'Username is incorrect';
        } else {
          errorMessage = 'Username or password is incorrect';
        }


        showCustomDialog(errorMessage);
      }
    } catch (e) {
      print('Error in fetchData: $e');

      // Handle the error (show error message, etc.)
    }
  }

  void showCustomDialog( String errorMessage) {
    showDialog(
      context: context,
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
            // CustomDialogBox on top of the blurred background
            CustomDialogBox(
              title: 'Error',
              message: errorMessage,
              onOkPressed: () {
                // Add your custom logic here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadUserFullName() async {
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
               print("Hello Candidate status isssssssssssssssssssssssss  $CandidateStatus for $email in registration API");

                //   print(data);
                // You can store or use the name as needed
                //break; // Exit the loop once a match is found
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


  Future<void> saveUsernameToSharedPreferences(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<void> savePasswordToSharedPreferences(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    print(screenWidth);
   print(screenHeight);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: screenWidth<900 ?SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //Text('$screenWidth'),=411
                //Text('$screenHeight'),=811

                SizedBox(height: screenHeight*0.05),
               Image.asset('images/Hiremi_Icon.png'),
                Container(
                  child: Text("Let’s get started!",style: TextStyle(
                     fontSize:30,
                     fontFamily: 'FontMain',
                      fontWeight: FontWeight.w700,
                  ),),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter EmailId';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration:InputDecoration(
                            labelText: 'Email ID',
                            labelStyle: TextStyle(
                                color: Color(0xFFCACACA),
                                fontSize: 22
                            ),
                            prefixIcon: Icon(color: Color(0xFFCACACA),
                                Icons.person),

                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: password,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFCACACA),
                                    fontSize: 22,
                                  ),
                                  prefixIcon: Icon(
                                    color: Color(0xFFCACACA),
                                    Icons.lock,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFFCACACA),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: TextButton(onPressed: (){
                     // fetchData();
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                      {
                        return Forgoturpass();
                      }
                      ),);
                    }

                        , child: Text("Forgot Your Password ?",style: TextStyle(
                          color: Color(0xFFBD232B),
                          fontSize: 15,

                        ),))),
                SizedBox(
                  height: screenHeight*0.01,
                ),
                Container(

                    child: ElevatedButton(onPressed: () async {

                      // You can use the generated userId as needed (e.g., store it in the database)

                      if (_formKey.currentState?.validate() == true) {
                        await  fetchData();
                        print("All feilds are filled");
                      }
                      else {
                        // Form is not valid, show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fix the errors in the form.'),
                          ),
                        );
                      }
                     // await  fetchData();

                      // Navigator.push(context,MaterialPageRoute(builder: (context)
                      // {
                      //   return HomePage(sourceScreen: 'Screen1');
                      // }
                      // ),);
                }

                  , child: Text("Sign in",style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,

                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFFBD232B),
                    minimumSize: Size(200, 50),
                  ),

                )
                ),
                SizedBox(height: screenHeight*0.02,),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",),
                        TextButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)
                          {
                            return Register();
                          }
                          ),);
                        }, child: Text("Register Now",style:
                        TextStyle(color: Color(0xFF5C5C45),
                            fontFamily: 'FontMain',
                          fontSize: 15,
                        )
                          ,)),

                      ],
                    )//:
                    // Center(
                    //   child: Row(
                    //     children: [
                    //       SizedBox(width: screenWidth*0.33,),
                    //       Center(child: Text("Don't have an account?",textAlign: TextAlign.center,)),
                    //       TextButton(onPressed: (){
                    //         Navigator.push(context,MaterialPageRoute(builder: (context)
                    //         {
                    //           return Register();
                    //         }
                    //         ),);
                    //       }, child: Text("Register Now",
                    //         textAlign: TextAlign.center,
                    //         style:
                    //       TextStyle(color: Color(0xFF5C5C45),
                    //           fontFamily: 'FontMain'
                    //       ),
                    //         )),
                    //       SizedBox(
                    //         height: screenHeight*0.01,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),

              ],
            ),
          ),
        ):SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //Text('$screenWidth'),=411
                //Text('$screenHeight'),=811

                SizedBox(height: screenHeight*0.09),
                Image.asset('images/Hiremi_Icon.png'),
                SizedBox(height: screenHeight*0.02),
                Container(
                  child: Text("Let’s get started!",style: TextStyle(
                    fontSize:40,
                    fontFamily: 'FontMain',
                    fontWeight: FontWeight.w700,
                  ),),
                ),
                SizedBox(height: screenHeight*0.02),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(99.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter username';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration:InputDecoration(
                            labelText: 'User Name',
                            labelStyle: TextStyle(
                                color: Color(0xFFCACACA),
                                fontSize: 36
                            ),
                            prefixIcon: Icon(color: Color(0xFFCACACA),
                                Icons.person),

                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: password,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFCACACA),
                                    fontSize: 36,
                                  ),
                                  prefixIcon: Icon(
                                    color: Color(0xFFCACACA),
                                    Icons.lock,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFFCACACA),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                Container(
                    child: TextButton(onPressed: (){
                      // fetchData();
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                      {
                        return Forgoturpass();
                      }
                      ),);
                    }

                        , child: Text("Forgot Your Password ?",style: TextStyle(
                          color: Color(0xFFBD232B),
                          fontSize: 25,

                        ),))),
                SizedBox(
                  height: screenHeight*0.02,
                ),
                Container(

                    child: ElevatedButton(onPressed: () async {

                      // You can use the generated userId as needed (e.g., store it in the database)

                      if (_formKey.currentState?.validate() == true) {
                        await  fetchData();
                        print("All feilds are filled");
                      }
                      else {
                        // Form is not valid, show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fix the errors in the form.'),
                          ),
                        );
                      }
                      // await  fetchData();

                      // Navigator.push(context,MaterialPageRoute(builder: (context)
                      // {
                      //   return HomePage(sourceScreen: 'Screen1');
                      // }
                      // ),);
                    }

                      , child: Text("Sign in",style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,

                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFFBD232B),
                        minimumSize: Size(250, 50),
                      ),

                    )
                ),
                SizedBox(height: screenHeight*0.02,),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Center(
                    child: Container(
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth*0.2,),
                            Center(child: Text("Don't have an account?",textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                            )),
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)
                              {
                                return Register();
                              }
                              ),);
                            }, child: Text("Register Now",style:
                            TextStyle(color: Color(0xFF5C5C45),
                                fontFamily: 'FontMain',
                                fontSize: 28
                            )
                              ,)),

                          ],
                        )//:
                      // Center(
                      //   child: Row(
                      //     children: [
                      //       SizedBox(width: screenWidth*0.33,),
                      //       Center(child: Text("Don't have an account?",textAlign: TextAlign.center,)),
                      //       TextButton(onPressed: (){
                      //         Navigator.push(context,MaterialPageRoute(builder: (context)
                      //         {
                      //           return Register();
                      //         }
                      //         ),);
                      //       }, child: Text("Register Now",
                      //         textAlign: TextAlign.center,
                      //         style:
                      //       TextStyle(color: Color(0xFF5C5C45),
                      //           fontFamily: 'FontMain'
                      //       ),
                      //         )),
                      //       SizedBox(
                      //         height: screenHeight*0.01,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }
}
