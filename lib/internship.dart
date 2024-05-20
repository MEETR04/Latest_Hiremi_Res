import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/InternDescription.dart';
import 'package:hiremi/JobDescription.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/api_services/user_services.dart';
//import 'package:hiremi/jon_description_screen.dart';
import 'package:hiremi/models/fresher_job_model.dart';
import 'package:hiremi/models/intern_job_model.dart';
import 'package:hiremi/signin.dart';
import 'package:hiremi/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class InternScreen extends StatefulWidget {
  const InternScreen({super.key});

  @override
  State<InternScreen> createState() => _InternScreenState();
}

class _InternScreenState extends State<InternScreen> {

  List<InternshipJobModel> InternshipList=[];
  Map<int, bool> jobStatusMap = {};
  @override
  void initState() {
    super.initState();
   // OnlyApplyOneJob();
    fetchDataFromCacheOrApi();
    _loadUserEmail();
    //_checkAppliedJobs(); //
    //checkIfApplied();
    //_loadStatus2();
    //fetchAppliedJobs();
  }
  List<int> appliedJobIds = [];
  List<int> otherJobIds = [];
  String loginEmail="";
  bool AlreadyApplied = false;
  bool alreadyApplied = false;

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
      print("login mail is  $loginEmail");
    }
  }
  // Future<void> fetchDataFromApi() async {
  //   final response = await http.get(Uri.parse('${ApiUrls.baseurl}/api/internship/'));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> responseData = json.decode(response.body);
  //     setState(() {
  //       InternshipList = responseData
  //           .map((data) => InternshipJobModel.fromJson(data))
  //           .toList();
  //
  //     });
  //
  //     print("internship List Length: ${InternshipList.length}");
  //     print("Get response");
  //   } else {
  //     throw Exception('Failed to load data from the API');
  //   }
  // }
Future<void> fetchDataFromCacheOrApi() async {
  // Check if data exists in cache
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? cachedData = prefs.getString('internship_data');

  if (cachedData != null && cachedData.isNotEmpty) {
    // If data exists in cache, parse and use it
    final List<dynamic> cachedList = json.decode(cachedData);
    setState(() {
      InternshipList = cachedList
          .map((data) => InternshipJobModel.fromJson(data))
          .toList();
    });
    fetchDataFromApi();
  } else {
    // If data doesn't exist in cache, fetch from API
    fetchDataFromApi();
  }
}

