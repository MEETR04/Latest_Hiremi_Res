import 'dart:convert';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hiremi/signin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserEmail();
    //_loadUserDetail();
    GetAllDetails();
  }
  String loginEmail="";
  String FatherName="";
  String FullName="";
  String Father="";
  String Gender="";
  String College="";
  String Branch="";
  String imagePath=""; // Declare imagePath with 'late'
  String FN="";
  String GN="";
  String COL="";

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
        FatherName = fatherName;
        GN = gender;
        COL = college;
      });
      print("Full Nameeee: $FN, Father's Name: $FatherName, Gender: $GN, College: $COL");
    }

  }



  Future<void> _loadUserDetail() async {
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
              final name = user['full_name'];
              final fatherName=user['father_name'];
              final gender=user['gender'];
              final branch=user['branch_name'];
              final college=user['college_name'];
              if (email == loginEmail) {
                setState(() {
                  FullName = name;
                  Father=fatherName;
                  Gender=gender;
                  Branch=branch;
                  College=college;
                   imagePath = (GN == 'Male') ? 'images/TheFace.png' : 'images/female.png';
                });
                print("Gender is $Gender");
                print('Full Name: $name');

                //   print(data);
                // You can store or use the name as needed
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
        print('Error: $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(

                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 280.0),
                    child: InkWell(
                      onTap: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return HomePage(
                        //         sourceScreen: '',
                        //         uid: '',
                        //         username: '',
                        //         verificationId: '',
                        //       );
                        //     },
                        //   ),
                        // );

                        Navigator.pop(context);
                      },
                      child: Image.asset('images/Back_Button.png'),
                    ),
                  ),
                  SizedBox(height: 40,),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height * 0.10,
                  //   child: Center(
                  //     child: CircleAvatar(
                  //       radius: 46,
                  //       backgroundImage: AssetImage(imagePath.isNotEmpty ? imagePath : 'images/TheFace.png' ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: Center(
                      child: CircleAvatar(
                        radius: 46,
                        backgroundImage: (GN == 'Male')
                            ? AssetImage('images/TheFace.png')
                            : (GN == 'Female')
                            ? AssetImage('images/female.png')
                            : null, // Set to null when gender is neither male nor female
                        child: (GN != 'Male' && GN != 'Female')
                            ? Center(child: CircularProgressIndicator()) // Show CircularProgressIndicator when gender is neither male nor female
                            : null, // Set to null when gender is male or female
                      ),
                    ),
                  ),



                  Text(FN,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                  Text(loginEmail,style: TextStyle(
                    fontFamily: 'FontMain',
                  ),),
                  SizedBox(height: 35),

                  ExpansionTile(
                    title: Text(
                      'Personal Info',
                      style: TextStyle(
                        color: Color(0xFFBD232B),
                        fontSize: 25,
                        fontFamily: 'FontMain',
                      ),
                    ),
                    children: [
                      Column(
                     crossAxisAlignment: CrossAxisAlignment.start
                        ,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Father Name: ",
                                                       style: TextStyle(
                               color:  Colors.black,
                               fontSize: 20,
                               fontFamily: 'FontMain',
                                                       ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("$FatherName",
                             style: TextStyle(
                               color: Colors.grey,
                               fontSize: 20,
                               fontFamily: 'FontMain',
                             ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Gender: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'FontMain',
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("$GN",
                              style: TextStyle(
                                color:  Colors.grey,
                                fontSize: 20,
                                fontFamily: 'FontMain',
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Email:",
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'FontMain',
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("$loginEmail",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontFamily: 'FontMain',
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("College:",
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'FontMain',
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("$COL",
                              style: TextStyle(
                                color:  Colors.grey,
                                fontSize: 20,
                                fontFamily: 'FontMain',
                              ),),
                          ),

                        ],
                      ),
                    ],
                    // trailing: Icon(Icons.arrow_forward),
                  ),


                  SizedBox(height: 30),
                  ListTile(

                    title: Text('Security',style: TextStyle(color: Color(0xFFBD232B),fontSize: 25, fontFamily: 'FontMain',)),

                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle onTap
                    },
                  ),

                  SizedBox(height: 30),
                  ListTile(

                    title: Text('Privacy Policy',style: TextStyle(color:Color(0xFFBD232B),fontSize: 25, fontFamily: 'FontMain',),),

                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle onTap
                    },
                  ),

                  SizedBox(height: 30),
                  // InkWell(
                  //
                  //   onTap: ()async{
                  //     var sharedPref=await SharedPreferences.getInstance();
                  //     sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>  SignIn(),
                  //       ),
                  //     );
                  //   },
                  //   child: ListTile(
                  //
                  //     title: Text('Sign out',style: TextStyle(color: Color(0xFFBD232B),fontSize: 25, fontFamily: 'FontMain',),),
                  //
                  //     trailing: Icon(Icons.arrow_forward),
                  //
                  //   ),
                  // )
                  InkWell(
                    onTap: () async{
                      // Handle onTap
                      var sharedPref=await SharedPreferences.getInstance();
                      sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                            (Route<dynamic> route) => false, // This line removes all routes from the stack
                      );
                    },
                    child: ListTile(
                      title: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Color(0xFFBD232B),
                          fontSize: 25,
                          fontFamily: 'FontMain',
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
    );


  }
}
