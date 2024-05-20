
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiremi/CreateUrPass.dart';
import 'package:hiremi/ForgetUrPass.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/api_services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OtpVerificationScreen extends StatefulWidget {
  //const OtpVerificationScreen({super.key});
  final String email; // Add this line to accept email as a parameter
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final UserService _userService = UserService();
  final TextEditingController fieldOne = TextEditingController();
  final TextEditingController fieldTwo = TextEditingController();
  final TextEditingController fieldThree = TextEditingController();
  final TextEditingController fieldFour = TextEditingController();
  final TextEditingController fieldFive = TextEditingController();
  final TextEditingController fieldSix = TextEditingController();
  String loginEmail = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isProgressIndicator = false;

  @override
  void initState() {
    super.initState();
    loginEmail = widget.email; // Set loginEmail to the passed email
  }
  Future<void> storeCSRFToken(String csrfToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', csrfToken);
  }
  @override
  Widget build(BuildContext context) {
    //final forgetPasswordProvider = Provider.of<ForgetPasswordProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
             Padding(
               padding: const EdgeInsets.only(right:300.0),
               child: InkWell(
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => Forgoturpass()),
                     );
                   },
                   child: Image.asset('images/Back_Button.png')),
             ),
              Image.asset('images/ForgetUrPass.png'),
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints.tight(
                  const Size(337, 48),
                ),
                child: const Text(
                  textAlign: TextAlign.center,
                  'Please Enter The 6 Digit Code Sent To your email address',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: fieldOne,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6), // Limit to 6 digits
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter otp',
                    hintText: 'please enter the 6 Digit Code ',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              SizedBox(
                height: 55.0,
                width: 230,
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isProgressIndicator = true;
                      });

                      Map<String, dynamic> body = {
                        "email": loginEmail.toString()
                      };
                      final responce = await _userService.createPostApi(
                        body,
                        ApiUrls.forgetPaassword,
                      );

                      if (responce.statusCode == 200) {
                        String csrfToken = responce.headers['set-cookie'] ?? '';
                        print("CSRF token is " + csrfToken);
                        isProgressIndicator = false;
                        await storeCSRFToken(csrfToken);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const OtpVerificationScreen(),
                        //   ),
                        // );
                      }
                      else {
                        isProgressIndicator = false;
                       final error = responce.body;
                       print('hello${responce.body}');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('eraaaaaaaaror'),
                              content: Text(error.toString()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF13640),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:
                       const Text(
                    "Send OTP Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),

              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 55.0,
                width: 236,
                child: ElevatedButton(
                  onPressed: () async {
                    // String otp = fieldOne.text.toString().trim();
                    // print(otp);
                    // print(forgetPasswordProvider.emailController.controller.text
                    //     .toString());
                    // await _userService.getapi();
                    // var verifiedotp = _userService.otpValidation(
                    //     forgetPasswordProvider.emailController.controller.text
                    //         .toString());
                    // print(verifiedotp);
                    // if (otp.toString() == verifiedotp.toString()) {
                    //   print("otp verification successful");
                    //   // ignore: use_build_context_synchronously
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const CreateNewPasswordScreen(),
                    //     ),
                    //   );
                    // } else {
                    //   print("otp verification unsuccessful");
                    //   // ignore: use_build_context_synchronously
                    //   return showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         alignment: Alignment.center,
                    //         title: const Text('error'),
                    //         content: Text('please enter valid otp'),
                    //         actions: <Widget>[
                    //           TextButton(
                    //             onPressed: () {
                    //               Navigator.of(context).pop(); // Close the dialog
                    //             },
                    //             child: Text('OK'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    // }
          
                    // int otp = int.parse(
                    //   fieldOne.text.toString().trim() +
                    //       fieldTwo.text.toString().trim() +
                    //       fieldThree.text.toString().trim() +
                    //       fieldFour.text.toString().trim() +
                    //       fieldFive.text.toString().trim() +
                    //       fieldSix.text.toString().trim(),
                    // );
                    // print(otp);
                    String otp = fieldOne.text.toString().trim();
                    print(otp);
                    Map<String, dynamic> body = {
                      "otp": otp,
                    };
          
                    final responce = await _userService.createPostApi(
                        body, ApiUrls.otpValidation);
                    print(responce.statusCode);
                    print(responce.body);
                    if (responce.statusCode == 200) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateUrPass (),
                        ),
                      );
                    }
                    else {
                      var error = responce.body;
                      // ignore: use_build_context_synchronously
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            actions: [
                              Column(
                                children: [
                                  SizedBox(height: 30,),
                                  Center(child: Text("You have entered wrong OTP.",style: TextStyle(
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
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF13640),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
