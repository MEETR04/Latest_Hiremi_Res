import 'package:flutter/material.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/CreateUrPass.dart';
import 'package:hiremi/ForgetUrPass.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  String loginEmail="";
  String FullName="";
  String Gender="";
  Future<void> saveIDToSharedPreferences(String ID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', ID);
  }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedUsername = prefs.getString('username');
  //
  //   if (savedUsername != null && savedUsername.isNotEmpty) {
  //     setState(() {
  //       loginEmail = savedUsername;
  //     });
  //
  //     // Replace the API URL with your actual API endpoint
  //     final apiUrl = 'http://15.206.79.74:8000/api/registers/';
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
  //             final name = user['full_name'];
  //             final gender=user['gender'];
  //
  //             if (email == loginEmail) {
  //               setState(() {
  //                 FullName = name;
  //                 Gender=gender;
  //               });
  //               print('Gender: $gender');
  //               print('Full Name: $name');
  //               print(data);
  //               // You can store or use the name as needed
  //               break; // Exit the loop once a match is found
  //             }
  //
  //           }
  //
  //           if (FullName.isEmpty) {
  //             print('Full Name not found for Email: $loginEmail');
  //           }
  //         } else {
  //           print('Email not found on the server.');
  //         }
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //   }
  // }
  Future<void> _loadUserData() async {
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
              final gender = user['gender'];

              if (email == loginEmail) {
                setState(() {
                  FullName = name;
                  Gender = gender;
                });

                print('Gender: $gender');
                print('Full Name: $name');
                print(data);
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


  Widget _buildAccountPicture() {
    if (Gender == 'Male') {
      // Return an image for male
      return Image.asset('images/TheFace.png');
    } else if (Gender == 'Female') {
      // Return an image for female
      return Image.asset('images/female.png');
    } else {
      // Return a default image for other genders or when gender is not specified
      //return Image.asset('images/default.png');
     return  Center(child: CircularProgressIndicator());
    }
  }

  // Widget _buildAccountPicture() {
  //   print('Gender: $Gender');
  //   return Image.asset('images/TheFace.png');
  // }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
    //_loadUsername();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text(FullName,style: TextStyle(
            fontFamily: 'FontMain',
            fontSize: 20,

          ),), accountEmail:Text(loginEmail,style: TextStyle(
            fontFamily: 'FontMain',
            fontSize: 15,
          ),),decoration:BoxDecoration(
            color:Color(0xFFBD232B)
          ),
            currentAccountPicture:Padding(
              padding: const EdgeInsets.all(1.0),
              child: _buildAccountPicture(),
            ),
          ),

          ListTile(
            leading: Icon(Icons.security),
            title: Text("Security",style: TextStyle(
              fontFamily: "FontMain"
            ),),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Forgoturpass(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log Out",style: TextStyle(
                fontFamily: "FontMain"
            ),),
            onTap: ()async{
              var sharedPref=await SharedPreferences.getInstance();
              sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
