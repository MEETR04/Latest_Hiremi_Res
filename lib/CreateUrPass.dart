import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/OtpVerificationScreen.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/api_services/user_services.dart';
import 'package:hiremi/signin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class CreateUrPass extends StatefulWidget {
  const CreateUrPass({super.key});

  @override
  State<CreateUrPass> createState() => _CreateUrPassState();
}

class _CreateUrPassState extends State<CreateUrPass> {
  TextEditingController pass1Controller = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;
  String previousPass = "";
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    _loadPassword();
  }
  Future<void> _loadPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedpassword = prefs.getString('password');
    print(previousPass);
    if (savedpassword != null && savedpassword.isNotEmpty) {
      setState(() {
        previousPass = savedpassword;
      });
    }
  }
  Future<bool>_checkPassword() async{
    if(previousPass==pass1Controller.text)
      {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {

            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              actions: [
                Column(
                  children: [
                    SizedBox(height: 30,),
                    Center(child: Text("Your New Password Must be Different from previously used password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontFamily: "FontMain",
                      fontSize: 18,
                      color: Color(0xFFBD232B),
                    ),)),
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
            );
          },
        );
        return false;
      }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 13,),
              Row(
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);

                      },
                      child: Image.asset('images/Back_Button.png')),
                ],
              ),
              Container(
                child: Image.asset('images/ForgetUrPass.png'),
              ),
              Container(
                  child:Text("Create New Password",style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'FontMain',
                  ),)
              ),
              SizedBox(height: 7,),
              Container(
                child: Text("Your New Password Must be Different",)
              ),
              Container(
                  child: Text("from previously used password",)
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pass1Controller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'New Password',
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pass2Controller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: !isPasswordVisible2,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
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
                                      isPasswordVisible2 = !isPasswordVisible2;
                                    });
                                  },
                                  icon: Icon(
                                    isPasswordVisible2
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

                  child: ElevatedButton(onPressed: () async {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)
                    // {
                    //   return HomePage();
                    // }
                    // ),);
                    bool isPasswordValid = await _checkPassword();
                         if(isPasswordValid) {
                           Map<String, dynamic> body = {
                             "pass1": pass1Controller.text.toString(),
                             "pass2": pass2Controller.text.toString()
                           };
                           var response = await _userService.createPostApi(
                               body, ApiUrls.passwordReset);
                           if (response.statusCode == 200) {
                             // ignore: use_build_context_synchronously
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => SignIn(),
                               ),
                             );
                           }
                           else {
                             String errorMessage = response.body;
                             // ignore: use_build_context_synchronously
                             return showDialog(
                               context: context,
                               builder: (context) {
                                 return AlertDialog(
                                   alignment: Alignment.center,
                                   title: const Text('error'),
                                   content: Text(errorMessage),
                                   actions: <Widget>[
                                     TextButton(
                                       onPressed: () {
                                         Navigator.of(context)
                                             .pop(); // Close the dialog
                                       },
                                       child: Text('OK'),
                                     ),
                                   ],
                                 );
                               },
                             );
                           }
                         }
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
            ],
          ),
        ),
      ),
    );
  }
}
