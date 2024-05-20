import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hiremi/firstCongratulationScreen.dart';
import 'package:hiremi/seceondCongratulationScreen.dart';
import 'package:hiremi/signin.dart';

class thirdCongratulationScreen extends StatefulWidget {
  const thirdCongratulationScreen({super.key});

  @override
  State<thirdCongratulationScreen> createState() =>
      _thirdCongratulationScreenState();
}

class _thirdCongratulationScreenState extends State<thirdCongratulationScreen> {
  int _currentPage = 0; // Current page index
  final PageController _pageController = PageController(initialPage: 2);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [

  //           Expanded(
  //             child: PageView(
  //               controller: _pageController,
  //               onPageChanged: (int page) {
  //                 setState(() {
  //                   _currentPage = page;
  //                 });
  //               },
  //               children: [
  //                 // Pages in your PageView
  //                 // Each page corresponds to a different index
  //
  //                 // Page 0
  //                 Column(
  //                   children: [
  //                     Image.asset('images/Hiremi_Icon.png'),
  //                     Image.asset('images/FirstCongratulationScreen.png'),
  //                     SizedBox(height: 20),
  //                     Text(
  //                       "Let’s get started!",
  //                       style: TextStyle(
  //                         fontSize: 30,
  //                         fontFamily: 'FontMain',
  //                         color: Colors.redAccent,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 // Page 1
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 100.0),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset('images/Hiremi_Icon.png'),
  //                       Image.asset('images/seceondCongratulations.png'),
  //                       Text(
  //                         "Let’s get started!",
  //                         style: TextStyle(
  //                           fontSize: 30,
  //                           fontFamily: 'FontMain',
  //                           color: Colors.redAccent,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // Page 2
  //                 Column(
  //                   children: [
  //                     Image.asset('images/Hiremi_Icon.png'),
  //                     Image.asset('images/thirdCongratulation.png'),
  //                     Container(
  //                       padding: EdgeInsets.symmetric(vertical: 20),
  //                       child: RichText(
  //                         textAlign: TextAlign.center,
  //                         text: TextSpan(
  //                           style: TextStyle(
  //                             fontSize: 30,
  //                             fontFamily: 'FontMain',
  //                             fontWeight: FontWeight.w700,
  //                             color: Colors.black,
  //                           ),
  //                           children: [
  //                             TextSpan(text: 'Get Personalized\n'),
  //                             TextSpan(
  //                               text: 'Career Guidance',
  //                               style: TextStyle(color: Colors.red),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           // Dots indicator and navigation arrows
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   // if (_currentPage > 0) {
  //                   //   _pageController.previousPage(
  //                   //     duration: Duration(milliseconds: 500),
  //                   //     curve: Curves.ease,
  //                   //   );
  //                   // }
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(builder: (context) =>seceondCongratulationScreen()),
  //                   );
  //                 },
  //                 child: Image.asset("images/Arrowleft.png"),
  //               ),
  //               DotsIndicator(
  //                 dotsCount: 3,
  //                 position: _currentPage,
  //                 decorator: DotsDecorator(
  //                   color: Colors.grey,
  //                   activeColor: Colors.redAccent,
  //                   size: Size(11, 11),
  //                   activeSize: Size(20, 20),
  //                 ),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   // Navigate to SignIn page when on the last page (index 2)
  //                   if (_currentPage == 2) {
  //                     Navigator.pushReplacement(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => SignIn()),
  //                     );
  //                   }
  //                 },
  //                 child: Image.asset("images/Arrowright.png"),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Listen for horizontal swipes
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // Swiped right
            if (_currentPage > 0) {
              setState(() {
                _currentPage--;
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            }
          } else if (details.primaryDelta! < 0) {
            // Swiped left
            if (_currentPage < 2) {
              setState(() {
                _currentPage++;
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
              // Navigate to SignIn page when swiping to the last page
              if (_currentPage == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              }
            }
          }
        },
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              // onPageChanged: (int page) {
              //   setState(() {
              //     _currentPage = page;
              //   });
              // },
              children: [
                seceondCongratulationScreen(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/Hiremi_Icon.png'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('images/thirdCongratulation.png'),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 45),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'FontMain',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Get Personalized\n'),
                            TextSpan(
                              text: 'Career Guidance',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Dots indicator and navigation arrows
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      //   _pageController.previousPage(
                      //     duration: Duration(milliseconds: 300),
                      //     curve: Curves.ease,
                      //   );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => seceondCongratulationScreen(),
                          ));
                    },
                    child: Image.asset("images/Arrowleft.png"),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: 2,
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Colors.redAccent,
                      size: Size(11, 11),
                      activeSize: Size(20, 20),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Image.asset("images/Arrowright.png"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
