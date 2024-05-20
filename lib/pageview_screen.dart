  import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
  import 'package:hiremi/signin.dart';
  import 'package:smooth_page_indicator/smooth_page_indicator.dart';
  import 'dart:convert';
  import 'dart:ui';
  
  import 'package:flutter/cupertino.dart';
  
  
  
  class PageViewScreen extends StatefulWidget {
    static String routeName = 'PageView-Screen';
  
    const PageViewScreen({Key? key}) : super(key: key);
  
    @override
    _PageViewScreenState createState() => _PageViewScreenState();
  }
  
  class _PageViewScreenState extends State<PageViewScreen> {
    final PageController _pageController = PageController();
    int currentPageIndex = 0;
  
    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollBehavior: const ScrollBehavior(),
                children: const [
                  Page1(),
                  Page2(),
                  Page3(),
                  SignIn(),
                ],
                onPageChanged: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            if (currentPageIndex != 3)

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //
              //    if(currentPageIndex == 2)
              //           {
              //             print(currentPageIndex);
              //             _pageController.animateToPage(
              //               1,
              //               duration: const Duration(milliseconds: 300),
              //               curve: Curves.ease,
              //             );
              //           }
              //         else if(currentPageIndex == 1)
              //         {
              //           print(currentPageIndex);
              //           _pageController.animateToPage(
              //             0,
              //             duration: const Duration(milliseconds: 300),
              //             curve: Curves.ease,
              //           );
              //         }
              //       },
              //       child: Image.asset("images/Arrowleft.png"),
              //     ),
              //     SmoothPageIndicator(
              //       controller: _pageController,
              //       count: 3,
              //       effect: const SlideEffect(
              //         activeDotColor: Colors.red,
              //       ),
              //       onDotClicked: (index) {
              //         _pageController.animateToPage(
              //           index,
              //           duration: const Duration(milliseconds: 300),
              //           curve: Curves.ease,
              //         );
              //       },
              //     ),
              //     InkWell(
              //       onTap: () {
              //         if (currentPageIndex == 1) {
              //           _pageController.animateToPage(
              //             2,
              //             duration: const Duration(milliseconds: 300),
              //             curve: Curves.ease,
              //           );
              //         }
              //         else if(currentPageIndex == 0){
              //           _pageController.animateToPage(
              //             1,
              //             duration: const Duration(milliseconds: 300),
              //             curve: Curves.ease,
              //           );
              //         }
              //         else if(currentPageIndex == 2){
              //           // _pageController.animateToPage(
              //           //   1,
              //           //   duration: const Duration(milliseconds: 300),
              //           //   curve: Curves.ease,
              //           // );
              //           Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(builder: (context) => SignIn(),));
              //         }
              //       },
              //       child: Image.asset("images/Arrowright.png"),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPageIndex != 0) // Condition to show left arrow on pages other than page 1
                    InkWell(
                      onTap: () {
                        if (currentPageIndex == 2) {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else if (currentPageIndex == 1) {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Image.asset("images/Arrowleft.png"),
                    ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const SlideEffect(
                      activeDotColor: Colors.red,
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  if (currentPageIndex != 2) // Condition to show right arrow on pages other than page 3
                    InkWell(
                      onTap: () {
                        if (currentPageIndex == 1) {
                          _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else if (currentPageIndex == 0) {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Image.asset("images/Arrowright.png"),
                    ),
                  // if (currentPageIndex == 2) // Condition to show right arrow on pages other than page 3
                  //   InkWell(
                  //     onTap: () {
                  //       if (currentPageIndex == 1) {
                  //         _pageController.animateToPage(
                  //          1,
                  //           duration: const Duration(milliseconds: 300),
                  //           curve: Curves.ease,
                  //         );
                  //       } else if (currentPageIndex == 0) {
                  //         _pageController.animateToPage(
                  //           3,
                  //           duration: const Duration(milliseconds: 300),
                  //           curve: Curves.ease,
                  //         );
                  //       }
                  //     },
                  //     child: Image.asset("images/Arrowright.png"),
                  //   ),
                  if (currentPageIndex == 2) // Condition to show right arrow on pages other than page 3
                    InkWell(
                      onTap: () {
                        // if (currentPageIndex == 1) {
                        //   _pageController.animateToPage(
                        //     1,
                        //     duration: const Duration(milliseconds: 300),
                        //     curve: Curves.ease,
                        //   );
                        // } else if (currentPageIndex == 0) {
                        //   _pageController.animateToPage(
                        //     3,
                        //     duration: const Duration(milliseconds: 300),
                        //     curve: Curves.ease,
                        //   );
                        // }
                        Navigator.pushReplacement(
                                          context,
                                           MaterialPageRoute(builder: (context) => SignIn(),));
                      },
                      child: Image.asset("images/Arrowright.png"),
                    ),

                ],
              ),







            const SizedBox(height: 20),
          ],
        ),
      );
    }
  }
  
  class Page1 extends StatelessWidget {
    const Page1({Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      double screenWidth=MediaQuery.of(context).size.width;
      double screenHeight=MediaQuery.of(context).size.height;
      return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: Image.asset('images/Hiremi_Icon.png'),
              ),
              Image.asset('images/FirstCongratulationScreen.png'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Let's Get Started !",
                  style: TextStyle(
                    fontSize: 23.5,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.red.shade900, Colors.red.shade500],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }
  }
  
  class Page2 extends StatelessWidget {
    const Page2({Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      double screenWidth=MediaQuery.of(context).size.width;
      double screenHeight=MediaQuery.of(context).size.height;
      return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset('images/Hiremi_Icon.png'),
              Image.asset('images/seceondCongratulations.png'),
              Align(
                alignment: Alignment.center,
                child: const Text(
                  "Discover Exclusive",
                  style: TextStyle(
                    fontSize:23.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  "Job Opportunities!",
                  style: TextStyle(
                    fontSize: 23.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }
  }
  
  class Page3 extends StatelessWidget {
    const Page3({Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      double screenWidth=MediaQuery.of(context).size.width;
      double screenHeight=MediaQuery.of(context).size.height;
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: Image.asset('images/Hiremi_Icon.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 21.0),
              child: SizedBox(
                height: screenHeight*0.43,
                width: screenWidth*0.9,
                child: Image.asset('images/thirdCongratulation.png'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Get Personalized",
                style: TextStyle(
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "Career Guidance!",
              style: TextStyle(
                fontSize: 23.5,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }
  }
  
  
