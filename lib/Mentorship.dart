import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Mentorship extends StatefulWidget {
  const Mentorship({super.key});

  @override
  State<Mentorship> createState() => _MentorshipState();
}

class _MentorshipState extends State<Mentorship> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlreadyApplied();
    _loadUserEmail();
    fetchDiscount();
  }

  String loginEmail = "";
  int Uid = 0;
  String DiscountedPrice = "";
  String Discount = "";
  String OriginalPrice = "";
  // or whatever default value you want to assign
  bool hasAlreadyApplied = false;

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        loginEmail = savedUsername;
      });
    }
  }

  Future<void> fetchDiscount() async {
    final response =
        await http.get(Uri.parse('http://13.127.81.177:8000/api/discount/'));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final Map<String, dynamic> discountData =
            data.last; // Access the last element in the list
        final int discount = discountData['discount'];
        final int originalPrice = discountData['original_price'];

        // Calculate discounted price
        final double discountPrice =
            originalPrice - (originalPrice * discount / 100);

        setState(() {
          DiscountedPrice = discountPrice.toString(); // Convert ID to String
          Discount = discount.toString();
          OriginalPrice = originalPrice.toString();
        });
      }
    }
  }

  Future<void> AlreadyApplied() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiUrls.baseurl}api/mentorship/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          final String userEmail = data['email'];

          if (userEmail == loginEmail) {
            setState(() {
              print("User has already applied. Email: $loginEmail");
              hasAlreadyApplied = true;
            });
            break;
          }
        }
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error in alreadyApplied: $e");
    }
  }

  Future<void> loadUserUid() async {
    // await _loadUserEmail();

    try {
      final response =
          await http.get(Uri.parse('${ApiUrls.baseurl}verified-emails/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Counter for verified records

        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          final String userEmail = data['email'];
          final int UID = data['id'];

          if (userEmail == loginEmail) {
            print(userEmail);
            print(UID);
            // await postVerifiedEmail();
            // await VerificationID2();
            Uid = UID;
            print(Uid);
            await applyNow();

            // Increment the counter for the next verified record
          }
        }
      } else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchData in UID: $e');
    }
  }

  Future<void> applyNow() async {
    final apiUrl = '${ApiUrls.baseurl}api/mentorship/';

    try {
      // Make a PATCH request to update the "Applied" field
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'applied': true,
          'email': loginEmail,
          'uid': Uid,
          "candidate_status": "Pending",
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
        print(
            "Appliedddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
        await ShowDialog();
        print('Applied successfully!');
        print('ApplyNow Response Code: ${response.statusCode}');
        print('ApplyNow Response Body: ${response.body}');
        // Add any additional logic or UI changes here
      } else {
        // Failed to update the "Applied" field
        print('Failed to apply: ${response.statusCode}');
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

  Future<void> ShowDialog() async {
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("your_background_image_path"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color:
                      Colors.black.withOpacity(0.5), // Adjust opacity as needed
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
                        "Thank you for applying to the Hiremi Mentorship Program. Check your email for interview details and further instructions. Best of luck on your journey to career excellence with Hiremi!",
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

  Future<void> _showConformationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity as needed
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
                surfaceTintColor: Colors
                    .transparent, // Set the background color to transparent
                actions: [
                  // Column(
                  //   children: [
                  //     Center(
                  //       child: RichText(
                  //         textAlign: TextAlign.center,
                  //         text: TextSpan(
                  //           style: TextStyle(
                  //             fontFamily: "FontMain",
                  //             fontSize: 15,
                  //             color: Colors.black, // Default color for other text
                  //           ),
                  //           children: [
                  //             TextSpan(
                  //               text: "You have applied for ",
                  //             ),
                  //             TextSpan(
                  //               text: Intern_Profile,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold, // Make JobProfile text bold
                  //                 color: Color(0xFFBD232B), // Desired color for JobProfile text
                  //               ),
                  //             ),
                  //             TextSpan(
                  //               text: " internship position. We will update you after the interview.",
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(height: 20),
                  //   ],
                  // ),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          "Ready to begin your mentorship journey", // Your leading text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "FontMain",
                            fontSize: 20,
                            color: Color(0xFFBD232B),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await loadUserUid();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF13640),
                              minimumSize: Size(50, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Yes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(50, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFF13640),
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    PageController _controller = PageController();
    print("Width is $screenWidth");
    print("Height is $screenHeight");
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return HomePage(sourceScreen: "", uid: "", username: "", verificationId: "");
                      //     },
                      //   ),
                      // );
                      Navigator.pop(context);
                    },
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset('images/Back_Button.png')),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    "Why Hiremi Mentorship?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: screenWidth < 411 ? 22 : 25,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.027,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF13640), Color(0xFF8E3E42)],
                          stops: [0.1454, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: PageView(
                        controller: _controller,
                        children: [
                          // Page 1
                          Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: screenHeight * 0.04,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Only for college students!",
                                        style: TextStyle(
                                            fontSize: screenWidth < 411  ? 15 : 12,
                                            fontFamily: "FontMain",
                                            color: Colors
                                                .white // Adjust font size as per screen width
                                            ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "All Candidate will be Provided with \na course completion & "
                                        "internship \ncertificate upon Successful completion \nof the mentorship.",
                                        style: TextStyle(
                                          fontSize:
                                              screenWidth < 411 ? 12 : 12,
                                          color: Colors
                                              .white, // Adjust font size as per screen width
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                  top: screenHeight * 0.1,
                                  right: screenWidth * 0.09,
                                  child: Image.asset("images/certificate.png")),
                            ],
                          ),
                          // Page 2
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFF13640), Color(0xFF8E3E42)],
                                stops: [0.1454, 1.0],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: screenHeight * 0.07,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Become Job Ready",
                                          style: TextStyle(
                                              fontSize: screenWidth < 411  ? 15 : 12,
                                              color: Colors.white,
                                              fontFamily:
                                                  "FontMain" // Adjust font size as per screen width
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Build an attractive resume/profile\nalong with soft skills,training and\nmock interviews",
                                          style: TextStyle(
                                              fontSize: screenWidth <411 ? 12 : 12,
                                              color: Colors
                                                  .white // Adjust font size as per screen width
                                              ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                    top: screenHeight * 0.1,
                                    right: screenWidth * 0.09,
                                    child:
                                        Image.asset("images/certificate.png")),
                              ],
                            ),
                          ),
                          // Page 3
                          Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: screenHeight * 0.04,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Industry-Recognised\nInternship-Certificate",
                                        style: TextStyle(
                                            fontSize: screenWidth < 411  ? 15 : 12,
                                            fontFamily: "FontMain",
                                            color: Colors
                                                .white // Adjust font size as per screen width
                                            ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Post membership completion,\ncandidates will be given course\ncompletion and internship\ncertificates.",
                                        style: TextStyle(
                                            fontSize: screenWidth < 411 ? 12 : 12,
                                            color: Colors
                                                .white // Adjust font size as per screen width
                                            ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                  top: screenHeight * 0.1,
                                  right: screenWidth * 0.09,
                                  child: Image.asset("images/certificate.png")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(),
                    child: SmoothPageIndicator(
                      count: 3,
                      controller: _controller,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.red,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.033,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Mentorship",
                        style: TextStyle(
                          fontFamily: 'FontMain',
                          fontSize: screenWidth < 411 ? 22 : 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.026,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(
                      "Mentorship at Hiremi is a dynamic partnership designed to promote professional and academic growth. It's a collaborative relationship between experienced mentors and college students seeking guidance in their career or academic pursuits.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth < 411 ? 12.5 : 14,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.033,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Stack(
                      children: [
                        Container(
                          width:
                              screenWidth * 0.69, // Adjust the width as needed
                          height: screenHeight *
                              0.28, // Adjust the height as needed
                          child: Card(
                            elevation: 9.0,
                            surfaceTintColor: Colors.grey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    "Standard",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'FontMain',
                                      fontSize: screenWidth < 411 ? 19 : 22,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Text(
                                    "Rs $DiscountedPrice/Rs $OriginalPrice",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'FontMain',
                                      fontSize: screenWidth < 411 ? 19 : 22,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Container(
                                          height: screenHeight * 0.0308,
                                          width: screenWidth * 0.063,
                                          color: Colors.redAccent,
                                          child: Center(
                                            child: Container(
                                              height: screenHeight * 0.0154,
                                              width: screenWidth * 0.0315,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.048),
                                      Text(
                                        "Entire Academic\nSession+ one extra year",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'FontMain',
                                          fontSize: screenWidth < 411 ? 10 : 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth < 411 ? 180.0 : 220.0,
                              bottom: 70),
                          child: Card(
                            elevation: 9.0,
                            surfaceTintColor: Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  "$Discount% OFF",
                                  style: TextStyle(
                                    fontFamily: 'FontMain',
                                    fontSize: screenWidth < 411 ? 17 : 21,
                                    color: Color(0xFFF13640),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.071,
                  ),
                  Text(
                    "Why Choose Hiremi Mentorship?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: screenWidth < 411 ? 16.65 : 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.033,
                      ),
                      Image.asset('images/partnerpana.png'),
                      //SizedBox(width: screenWidth*0.011,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1.Personalised Guidance :",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FontMain',
                              color: Colors.redAccent,
                              fontSize: screenWidth < 411 ? 10 : 12,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.010,
                          ),
                          Text(
                            "Navigate your career with\npersonalized mentorship\ntailored to your goals \nand aspirations.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 10 : 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.041,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(width: screenWidth*0.018,),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              "2.Industry Insights :",
                              style: TextStyle(
                                fontFamily: 'FontMain',
                                color: Colors.redAccent,
                                fontSize: screenWidth < 411 ? 10 : 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.010,
                          ),
                          Text(
                            "Gain valuable insights\ninto your chosen\nfield from experienced\nprofessionals.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 10 : 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.1,
                      ),
                      Image.asset('images/Cpana.png'),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.033,
                      ),
                      Image.asset('images/Helping.png'),
                      SizedBox(
                        width: screenWidth * 0.024,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Text(
                              "3.Skill Development :",
                              style: TextStyle(
                                fontFamily: 'FontMain',
                                color: Colors.redAccent,
                                fontSize: screenWidth < 411 ? 10 : 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            "Elevate your skill set with\ncurated programs designed\nto enhanceyour capabilities\nand make you job-ready.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 10 : 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.041,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              "4.Network Opportunities:",
                              style: TextStyle(
                                fontFamily: 'FontMain',
                                color: Colors.redAccent,
                                fontSize: screenWidth < 411 ? 10 : 13,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.010,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 13),
                            child: Text(
                              "Expand your professional\nnetwork with connections\nthat can influence your\n career trajectory.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 10 : 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Image.asset('images/pana.png'),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.041,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/Confidence.png'),
                      SizedBox(
                        width: screenHeight * 0.011,
                      ),
                      Column(
                        children: [
                          Text(
                            "5.Confidence building:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FontMain',
                              color: Colors.redAccent,
                              fontSize: screenWidth < 411 ? 9.3 : 13,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.010,
                          ),
                          Text(
                            "Develop confidence in\nyour abilities with\nongoing support and\nconstructive feedback.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 9.3 : 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.0415,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 100.0),
                    child: Text(
                      "Who does it help?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'FontMain',
                        fontSize: screenWidth < 411 ? 24 : 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.0415,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("images/JobSeeker.png"),
                      // SizedBox(
                      //   width: screenWidth * 0.0,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Job Seekers:",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'FontMain',
                              fontSize: screenWidth < 411 ? 9 : 12,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Individuals looking to enter the job market \nbenefit from mentorship by gaining a\ncompetitive edge and understanding \nindustry expectations.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 10,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.0415,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset("images/Medical.png"),
                  //     SizedBox(width: screenWidth*0.018,),
                  //     Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 170.0),
                  //           child: Text("College Students:",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               color: Colors.redAccent,
                  //               fontFamily: 'FontMain',
                  //               fontSize: screenWidth < 411 ? 9: 12,
                  //             ),),
                  //         ),
                  //         Text("Mentorship aids students in navigating\ntheir academic journey, making\ninformed careerchoices, and\npreparing for the professional\nworld.",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontFamily: "FontMain",
                  //             fontSize: screenWidth < 411 ? 9: 11,
                  //           ),)
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset("images/Profe.png"),
                  //     SizedBox(width: screenWidth*0.0608,),
                  //     Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 170.0),
                  //           child: Text("Professionals:",style: TextStyle(
                  //             color: Colors.redAccent,
                  //             fontFamily: 'FontMain',
                  //             fontSize: screenWidth < 411  ? 9: 13,
                  //           ),),
                  //         ),
                  //         Text("Even experienced professionals\nbenefit by receiving guidance on\ncareer advancement, leadership skills,\nand staying relevant in a rapidly\nchanging work environment.",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontFamily: "FontMain",
                  //             fontSize: screenWidth < 411 ? 9: 12,
                  //           ),)
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  Text(
                    "How to Apply for Mentorship?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: screenWidth < 411 ? 19 : 23,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.041,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset("images/Rocket.png"),
                        ],
                      ),
                      // SizedBox(width: screenWidth*0.060,),
                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right: 170.0),
                      //       child: Text("Step 1:",style: TextStyle(
                      //         color: Colors.redAccent,
                      //         fontFamily: 'FontMain',
                      //         fontSize: screenWidth < 411  ? 11: 14,
                      //       ),),
                      //     ),
                      //     Text(" Tap on Apply\nLaunch the Hiremi app\nand head to the\nMentorship section.\nLook for the'Apply Now' option\nand tap on it to begin\nyour application process.",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontFamily: "FontMain",
                      //         fontSize: screenWidth < 411 ? 9: 11,
                      //       ),)
                      //   ],
                      // ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 170.0),
                            child: Text(
                              "Step 1:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: "FontMain",
                                  fontSize: screenWidth < 411 ? 11 : 11),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 135),
                            child: Text(
                              "Tap to apply",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "FontMain",
                                  fontSize: 11),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "1.Launch the Hiremi appand\nhead to the Mentorship section.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 9,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3.5,
                          ),
                          Text(
                            "2.Look for the apply now option \n and tap on it to begin your\n application process.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 9 : 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: Image.asset("images/Line.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.024,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 140),
                            child: Text(
                              "Step 2:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: "FontMain",
                                  fontSize: screenWidth < 411 ? 11 : 11),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 104),
                            child: Text(
                              "Q&A Session:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "FontMain",
                                  fontSize: 11),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5,right: 10),
                            child: Text(
                              "1.Once your session is\nscheduled,you will receive a\n notification.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 9,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: Text(
                              "2.During the session ,you'll\nhave to opportunity to\ndiscuss your queires and\ncareer aspiration with our\nexperienced mentors.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.036,
                      ),
                      Column(
                        children: [
                          Image.asset("images/Meeting.png"),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset("images/Line2.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset("images/Flag.png"),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.060,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 149),
                            child: Text(
                              "Step 3:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: "FontMain",
                                  fontSize: screenWidth < 411 ? 11 : 11),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 60),
                            child: Text(
                              "Enroll in the program:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "FontMain",
                                  fontSize: 11),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5,top: 5),
                            child: Text(
                              "1.After selection, gain exclusive\naccess to enroll in our mentor-\nship program via the app by\ncompleting payment process.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 9,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Text(
                              "2.Get ready for a transformative\nexperience in skill development,\nreal-time project exposure, and\ncareer growth.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9 : 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.100,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.0711, // Adjust the height as needed
                // Adjust the color as needed
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AlreadyApplied();

                      if (hasAlreadyApplied) {
                        // User has already applied, disable the button
                        return null;
                      } else {
                        // User has not applied, handle button click logic here
                        //  await loadUserUid();
                        await _showConformationDialog();
                        // await ShowDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAlreadyApplied
                          ? Colors.grey
                          : const Color(0xFFF13640),
                      minimumSize: Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      hasAlreadyApplied ? "Already Applied" : "Apply Now",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: hasAlreadyApplied ? Colors.white : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
