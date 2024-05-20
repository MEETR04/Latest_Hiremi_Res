import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/internship.dart';
import 'package:hiremi/utils/api.dart';
import 'package:hiremi/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class InternshipDescription extends StatefulWidget {
  String InternshipProfile;
  String InternshipLocation;
  String InternshipCtc;
  String companyName;
  String education;
  String InternshipDescreption;
  String termsAndConditions;
  String skillRequired;
  int id;
  int jobIndex;

  InternshipDescription({
    super.key,
    required this.InternshipProfile,
    required this.InternshipLocation,
    required this.InternshipCtc,
    required this.companyName,
    required this.education,
    required this.InternshipDescreption,
    required this.termsAndConditions,
    required this.skillRequired,
    required this.id,
    required this.jobIndex,

  });



  @override
  State<InternshipDescription> createState() => _InternshipDescriptionState();
}


class _InternshipDescriptionState extends State<InternshipDescription> {
  String loginEmail = "";
  late int Code;
  String JobProfile=" ";
  String JProfile="";
  // bool isButtonEnabled=true;
  String JobCodeRequired="";
  bool applyButtonClicked = false;
  bool jobCodeDialogShown = false;

  @override
  void initState() {
    super.initState();
    print('Job Index in job description: ${widget.jobIndex}');
    _loadUsername();

    getFresherJobProfile();
  }


  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    print(loginEmail);
    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
    }
  }
  Future<void> getFresherJobProfile() async {
    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}internship/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Counter for verified records

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          if (index == widget.jobIndex) {
            final String jobcoderequired=data['Internship_code_required'];
            final dynamic jobCodeValue = data['Internship_code'];
            final int jobCode = (jobCodeValue != null) ? jobCodeValue as int : 0;

            Code=jobCode;
            JobCodeRequired=jobcoderequired;
            print('Job Profile at index  $JobCodeRequired');
            print('Job Code at index  $jobCode');
            if(jobcoderequired=="No")
            {
              print("No");
              // setState(() {
              //   isButtonEnabled = true;
              // });
            }
            else
            {
              print("Yes");
              //  await  _showJobCodeDialog();
            }

          }
        }
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchData: $e');
    }
  }



  TextEditingController jobCodeController = TextEditingController();

  Future<List<int>> fetchJobCodes() async {
    final url = Uri.parse('${ApiUrls.baseurl}internship/');
    final response = await http.get(url);
    //_loadUsername();
    if (response.statusCode == 200) {
      final List<dynamic> jobList = json.decode(response.body);

      // Extract job codes from the list
      final List<int> jobCodes = jobList
          .map<int>((job) => (job['Internship_code'] != null) ? job['Internship_code'] as int : 0)
          .toList();

      print("job codes are $jobCodes");
      return jobCodes;
    }
    else {
      // Handle the error if the server request fails
      print('Failed to load job codes');
      return [];
    }
  }


  Future<void> _showJobCodeDialog() async {
    print("Code is $Code");
    if (!jobCodeDialogShown || jobCodeDialogShown) {
      jobCodeDialogShown = true; // Set the flag to true
      List<int> jobCodes = await fetchJobCodes();


      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              // Your dialog
              AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                actions: [
                  Column(
                    children: [
                      const SizedBox(height: 30,),
                      const Center(
                        child: Text(
                          "Enter Internship Code ",
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 18,
                            color: Color(0xFFBD232B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextField(
                        controller: jobCodeController,
                        decoration: const InputDecoration(labelText: 'Internship Code'),
                      ),
                      const SizedBox(height: 15,),

                      ElevatedButton(
                        onPressed: () async {
                          int enteredJobCode = int.tryParse(jobCodeController.text) ?? -1;

                          Navigator.of(context).pop();
                          if (Code == enteredJobCode) {
                            print('Job Code is valid');
                            _showSuccessDialog();
                          } else {
                            print('Job Code is not valid');
                            _showFailDialog();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF13640),
                          minimumSize: const Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      );
    }
  }
  Future<void> retrieveSubmitStatus3(String JProfile) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true); // Close the dialog after 3 seconds
        });
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
                            style: const TextStyle(
                              fontFamily: "FontMain",
                              fontSize: 15,
                              color: Colors.black, // Default color for other text
                            ),
                            children: [
                              const TextSpan(
                                text: "You have applied for ",
                              ),

                              TextSpan(
                                text: "$JProfile",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make JobProfile text bold
                                  color: Color(0xFFBD232B), // Desired color for JobProfile text
                                ),
                              ),
                              const TextSpan(
                                text: " position. We will update you after the interview.",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
                content: const Text(

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

  // bool jobCodeDialogShown = false;
  Future<void> saveJobProfile(String jobProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jobProfile', jobProfile);
    print("Hello$jobProfile");
  }

  Future<void> _showSuccessDialog() {
    bool agreedToTerms = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            // Your AlertDialog
            WillPopScope(
              onWillPop: () async {
                // Handle back button press here
                // Returning true allows the dialog to be popped
                // Returning false prevents the dialog from being popped
                return true;
              },
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    title: const Text(
                      'Terms And Condition',
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Center(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       text: widget.termsAndConditions,
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 12,
                          //         fontFamily: 'Poppins',
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const Text(
                            "1.All the selected students will get mobile application link, where they have to pay a security deposit of Rs. 3000 which is refundable only at the time of joining the organization (after completion of training)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: 'FontMain',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text(
                            "2.After doing registration then their Employee id will get active and their entire joining process will get started In case any student has done registration then they don't want to join the organization so in such a situation amount is not refundable.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: 'FontMain',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text(
                            "3.The offer letter will be released only after registration.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: 'FontMain',
                              color: Colors.black
                              ,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text(
                            "4.Security Deposit: As a part of the joining process, all selected students are required to pay a refundable security deposit of Rs. 3000."
                            ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: 'FontMain',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: agreedToTerms
                                      ? () {
                                    //  _loadUserJobProfile();
                                    _applyForJob();
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: agreedToTerms ? const Color(0xFFF13640) : null,
                                  ),
                                  child: const Text(
                                    'Apply',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    agreedToTerms = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text('Agree with terms and conditions'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );



  }



  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "$error",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "FontMain",
                      fontSize: 18,
                      color: Color(0xFFBD232B),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Pop the current route (the AlertDialog)
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF13640),
                    minimumSize: const Size(250, 50),
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
          ),
        );
      },
    );
  }

  void _showFailDialog() {

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actions: [
            Column(
              children: [
                const SizedBox(height: 30,),
                const Center(child: Text("Job Code is not valid",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "FontMain",
                    fontSize: 18,
                    color: Color(0xFFBD232B),
                  ),)),
                const SizedBox(height: 35,),
                // ElevatedButton(onPressed: (){
                //
                // }, child: Text("click here"))
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF13640),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      )
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


  Future<void> _applyForJob() async {
    final String apiUrl = '${ApiUrls.baseurl}Internship-applications/';

    final Map<String, dynamic> postData = {
      "email": loginEmail,
      "Internship_profile": widget.InternshipProfile,
      "company_name" :widget.companyName,
      // Add other required fields here
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(postData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {

        print('Application submitted successfully');
        print('${response.body}');
        print('${response.statusCode}');
        jobCodeController.clear();

        saveJobProfile(widget.InternshipProfile);

        jobCodeDialogShown = false;
        //   Navigator.of(context).pop();
        // Navigate to the HomePage
        _loadUserJobProfile();
        ChangeStatustoApplied();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(sourceScreen: "Screen11", uid: "", username: "", verificationId: ""),
          ),
        );

      }


      else {
        // Request failed, handle the error

        final error = response.body;

        _showErrorDialog(error);

        print('Failed to submit application. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error submitting application: $error');
    }
  }
  Future <void> _loadUserJobProfile()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });

      // Replace the API URL with your actual API endpoint
      final apiUrl = '${ApiUrls.baseurl}Internship-applications/';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is List && data.isNotEmpty) {
            for (final user in data) {
              final email = user['email'];
              final jobProfile=user['job_profile'];

              if (email == loginEmail) {
                print("We are in the job profile");
                setState(() {

                  JProfile=jobProfile;
                });

                print("Job profile is $JProfile");


                // Exit the loop once a match is found
              }
            }


          } else {
            print('Email not found on the server.');
          }
          retrieveSubmitStatus3(JProfile);
        }
      } catch (e) {
        print('Error in jobprofile: $e');
      }
    }
  }
  Future<void> ChangeStatustoApplied() async {
    final apiUrl = '${ApiUrls.baseurl}internship/';

    try {
      // Make a PATCH request to update the "Applied" field
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_has_applied': true,

        }),
      );

      if (response.statusCode == 201) {
        // Successfully updated the "Applied" field
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomePage(sourceScreen: '', uid: '', username: '', verificationId: ''),
        //   ),
        // );
        // await ShowDialog();
        print('Applied successfully!');
        print('ApplyNow Response Codeeeeeeeeeeeeeeeeee: ${response.statusCode}');
        print('ApplyNow Response Bodyyyyyyyyyyyyyyyyyyy: ${response.body}');
        // Add any additional logic or UI changes here
      }
      else {
        // Failed to update the "Applied" field
        print('Failed to apply in patch in fresherJob: ${response.statusCode}');
        print("${response.body}");
        // Add error handling or show an error message
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while applying: $e');
      if (e is http.ClientException) {
        // Print the response body if available
        print('Response body: ${e.message}');
      }
      // Add error handling or show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> skills = widget.skillRequired.split(','); // Split skills by comma

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("ABC");

      print("ABC2");
    });
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [

              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return InternScreen();
                  //     },
                  //   ),
                  // );
                  Navigator.pop(context);

                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 290.0),
                  child: Image.asset('images/Back_Button.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  width: double.infinity,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.InternshipProfile,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,top: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: MyColor.grey7474,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Location:   ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: MyColor.grey7474,
                              ),
                            ),
                            TextSpan(
                              text: widget.InternshipLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,top: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.money,
                      color: MyColor.grey7474,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Stipend :   ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: MyColor.grey7474,
                              ),
                            ),
                            TextSpan(
                              text: widget.InternshipCtc,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                width: double.infinity, // Use double.infinity to stretch the Divider
                child: const Divider(),
              ),

              const Padding(
                padding: EdgeInsets.only(right: 100.0),
                child: Text(
                  'About the Internship',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.InternshipDescreption,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MyColor.black,
                    ),
                  ),
                ),
              ),

              Column(

                children: [
                  const SizedBox(height: 20,),
                  const Padding(
                    padding:  EdgeInsets.only(right: 160.0),
                    child:  Text(
                      'Skill(s) required:',

                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft, // Align the Wrap to the left
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: skills.map((skill) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(5), // Adjust the margin for gap between skills
                                decoration: BoxDecoration(
                                  color: Colors.grey, // Adjust color to match the image
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  skill.trim(), // Trim to remove leading/trailing spaces
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 25,),
                    const Padding(
                      padding: EdgeInsets.only(right: 160.0),
                      child: Text(
                      'Who can Apply',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          fontFamily: 'FontMain'
                      ),
                                        ),
                    ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.termsAndConditions,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: MyColor.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () async {
                      await getFresherJobProfile();

                      if (JobCodeRequired == "Yes") {
                        print("JobCodeRequired is Yes");
                        await _showJobCodeDialog();

                      } else {
                        //_showSuccessDialog();
                        _applyForJob();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBD232B),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ), const SizedBox(height: 30),


                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
