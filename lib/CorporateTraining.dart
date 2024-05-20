import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CorporateTraining extends StatefulWidget {
  const CorporateTraining({super.key});

  @override
  State<CorporateTraining> createState() => _CorporateTrainingState();
}

class _CorporateTrainingState extends State<CorporateTraining> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlreadyApplied();
    _loadUserEmail();
    fetchDiscount();
    print("ghfidahvchfcduhfsuch ");
  }
  String loginEmail="";
  int Uid = 0;
  String DiscountedPrice="";
  String Discount="";
  String OriginalPrice="";
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
    final response = await http.get(Uri.parse('http://13.127.81.177:8000/api/discount/'));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final Map<String, dynamic> discountData = data.last; // Access the last element in the list
        final int discount = discountData['discount'];
        final int originalPrice = discountData['original_price'];

        // Calculate discounted price
        final double discountPrice = originalPrice - (originalPrice * discount / 100);

        setState(() {
          DiscountedPrice = discountPrice.toString(); // Convert ID to String
          Discount=discount.toString();
          OriginalPrice=originalPrice.toString();
        });


      }

    }
  }
  Future<void> applyNow() async {
    final apiUrl = '${ApiUrls.baseurl}api/corporatetraining/';

    try {
      // Make a PATCH request to update the "Applied" field
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'applied': true,
          'email':loginEmail,
          'uid':Uid,
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
        print("Appliedddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");

        await ShowDialog();
        print('Applied successfully!');
        print('ApplyNow Response Code: ${response.statusCode}');
        print('ApplyNow Response Body: ${response.body}');
        // Add any additional logic or UI changes here
      }
      else {
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
                return true;
              },
              child: AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,// Set the background color to transparent
                actions: [

                  Column(
                    children: [
                      SizedBox(height: 30,),
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
                      SizedBox(height: 30,),
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
                  color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
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
                  return false;
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
                        "Thank you for applying to the Hiremi Corporate training Program. Check your email for interview details and further instructions. Best of luck on your journey to career excellence with Hiremi!",
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
  Future<void> loadUserUid() async {
    print("Hello");
   // await _loadUserEmail();

    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}verified-emails/'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Counter for verified records


        for (int index = 0; index < dataList.length; index++) {
          final Map<String, dynamic> data = dataList[index];

          final String userEmail = data['email'];
          final int UID = data['id'];


          if (userEmail == loginEmail ) {
            print(userEmail);
            print(UID);

            // await postVerifiedEmail();
            // await VerificationID2();
            Uid=UID;
            print(Uid);
            await applyNow();
            // Increment the counter for the next verified record

          }
        }
      }
      else {
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchData in UID: $e');
    }
  }
  Future<void> AlreadyApplied() async {
    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}api/corporatetraining/'));

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

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    PageController _controller = PageController();
    return  Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.pop(context);
                   },
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset('images/Back_Button.png')),
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  Row(
                    children: [
                      SizedBox(width: 54,),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize: screenWidth < 411 ? 22 : 25,
                            color: Colors.black, // Default color for the text
                          ),
                          children: [
                            TextSpan(
                              text: "Why Hiremi",
                            ),
                            TextSpan(
                              text: " Corporate\nTraining",
                              style: TextStyle(
                                color: Colors.redAccent, // Red color for "Corporate Training"
                              ),
                            ),
                            TextSpan(
                              text: "?",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.027,),
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
                                  SizedBox(height: screenHeight * 0.06),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Only for Graduates!",
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
                                        "Don't want a gap year after\ngraduation? Join the corporate\ntraining program now.",
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
                              gradient: const LinearGradient(
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
                                    SizedBox(height: screenHeight * 0.03,),
                                    Align(
                                      alignment : Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Real Workspace\nExperience",
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
                                          "Upon Enrollement you'll work\ndirectly in our program\ncompanies,going hands-on\nexperiences and expert guidance.",
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
                                  SizedBox(height: screenHeight * 0.05,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Get Experience letter",
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
                                        "All candidates will be provided with\nexperience certificates upon\nsuccessful completion of the\ncorporate Training.",
                                        style: TextStyle(
                                            fontSize: screenHeight< 411 ? 12 : 12,
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
                  SizedBox(height: screenHeight*0.033,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text("Corporate Training",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'FontMain',
                        fontSize:  screenWidth < 411  ? 22 : 25,

                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 25),
                    child: Text("Corporate training program at Hiremi prioritise comprehensive learning, diversity, and career excellence. We offer hands-on expertise, practical exercises, and a structured curriculum, preparing individuals for real-world challenges in a shorter time frame."
                      ,
                      textAlign: TextAlign.justify,
                      style:TextStyle(
                        fontWeight:FontWeight.w600,
                        fontSize:  screenWidth < 411   ? 12.5: 14,


                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: screenWidth*0.75, // Adjust the width as needed
                          height: screenHeight*0.35, // Adjust the height as needed
                          child: Card(
                              elevation: 10.0,
                              surfaceTintColor: Colors.grey,// rgba(0, 0, 0, 0.25)
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Text("Standard",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'FontMain',
                                        fontSize: screenWidth < 411   ? 19 : 22,
                                      ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'FontMain',
                                          fontSize: screenWidth < 411 ? 19 : 22,
                                          color: Colors.black, // You can change the color if needed
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Rs $DiscountedPrice",
                                          ),
                                          TextSpan(
                                            text: "/$OriginalPrice", // This will remain unstruck
                                            style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              // To remove the decoration from this part
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),


                                  SizedBox(height: screenHeight*0.02,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          height: screenHeight*0.0308,
                                          width: screenWidth*0.063,
                                          color: Colors.redAccent,
                                          child: Center(
                                            child: Container(
                                              height: screenHeight*0.0154,
                                              width: screenWidth*0.0315,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth*0.048,),
                                      Text("One-Year Program : Our\nintensive one-year program\nensures a deep dive into the\nskills and knowledge needed to\nexcel in the corporate world."
                                        ,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontFamily: 'FontMain',
                                          fontSize:  screenWidth < 411 ? 10 : 10,
                                          // fontSize:  4,

                                        ),),

                                    ],),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),

                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 220.0,bottom: 70),
                          child: Card(
                              elevation: 9.0,
                              surfaceTintColor: Colors.transparent,// rgba(0, 0, 0, 0.25)
                              child: Column(
                                children: [
                                  Text("$Discount% OFF",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'FontMain',
                                      fontSize:  screenWidth < 411 ?17: 21,
                                      color:  Color(0xFFF13640),
                                    ),),

                                ],
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset('images/Black.png')),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize: screenWidth < 411 ? 22 : 25,
                            color: Colors.black, // Default color for the text
                          ),
                          children: [

                            TextSpan(
                              text: "How the",
                            ),
                            TextSpan(
                              text: " Training\nEnhances ",
                              style: TextStyle(
                                color: Colors.redAccent, // Red color for "Corporate Training"
                              ),
                            ),
                            TextSpan(
                              text: "Employability",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Image.asset("images/JobSeeker.png"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enrollment in the program:",style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'FontMain',
                              fontSize: screenWidth < 411 ? 9: 10,
                            ),),
                            Text("The first step towards enhancing\nemployability begins with enrolling\nin our carefully crafted Corporate\nTraining Program. This signifies your\ncommitment to continuous learning and\nprofessional development, setting the\nstage for a transformative journey.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9: 9,
                              ),)
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0415,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("images/Medical.png"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("College Students:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'FontMain',
                              fontSize: screenWidth < 411 ? 9: 10,
                            ),),
                          Text("Start your journey with ease by submitting\nyour documents. Once verified, you're\nenrolled in our Corporate Training Program,\nready to enhance your professional skills\nand excel in your career. It's a simple,\nprofessional, and efficient onboarding\nprocess for your success",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "FontMain",
                              fontSize: screenWidth < 411 ? 9: 9,
                            ),)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.041,),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("images/JobSeeker.png"),
                        //SizedBox(width: screenWidth*0.0608,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Professionals:",style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'FontMain',
                              fontSize: screenWidth < 411  ? 9: 10,
                            ),),
                            Text("Unlike conventional training programs,\nours goes beyond theoretical knowledge.\nParticipants have the unique opportunity\nto engage in direct working\nexperiences within corporate settings.\nThis hands-on approach ensures\na seamless transition from the\nlearning environment to real-world\ncorporate challenges.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "FontMain",
                                fontSize: screenWidth < 411 ? 9: 9,
                              ),)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('images/Hiremi_Icon.png',width: screenWidth * 0.5599,),
                      Image.asset('images/partnerpana.png'),
                    ],
                  ),
                  Text(" Unlock your potential with Hiremi – where Corporate Training meets tailored guidance for your journey to success."
                    ,
                    textAlign: TextAlign.center,
                    style:TextStyle(
                        fontWeight:FontWeight.w600,
                        fontSize:  screenWidth < 411   ? 12.5: 10,
                        fontFamily: 'FontMain'

                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text("How to Enroll in Hiremi\nCorporate Training Program:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'FontMain',
                            fontSize:  screenWidth < 411 ? 18 : 16,
                          ),),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset("images/Rocket.png"),

                        ],
                      ),
                      // SizedBox(width: screenWidth*0.060,),
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
                              "1.Launch the Hiremi app an\nhead to the Corporate Training\n section.",
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
                            "2.Look for the 'Apply Now' option\n and tap on it to begin your\napplication process.",
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
                      SizedBox(width: screenWidth*0.024,),
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
                              "1,Once your session is\nscheduled,you will receive a\n notification.",
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
                      SizedBox(width: screenWidth*0.036,),
                      Column(
                        children: [
                          Image.asset("images/Meeting.png"),
                          // Image.asset("images/Flag.png"),

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
                          Image.asset("images/Flag.png",),
                        ],
                      ),
                      //SizedBox(width: screenWidth*0.060,),
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
                            padding: const EdgeInsets.only(left: 20,top: 5),
                            child: Text(
                              "1.After selection,gain exclusive\naccess to enroll in our Corporate\nTraining via the app by completing \npayment process.",
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
                              "2.Get ready for a transformative\nreal-time projects exposure,and\ncareer growth.",
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
                  SizedBox(height: screenHeight*0.01,),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 80.0),
                  //   child: Image.asset("images/Line.png"),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(width: screenWidth*0.024,),
                  //     Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 170.0),
                  //           child: Text("Step 4:",style: TextStyle(
                  //             color: Colors.redAccent,
                  //             fontFamily: 'FontMain',
                  //             fontSize: screenWidth < 411 ? 9.5: 13,
                  //           ),),
                  //         ),
                  //         Text("Complete the Hiremi app's account\nverification form accurately to expedite\nthe process. Expect a comprehensive\ninterview to discuss your career\naspirations for the best fit."
                  //           ,
                  //           textAlign: TextAlign.start,
                  //           style: TextStyle(
                  //             fontFamily: "FontMain",
                  //             fontSize: screenWidth < 411  ? 8: 10,
                  //           ),)
                  //       ],
                  //     ),
                  //     SizedBox(width: screenWidth*0.036,),
                  //     Column(
                  //       children: [
                  //         Image.asset("images/Flag.png"),
                  //
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 90,),

                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight*0.0711, // Adjust the height as needed
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
                      // await loadUserUid()
                      // ;
                      await _showConformationDialog();
                      // await ShowDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasAlreadyApplied ? Colors.grey : const Color(0xFFF13640),
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
    );
  }
}
