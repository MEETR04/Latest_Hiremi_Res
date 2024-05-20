import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/signin.dart';
//import 'package:hiremi/FresherJob.dart';
//import 'package:hiremi/FresherJob2.dart';
import 'package:hiremi/user_verification_screen.dart';
import 'package:http/http.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FemaleProfile extends StatefulWidget {
  const FemaleProfile({super.key});

  @override
  State<FemaleProfile> createState() => _FemaleProfileState();
}

class _FemaleProfileState extends State<FemaleProfile> {
  int _currentIndex = 0;
  List<Color> _iconColors = [
    Colors.red,
    Color(0xFF9B9B9B),
    Color(0xFF9B9B9B)

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white10,
          color: Color(0xFFEDEDED),
          items: [
            Icon(Icons.home, size: 50, color: _iconColors[0]),
            Icon(Icons.mail, size: 50, color: _iconColors[1]),
            Icon(Icons.face_2_rounded, size: 50, color: _iconColors[2]),

          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              for (int i = 0; i < _iconColors.length; i++) {
                if (i == index) {
                  _iconColors[i] =
                      Colors.red; // Change the color for the tapped icon
                } else {
                  _iconColors[i] =
                      Color(0xFF43485E); // Reset the color for other icons
                }
              }
            });
          },
        ),


        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [

                SizedBox(height: 30,),
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset('images/ThreeLine.png')),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Container(

                      child: FractionalTranslation(
                          translation: Offset(0.3, 0),
                          child: Image.asset('images/female.png')),
                    ),
                    SizedBox(width: 25,),

                    Column(
                      children: [
                        Text("Hii!!", style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),),
                        Text("Rishu", style: TextStyle(
                          color: Colors.black,
                          fontFamily: "FontMain",
                          fontSize: 20,
                        ),),
                        Text("ID :10000001", style: TextStyle(
                          color: Colors.black,

                          fontSize: 20,
                        ),),


                      ],


                    ),


                  ],
                ),
                SizedBox(height: 20,),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 35,
                        right: 15,
                        bottom: 10,
                      ),
                      child: Container(
                        height: 134,
                        width: 318,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          gradient: LinearGradient(
                            transform: GradientRotation(104),
                            colors: [
                              Color(0xFF331A4F),
                              Color(0xFF692C57),
                              Color(0xFF9E3D5C),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 5,
                      child: Image.asset(
                        'images/TheGirl.png',
                        height: 150,
                        width: 91,
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: 30,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(
                          const Size(234, 46),
                        ),
                        child: const Text(
                          'Launching assessments on the app!',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: 85,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(
                          const Size(230, 54),
                        ),
                        child: const Text(
                          'Show your verified skills to recruiters and get ahead in your job search journey',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ]
                          ),
                        ),
                        width: 120,
                        height: 120,
                        child: Image.asset('images/Intern.png'),

                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xFFF13640),
                                  Color(0xFFBD2930),
                                ]
                            ),
                          ),
                          width: 120,
                          height: 120,

                          child: Image.asset('images/FresJob.png'),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Internship", style: TextStyle(
                        fontFamily: 'FontMain',
                        fontSize: 18
                    ),),
                    Text(" Fresher Job", style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: 18,
                    ),)
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ]
                          ),
                        ),
                        width: 120,
                        height: 120,
                        child: Image.asset('images/Ex.png'),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xFFF13640),
                                Color(0xFFBD2930),
                              ]
                          ),
                        ),
                        width: 120,
                        height: 115,
                        child: Image.asset('images/Mentor.png'),
                      ),
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Experience", style: TextStyle(
                        fontFamily: 'FontMain',
                        fontSize: 18
                    ),),
                    Text("Mentorship", style: TextStyle(
                      fontFamily: 'FontMain',
                      fontSize: 18,
                    ),)
                  ],
                ),


              ],
            ),
          ),
        )
    );
  }
}
