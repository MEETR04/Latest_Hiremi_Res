// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:hiremi/JobDescription.dart';
// import 'package:hiremi/api_services/user_services.dart';
// //import 'package:hiremi/jon_description_screen.dart';
// import 'package:hiremi/models/fresher_job_model.dart';
// import 'package:hiremi/utils/my_colors.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FresherJobScreen extends StatefulWidget {
//   const FresherJobScreen({super.key});
//
//   @override
//   State<FresherJobScreen> createState() => _FresherJobScreenState();
// }
//
// class _FresherJobScreenState extends State<FresherJobScreen> {
//   void updateJobStatus(int index, bool isApplied) {
//     setState(() {
//       jobStatusMap[index] = isApplied;
//     });
//   }
//   late List<FresherJobModel> fresherJobList=[];
//   Map<int, bool> jobStatusMap = {};
//   bool status = false;
//   @override
//   void initState() {
//     super.initState();
//     Status();
//     fetchDataFromApi();
//
//     //fetchAppliedJobs();
//   }
//   List<int> appliedJobIds = [];
//   String loginEmail="";
// //  bool Status = false;
//
//   dynamic ID2;
//
//   Future<void> fetchDataFromApi() async {
//     final response = await http.get(Uri.parse('http://15.206.79.74:8000/api/fresherjob/'));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = json.decode(response.body);
//       setState(() {
//         fresherJobList = responseData
//             .map((data) => FresherJobModel.fromJson(data))
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load data from the API');
//     }
//   }
//   Future<void> Status()async  {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedUsername = prefs.getString('username');
//
//     if (savedUsername != null && savedUsername.isNotEmpty) {
//       setState(() {
//         loginEmail = savedUsername;
//       });
//     }
//
//     final apiUrl = 'http://15.206.79.74:8000/verification-details/';
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data is List && data.isNotEmpty) {
//           for (final user in data) {
//             final email = user['user_email'];
//             final userStatus=user['accept'];
//             final id =user['id'];
//             if (email == loginEmail) {
//               // User is found in the verification details
//
//               setState(() {
//                 // Save the boolean value in SharedPreferences
//                 status = userStatus;
//                 prefs.setBool('status', status);
//               });
//               print(email);
//               print(id);
//             }
//             else
//               {
//                 print(email);
//               }
//           }
//
//           // User not found in the verification details
//
//         } else {
//           print('Email not found on the server.');
//         }
//       }
//       else
//         {
//           print("HEllo");
//         }
//     } catch (e) {
//       print('Error: $e');
//     }
//
//     // Handle other error cases
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (fresherJobList.isEmpty) {
//       // Return a loading indicator or an empty container until data is loaded
//       return Center(child: CircularProgressIndicator());
//     }
//     print('Applied Job IDs: $appliedJobIds');
//     return Scaffold(
//
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: RefreshIndicator(
//             onRefresh: ()async{
//               await fetchDataFromApi();
//
//
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.asset('images/Back_Button.png'),
//                 Row(
//                   children: [
//                     SizedBox(width: 15,),
//                     Text("Fresher's Jobs",style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: "FontMain",
//                       fontSize: 25,
//                     ),),
//                     Image.asset(
//                       'images/Saly-1 (2).png',
//                       width:180,
//                       height:160,
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
//
//                         child: fresherJobList != null
//                             ? ListView.builder(
//                           itemCount: fresherJobList.length,
//
//                           itemBuilder: (BuildContext context, int index) {
//                             final reversedIndex = fresherJobList.length - 1 - index;
//                             final job = fresherJobList[reversedIndex];
//
//                             return Column(
//
//                               children: [
//
//                                 Card(
//                                   color: const Color(0xFFF8F8F8),
//                                   surfaceTintColor: Colors.transparent,
//                                   elevation: 3.0, // Adjust the elevation as needed
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text('Company: ${job.companyName}',style: TextStyle(
//                                             fontFamily: 'FontMain'
//                                         ),),
//                                       ),
//                                       ListTile(
//                                         title: Text('Location: ${job.jobLocation}',style: TextStyle(
//                                             fontFamily: 'FontMain'
//                                         ),),
//                                       ),
//                                       ListTile(
//                                         title: Text('CTC: ${job.jobCtc} LPA',style: TextStyle(
//                                             fontFamily: 'FontMain'
//                                         ),),
//                                       ),
//
//                                       ListTile(
//                                         title: Text('JOBPRO: ${job.jobProfile} ',style: TextStyle(
//                                           fontFamily: 'FontMain',
//                                           fontSize: 20,
//                                         ),),
//                                       ),
//
//
//
//                                       ElevatedButton(
//                                         onPressed: () async {
//                                           // Check if the index is within the valid range
//                                           if (index >= 0 && index < fresherJobList.length) {
//                                             bool isApplied = jobStatusMap[index] ?? false;
//
//                                             print('Is Job Applied: $isApplied');
//
//                                             if (isApplied) {
//                                               // Job is applied, show a message or perform an action accordingly
//                                               print("Job is already applied");
//                                             } else {
//                                               // Job is not applied, call the updateJobStatus method
//                                               // and navigate to the job description screen if needed
//                                               updateJobStatus(index, true);
//
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => JobDescription(
//                                                     id: index,
//                                                     jobProfile: job.jobProfile!,
//                                                     jobLocation: job.jobLocation!,
//                                                     jobCtc: job.jobCtc!,
//                                                     companyName: job.companyName!,
//                                                     education: job.education!,
//                                                     jobDescreption: job.jobDescription!,
//                                                     termsAndConditions: job.termsAndConditions!,
//                                                     skillRequired: job.skillsRequired!,
//                                                   ),
//                                                 ),
//                                               );
//                                             }
//                                           } else {
//                                             print('Invalid Job Index');
//                                           }
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           primary: jobStatusMap[index] ?? false ? Colors.grey : Color(0xFFBD232B),
//                                           onPrimary: Colors.white,
//                                         ),
//                                         child: Text(
//                                           jobStatusMap[index] ?? false ? "Applied" : (status == false ? "Applied" : "Apply Now"),
//                                           style: TextStyle(
//                                             fontFamily: 'FontMain',
//                                           ),
//                                         ),
//                                       ),
//
//
//
//
//
//
//
//
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 73,),
//                                 // SizedBox(height: 20,),
//                               ],
//                             );
//
//                           },
//                         )
//                             : CircularProgressIndicator(),
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
//