Future<void> fetchDataFromApi() async {
  final response =
  await http.get(Uri.parse('${ApiUrls.baseurl}/api/internship/'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      InternshipList = responseData
          .map((data) => InternshipJobModel.fromJson(data))
          .toList();
    });

    // Cache the fetched data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('internship_data', json.encode(responseData));
  } else {
    throw Exception('Failed to load data from the API');
  }
}
  Future<void> OnlyApplyOneJob()async{
    print("OnlyApplyOneJob");
    try{
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}Internship-applications/'));


      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Counter for verified records


        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          final String userEmail = data['email'];


          if (userEmail == loginEmail) {
            await OnlyApplyOneJobDialogBox();
            print("I am in if section");
            break;
            // Increment the counter for the next verified record
          }
          else
          {
            print("Hello i am in else section");
            print(loginEmail);
          }
        }
      }
      else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    }
    catch(e){
      print("Error in OnlyApplyOneJob :$e");
    }
  }



  Future<bool> checkIfApplied(String userEmail, String InternshipProfile, String companyName) async {
    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}Internship-applications/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];
          final String appliedUserEmail = data['email'];
          final String appliedInternshipProfile = data['Internship_profile'];
          final String appliedCompanyName = data['company_name'];

          if (appliedUserEmail == userEmail && appliedInternshipProfile == InternshipProfile && appliedCompanyName == companyName) {
            return true;
          }
        }
        return false; // User hasn't applied for this job
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error in checkIfApplied: $e");
      return false;
    }
  }

  Future<bool> OnlyApplyOneJobDialogBox() async {
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
                      "Your can only apply one internship",
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
                    onPressed: () async{
                      // Handle onTap
                      // var sharedPref=await SharedPreferences.getInstance();
                      // sharedPref.setBool(CongratulationScreenState.KEYLOGIN, false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(sourceScreen: '', uid: '', username: '', verificationId: '')),
                            (Route<dynamic> route) => false, // This line removes all routes from the stack
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
                      "HomePage",
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


  // @override
  // Widget build(BuildContext context) {
  //   print('Applied Job IDs: $appliedJobIds');
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: SafeArea(
  //         child: RefreshIndicator(
  //           onRefresh: () async {
  //             await fetchDataFromApi();
  //           },
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) {
  //                         return HomePage(
  //                           sourceScreen: '',
  //                           uid: '',
  //                           username: '',
  //                           verificationId: '',
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 },
  //                 child: Image.asset('images/Back_Button.png'),
  //               ),
  //               Row(
  //                 children: [
  //                   SizedBox(
  //                     width: 15,
  //                   ),
  //                   Text(
  //                     "Internships",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontFamily: "FontMain",
  //                       fontSize: 25,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 25,
  //                   ),
  //                   Image.asset(
  //                     'images/Saly-1 (2).png',
  //                     width: 180,
  //                     height: 160,
  //                     fit: BoxFit.cover,
  //                   )
  //                 ],
  //               ),
  //               Center(
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       width: 380,
  //                       height: 620,
  //                       child: InternshipList != null && InternshipList.isNotEmpty
  //                           ? ListView.builder(
  //                         itemCount: InternshipList.length,
  //                         itemBuilder: (BuildContext context, int index) {
  //                           final internship = InternshipList[index];
  //                           return Column(
  //                             children: [
  //                               Card(
  //                                 color: const Color(0xFFF8F8F8),
  //                                 surfaceTintColor: Colors.transparent,
  //                                 elevation: 3.0,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(12.0),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     ListTile(
  //                                       title: Text(
  //                                         'Company: ${internship.companyName}',
  //                                         style: TextStyle(
  //                                           fontFamily: 'FontMain',
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     ListTile(
  //                                       title: Text(
  //                                         'Location: ${internship.InternshipLocation}',
  //                                         style: TextStyle(
  //                                           fontFamily: 'FontMain',
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     ListTile(
  //                                       title: Text(
  //                                         'CTC: ${internship.InternshipCtc} LPA',
  //                                         style: TextStyle(
  //                                           fontFamily: 'FontMain',
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(left:200.0),
  //                                       child: Container(
  //                                         width: 155,
  //                                         height: 40,
  //                                         child: ElevatedButton(
  //                                           style: ButtonStyle(
  //                                             backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFBD232B)),
  //                                             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //                                           ),
  //                                           onPressed: () async {
  //                                             print("Hello");
  //                                             bool applied = await checkIfApplied(loginEmail, internship.InternshipProfile!, internship.companyName!);
  //
  //                                             if (applied) {
  //                                               print("Applied");
  //                                               ScaffoldMessenger.of(context).showSnackBar(
  //                                                 SnackBar(
  //                                                   content: Text('You have already applied for this internship.'),
  //                                                 ),
  //                                               );
  //                                             } else {
  //                                               print("Not Applied");
  //                                               final int jobIndex = InternshipList.indexOf(internship);
  //                                               print("Selected Job Index: $jobIndex");
  //                                               Navigator.push(
  //                                                 context,
  //                                                 MaterialPageRoute(
  //                                                   builder: (context) => InternshipDescription(
  //                                                     jobIndex: jobIndex,
  //                                                     id: internship.id!,
  //                                                     InternshipProfile: internship.InternshipProfile!,
  //                                                     InternshipLocation: internship.InternshipLocation!,
  //                                                     InternshipCtc: internship.InternshipCtc!,
  //                                                     companyName: internship.companyName!,
  //                                                     education: internship.education!,
  //                                                     InternshipDescreption: internship.InternshipDescription!,
  //                                                     termsAndConditions: internship.termsAndConditions!,
  //                                                     skillRequired: internship.skillsRequired!,
  //                                                   ),
  //                                                 ),
  //                                               );
  //                                             }
  //                                           },
  //                                           child: Row(
  //                                             children: [
  //                                               Text(
  //                                                 'View details',
  //                                                 style: TextStyle(
  //                                                   fontWeight: FontWeight.w700,
  //                                                   fontSize: 13,
  //                                                 ),
  //                                               ),
  //                                               Icon(
  //                                                 Icons.arrow_forward_ios,
  //                                                 size: 20,
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     )
  //                                   ],
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 height: 73,
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       )
  //                           : Padding(
  //                         padding: const EdgeInsets.only(bottom: 75.0),
  //                         child: Center(
  //                           child: Text(
  //                             'No vacancies are available',
  //                             style: TextStyle(
  //                               fontFamily: 'FontMain',
  //                               fontSize: 18,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    print('Applied Job IDs: $appliedJobIds');
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await fetchDataFromApi();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
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
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "Internships",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "FontMain",
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Image.asset(
                      'images/Saly-1 (2).png',
                      width: 180,
                      height: 160,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth*0.97,
                        height: screenHeight * 0.65,
                        child: InternshipList == null || InternshipList.isEmpty
                            ? Center(
                          child: CircularProgressIndicator(), // Show CircularProgressIndicator when loading
                        )
                            : ListView.builder(
                          itemCount: InternshipList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final internship = InternshipList[index];
                            return Column(
                              children: [
                                Card(
                                  color: const Color(0xFFF8F8F8),
                                  surfaceTintColor: Colors.grey,
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          '${internship.InternshipProfile}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'FontMain',
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Company: ${internship.companyName}',
                                          style: TextStyle(
                                            fontFamily: 'FontMain',

                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Location: ${internship.InternshipLocation}',
                                          style: TextStyle(
                                            fontFamily: 'FontMain',
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'CTC: ${internship.InternshipCtc} LPA',
                                          style: TextStyle(
                                            fontFamily: 'FontMain',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:200.0,bottom: 10,right: 10),
                                        child: Container(
                                          width: 155,
                                          height: 40,
                                          child: InkWell(
                                            onTap: () async {
                                              print("Hello");
                                              bool applied = await checkIfApplied(loginEmail, internship.InternshipProfile!, internship.companyName!);

                                              if (applied) {
                                                print("Applied");
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('You have already applied for this internship.'),
                                                  ),
                                                );
                                              } else {
                                                print("Not Applied");
                                                final int jobIndex = InternshipList.indexOf(internship);
                                                print("Selected Job Index: $jobIndex");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => InternshipDescription(
                                                      jobIndex: jobIndex,
                                                      id: internship.id!,
                                                      InternshipProfile: internship.InternshipProfile!,
                                                      InternshipLocation: internship.InternshipLocation!,
                                                      InternshipCtc: internship.InternshipCtc!,
                                                      companyName: internship.companyName!,
                                                      education: internship.education!,
                                                      InternshipDescreption: internship.InternshipDescription!,
                                                      termsAndConditions: internship.termsAndConditions!,
                                                      skillRequired: internship.skillsRequired!,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xFFBD232B),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                              ),
                                              child: const Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    'View details',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight*0.98,
                      ),
                    ],
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hiremi/HomePage.dart';
// import 'package:hiremi/InternDescription.dart';
// import 'package:hiremi/api_services/base_services.dart';
// import 'package:hiremi/models/intern_job_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class InternScreen extends StatefulWidget {
//   const InternScreen({super.key});
//
//   @override
//   State<InternScreen> createState() => _InternScreenState();
// }
//
// class _InternScreenState extends State<InternScreen> {
//   List<InternshipJobModel> internshipList = [];
//   String loginEmail = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromCacheOrApi();
//   }
//
//   Future<bool> checkIfApplied(
//       String userEmail, String internshipProfile, String companyName) async {
//     try {
//       final response = await http
//           .get(Uri.parse('${ApiUrls.baseurl}Internship-applications/'));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> dataList = json.decode(response.body);
//
//         for (int index = 0; index < dataList.length; index++) {
//           final Map<String, dynamic> data = dataList[index];
//           final String appliedUserEmail = data['email'];
//           final String appliedInternshipProfile = data['Internship_profile'];
//           final String appliedCompanyName = data['company_name'];
//
//           if (appliedUserEmail == userEmail &&
//               appliedInternshipProfile == internshipProfile &&
//               appliedCompanyName == companyName) {
//             return true; // User has already applied for this internship
//           }
//         }
//         return false; // User hasn't applied for this internship
//       } else {
//         print('Status code: ${response.statusCode}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print("Error in checkIfApplied: $e");
//       return false;
//     }
//   }
//
//   // Future<void> _loadUserEmail() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? savedUsername = prefs.getString('username');
//   //   //String? cacheddata = prefs.getString(cachekey);
//   //
//   //   if (savedUsername != null && savedUsername.isNotEmpty) {
//   //     setState(() {
//   //       loginEmail = savedUsername;
//   //     });
//   //     print("login mail is  $loginEmail");
//   //   }
//   // }
//
//   Future<void> fetchDataFromCacheOrApi() async {
//     // Check if data exists in cache
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? cachedData = prefs.getString('internship_data');
//
//     if (cachedData != null && cachedData.isNotEmpty) {
//       // If data exists in cache, parse and use it
//       final List<dynamic> cachedList = json.decode(cachedData);
//       setState(() {
//         internshipList = cachedList
//             .map((data) => InternshipJobModel.fromJson(data))
//             .toList();
//       });
//     } else {
//       // If data doesn't exist in cache, fetch from API
//       fetchDataFromApi();
//     }
//   }
//
//   Future<void> fetchDataFromApi() async {
//     final response =
//     await http.get(Uri.parse('${ApiUrls.baseurl}/api/internship/'));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = json.decode(response.body);
//       setState(() {
//         internshipList = responseData
//             .map((data) => InternshipJobModel.fromJson(data))
//             .toList();
//       });
//
//       // Cache the fetched data
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('internship_data', json.encode(responseData));
//     } else {
//       throw Exception('Failed to load data from the API');
//     }
//   }
//
//   // Other methods...
//
//   @override
//   Widget build(BuildContext context) {
//     //print('Applied Job IDs: $AppliedJobIds');
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               await fetchDataFromApi();
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return const HomePage(
//                             sourceScreen: '',
//                             uid: '',
//                             username: '',
//                             verificationId: '',
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   child: Image.asset('images/Back_Button.png'),
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.only(top: 80),
//                       child: Text(
//                         "Internships",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: "FontMain",
//                           fontSize: 23,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 25,
//                     ),
//                     Image.asset(
//                       'images/Saly-1 (2).png',
//                       width: 180,
//                       height: 160,
//                       fit: BoxFit.cover,
//                     )
//                   ],
//                 ),
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 380,
//                         height: 620,
//                         child: internshipList != null &&
//                             internshipList.isNotEmpty
//                             ? ListView.builder(
//                           itemCount: internshipList.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final internship = internshipList[index];
//                             return Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Card(
//                                     color: const Color(0xFFF8F8F8),
//                                     elevation: 10,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                       BorderRadius.circular(12.0),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         ListTile(
//                                           title: Text(
//                                             'Company: ${internship.companyName}',
//                                             style: const TextStyle(
//                                               fontFamily: 'FontMain',
//                                             ),
//                                           ),
//                                         ),
//                                         ListTile(
//                                           title: Text(
//                                             'Location: ${internship.InternshipLocation}',
//                                             style: const TextStyle(
//                                               fontFamily: 'FontMain',
//                                             ),
//                                           ),
//                                         ),
//                                         ListTile(
//                                           title: Text(
//                                             'CTC: ${internship.InternshipCtc} LPA',
//                                             style: const TextStyle(
//                                               fontFamily: 'FontMain',
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 200.0,
//                                             right: 10,
//                                             bottom: 10,
//                                           ),
//                                           child: InkWell(
//                                             onTap: () async {
//                                               print("Hello");
//                                               bool applied =
//                                               await checkIfApplied(
//                                                   loginEmail,
//                                                   internship
//                                                       .InternshipProfile!,
//                                                   internship
//                                                       .companyName!);
//
//                                               if (applied) {
//                                                 print("Applied");
//                                                 ScaffoldMessenger.of(
//                                                     context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                     content: Text(
//                                                         'You have already applied for this internship.'),
//                                                   ),
//                                                 );
//                                               } else {
//                                                 print("Not Applied");
//                                                 final int jobIndex =
//                                                 internshipList
//                                                     .indexOf(
//                                                     internship);
//                                                 print(
//                                                     "Selected Job Index: $jobIndex");
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         InternshipDescription(
//                                                           jobIndex: jobIndex,
//                                                           id: internship.id!,
//                                                           InternshipProfile:
//                                                           internship
//                                                               .InternshipProfile!,
//                                                           InternshipLocation:
//                                                           internship
//                                                               .InternshipLocation!,
//                                                           InternshipCtc:
//                                                           internship
//                                                               .InternshipCtc!,
//                                                           companyName:
//                                                           internship
//                                                               .companyName!,
//                                                           education:
//                                                           internship
//                                                               .education!,
//                                                           InternshipDescreption:
//                                                           internship
//                                                               .InternshipDescription!,
//                                                           termsAndConditions:
//                                                           internship
//                                                               .termsAndConditions!,
//                                                           skillRequired:
//                                                           internship
//                                                               .skillsRequired!,
//                                                         ),
//                                                   ),
//                                                 );
//                                               }
//                                             },
//                                             child: Container(
//                                               width: 150,
//                                               height: 40,
//                                               decoration: BoxDecoration(
//                                                 color: const Color(
//                                                     0xFFBD232B),
//                                                 borderRadius:
//                                                 BorderRadius.circular(
//                                                     20),
//                                               ),
//                                               child: const Row(
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment
//                                                     .center,
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .center,
//                                                 children: [
//                                                   Text(
//                                                     'View details',
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                       FontWeight.w700,
//                                                       fontSize: 15,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 2,
//                                                   ),
//                                                   Icon(
//                                                     Icons
//                                                         .arrow_forward_ios,
//                                                     size: 15,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 73,
//                                 ),
//                               ],
//                             );
//                           },
//                         )
//                             : const Padding(
//                           padding: EdgeInsets.only(bottom: 75.0),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
