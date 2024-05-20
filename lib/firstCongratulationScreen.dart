import 'package:flutter/material.dart';
import 'package:hiremi/seceondCongratulationScreen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hiremi/threeCongratulationScreen.dart';

class firstCongratulationScreen extends StatefulWidget {
  const firstCongratulationScreen({super.key});

  @override
  State<firstCongratulationScreen> createState() => _firstCongratulationScreenState();
}

class _firstCongratulationScreenState extends State<firstCongratulationScreen> {
  void initState() {
    super.initState();
    // Delay navigation to the next screen after 3 seconds
    // Future.delayed(Duration(seconds: 1), () {
    //   // Navigate to the next screen (replace NextScreen() with your desired screen)
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => seceondCongratulationScreen()),
    //   );
    // });
  }

  int _currentPage = 0;
  int _selectedItems = 0;
  var pages = [
    firstCongratulationScreen(),
    seceondCongratulationScreen(),
    thirdCongratulationScreen()
  ];
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (_currentPage == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => seceondCongratulationScreen()),
      );
    } else if (_currentPage == 2) {
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
        // Listen for horizontal swipes
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // Swiped right
            if (_currentPage > 0) {
              setState(() {
                _currentPage--;
              });
            }
          } else if (details.primaryDelta! < 0) {
            // Swiped left
            if (_currentPage < 2) {
              setState(() {
                _currentPage++;
              });
            }
            // Check if we should navigate to the next screen
            if (_currentPage == 1 || _currentPage == 2) {
              _navigateToNextScreen();
            }
          }
        },

        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
              Column(
                children: [
                  Image.asset('images/Hiremi_Icon.png'),
                  Image.asset('images/FirstCongratulationScreen.png'),
                  SizedBox(height: screenHeight*0.01),
                  Text(
                    "Let’s get started!",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'FontMain',
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // DotsIndicator(
                      //   dotsCount: 3,
                      //   position: _currentPage.toDouble().toInt(),
                      //   decorator: DotsDecorator(
                      //     color: Colors.grey, // Inactive color
                      //     activeColor: Colors.redAccent, // Active color
                      //     size: Size(11, 11), // Adjust the size of the dots here
                      //     activeSize: Size(20, 20), // Adjust the size of the active dot
                      //   ),
                      // ),
                      InkWell(
                          onTap:(){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => seceondCongratulationScreen()),
                            );
                          } ,
                          child: Image.asset("images/Arrowright.png")),
                    ],
                  ),
                ],
              ),

              ],
            ),


          ],
        ),
      ),
    );
  }

}

