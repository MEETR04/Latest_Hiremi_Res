// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:hiremi/CreateUrPass.dart';
// import 'package:hiremi/Register.dart';
// import 'package:hiremi/OtpVerificationScreen.dart';
// import 'package:hiremi/api_services/base_services.dart';
// import 'package:hiremi/api_services/user_services.dart';
// import 'package:hiremi/signin.dart';
// import 'package:http/http.dart' as http;
// import 'package:email_auth/email_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class Forgotu extends StatefulWidget {
//   const Forgotu({super.key});
//
//   @override
//   State<Forgotu> createState() => _ForgotuState();
// }
//
// class _ForgotuState extends State<Forgotu> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //_loadUserEmailandPhoneNumber();
//     print("Hello");
//
//   }
//   UserService _userService = new UserService();
//   //String errorTextVal = '';
//   String loginEmail="";
//   final emailController = TextEditingController();
//   Future<void> storeCSRFToken(String csrfToken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('csrfToken', csrfToken);
//   }
//   Future<void> _loadUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedUsername = prefs.getString('username');
//     print(loginEmail);
//     if (savedUsername != null && savedUsername.isNotEmpty) {
//       setState(() {
//         loginEmail = savedUsername;
//       });
//     }
//   }
//   Future<List<String>> _fetchRegisteredEmails() async {
//     // Make a GET request to fetch registered emails
//     // Replace 'http://13.127.81.177:8000/api/registers/' with your actual API endpoint
//     final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/registers/'));
//
//     if (response.statusCode == 200) {
//       // Decode the response body
//       final List<dynamic> data = jsonDecode(response.body);
//
//       // Extract emails from the response data
//       final List<String> emails = data.map((e) => e['email'] as String).toList();
//       return emails;
//     } else {
//       // Handle error
//       throw Exception('Failed to fetch registered emails');
//     }
//   }
//   Future<void> _loadUserEmailandPhoneNumber() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedUsername = prefs.getString('username');
//
//     if (savedUsername != null && savedUsername.isNotEmpty) {
//       setState(() {
//         loginEmail = savedUsername;
//       });
//       print("Login mail in shared preferences$loginEmail");
//       try {
//         final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/registers/?email=$loginEmail'));
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//
//           if (data is List && data.isNotEmpty) {
//             // Iterate through the data to find the user with matching email
//             for (final userData in data) {
//               final email = userData['email'];
//               if (email == loginEmail) {
//                 final phoneNumber = userData['phone_number']; // Change 'phone_number' to the actual field name
//                 // Use the retrieved phone number as needed
//                 print('Phone Number is: $phoneNumber');
//                 var Phone_Number=phoneNumber;
//                 break; // Exit the loop once the user is found
//               }
//             }
//           } else {
//             print('No user found with the email $loginEmail.');
//           }
//         } else {
//           print('Failed to load user data. Status code: ${response.statusCode}');
//         }
//       } catch (error) {
//         print('Error fetching user data: $error');
//       }
//     }
//   }
//   // Future<void> postApi() async{
//   //   final url =Uri.parse('http://15.206.79.74:8000/forgot-password/');
//   //   try {
//   //     print("Hello");
//   //     final response = await http.post(
//   //       url,
//   //
//   //       body: {
//   //         "email": emailController.text,
//   //       },
//   //     );
//   //     if (response.statusCode == 200) {
//   //       String csrfToken = response.headers['set-cookie'] ?? '';
//   //       print("CSRF token is " + csrfToken);
//   //
//   //       await storeCSRFToken(csrfToken);
//   //       Navigator.push(context,MaterialPageRoute(builder: (context)
//   //       {
//   //         return VerUrEmail();
//   //       }
//   //       ),);
//   //       print('Data posted successfully');
//   //       print('${response
//   //           .statusCode}');
//   //     }
//   //     else {
//   //
//   //       // Handle errors
//   //       print('Failed to post data. Status code: ${response
//   //           .statusCode}');
//   //       print('Response body: ${response.body}');
//   //
//   //     }
//   //   }catch(error)
//   //   {
//   //     print('Error:$error');
//   //   }
//   // }
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child:Center(
//             child: Column(
//               children: [
//                 Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start
//                       ,
//                       children: [
//                         SizedBox(height: 20,),
//                         Text("")
//                       ],
//                     )
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)
//                           {
//                             return SignIn();
//                           }
//                           ),);
//                         },
//                         child: Image.asset('images/Back_Button.png')),
//                   ],
//                 ),
//                 Container(
//                     child: Column(
//                         children:[
//                           Image.asset('images/ForgetUrPass.png')
//                         ]
//                     )
//                 ),
//                 Container(
//                     child: Text("Forget Password",style: TextStyle(
//                       color:Color(0xFFBD232B),
//                       fontSize: 28,
//                       fontFamily: 'FontMain',
//                     ),)
//                 ),
//                 SizedBox(height: 8,),
//                 Container(
//                   child: Text("Please Enter Your Email Address To \n  "
//                       "     Received a Verification code",style: TextStyle(
//                       fontFamily: "FontMain"
//                   ),),
//                 ),
//                 Container(
//                     child:Padding(
//                       padding: const EdgeInsets.all(29.0),
//                       child: TextFormField(
//                         controller: emailController,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your Email Id';
//                           }
//                           return null; // Return null if the input is valid
//                         },
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                             labelText: "Email Address",
//                             labelStyle: TextStyle(color: Color(0xFFCACACA),
//                               fontSize:22,
//                             ),
//                             prefixIcon: Icon(Icons.person,
//                               color: Color(0xFFCACACA),
//                             )
//                         ),
//
//                       ),
//                     )
//                 ),
//                 SizedBox(height: 28,),
//                 // Container(child: TextButton(onPressed: (){
//                 //
//                 // }
//                 //     , child: Text("Try Another Way",style: TextStyle(
//                 //
//                 //         color:Color(0xFFBD232B),
//                 //         fontSize: 16
//                 //     ),))
//                 // ),
//                 SizedBox(height: 38,),
//                 Container(
//
//                   child: ElevatedButton(onPressed: ()async{
//                     //_loadUserEmailandPhoneNumber();
//
//                     if (_formKey.currentState?.validate() == true) {
//                       final registeredEmails = await _fetchRegisteredEmails();
//                       // await _loadUsername();
//                       print("All feilds are filled");
//                       print("Login Email is $loginEmail");
//                       if (registeredEmails.contains(emailController.text)) {
//                         print("Hello");
//                         Map<String, dynamic> body = {
//                           "email": emailController.text
//                               .toString()
//                         };
//                         final responce = await _userService.createPostApi(
//                             body, ApiUrls.forgetPaassword);
//                         if (responce.statusCode == 200) {
//                           String csrfToken = responce.headers['set-cookie'] ?? '';
//                           print("CSRF token is " + csrfToken);
//
//                           await storeCSRFToken(csrfToken);
//                           // ignore: use_build_context_synchronously
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const OtpVerificationScreen(),
//                             ),
//                           );
//                         }
//                       }
//                       else{
//                         print("${emailController.text} and $loginEmail");
//                         print("Does not match");
//                         print("${emailController.text} and $loginEmail");
//                         return showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               backgroundColor: Colors.white,
//                               surfaceTintColor: Colors.transparent,
//                               actions: [
//                                 Column(
//                                   children: [
//                                     SizedBox(height: 30,),
//                                     Center(child: Text("Please Enter Registered Email Id",
//                                       style: TextStyle(
//                                         fontFamily: "FontMain",
//                                         fontSize: 18,
//                                         color: Color(0xFFBD232B),
//                                       ),)),
//                                     SizedBox(height: 35,),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         // Pop the current route (the AlertDialog)
//                                         Navigator.of(context).pop();
//
//                                         // Navigate to the HomePage
//
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: const Color(0xFFF13640),
//                                         minimumSize: Size(250, 50),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(30),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "OK",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ),
//
//
//                                   ],
//                                 )
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     }
//                     else {
//                       // Form is not valid, show error message
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Please fix the errors in the form.'),
//                         ),
//                       );
//                     }
//
//                   }, child: Text("Send",style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                   ),),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:Color(0xFFBD232B),
//                         minimumSize: Size(200, 50),
//
//
//
//
//                       )),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
