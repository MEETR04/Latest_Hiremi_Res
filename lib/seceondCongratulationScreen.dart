import 'package:flutter/material.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hiremi/firstCongratulationScreen.dart';
import 'package:hiremi/threeCongratulationScreen.dart';


class seceondCongratulationScreen extends StatefulWidget {
  const seceondCongratulationScreen({super.key});

  @override
  State<seceondCongratulationScreen> createState() => _seceondCongratulationScreenState();
}

class _seceondCongratulationScreenState extends State<seceondCongratulationScreen> {
  void initState() {
    super.initState();

  }

  int _currentPage = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _navigateToNextScreen(int nextPage) {
    if (nextPage == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => firstCongratulationScreen()),
      );
    } else if (nextPage == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => thirdCongratulationScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // Swiped right
            if (_currentPage > 0) {
              setState(() {
                _currentPage--;
              });
              _pageController.animateToPage(
                _currentPage,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          } else if (details.primaryDelta! < 0) {
            // Swiped left
            if (_currentPage < 2) {
              setState(() {
                _currentPage++;
              });
              _pageController.animateToPage(
                _currentPage,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              // Check if we should navigate to the next screen
              if (_currentPage == 2) {
                _navigateToNextScreen(_currentPage);
              }
            }
          }
        },
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Page 0 (firstCongratulationScreen)
                firstCongratulationScreen(),
                // Page 1 (secondCongratulationScreen)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/Hiremi_Icon.png'),
                    Image.asset('images/seceondCongratulations.png'),
                    SizedBox(height: screenHeight*0.01),
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
                            TextSpan(text: 'Exclusive\n'),
                            TextSpan(
                              text: 'Job Opportunities',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // if (_currentPage > 0) {
                            //   setState(() {
                            //     _currentPage--;
                            //   });
                            //   _pageController.previousPage(
                            //     duration: Duration(milliseconds: 300),
                            //     curve: Curves.ease,
                            //   );
                            // }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => firstCongratulationScreen()),
                            );
                          },
                          child: Image.asset("images/Arrowleft.png"),
                        ),
                        DotsIndicator(
                          dotsCount: 3,
                          position: _currentPage,
                          decorator: DotsDecorator(
                            color: Colors.grey,
                            activeColor: Colors.redAccent,
                            size: Size(11, 11),
                            activeSize: Size(20, 20),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // if (_currentPage < 2) {
                            //   setState(() {
                            //     _currentPage++;
                            //   });
                            //   _pageController.nextPage(
                            //     duration: Duration(milliseconds: 300),
                            //     curve: Curves.ease,
                            //   );
                            //   if (_currentPage == 2) {
                            //     _navigateToNextScreen(2);
                            //   }
                            // }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => thirdCongratulationScreen()),
                            );
                          },
                          child: Image.asset("images/Arrowright.png"),
                        ),
                      ],
                    ),
                  ],
                ),
                // Page 2 (thirdCongratulationScreen)
                thirdCongratulationScreen(),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
