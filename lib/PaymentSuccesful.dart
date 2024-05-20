import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';

class PaymentSuccesful extends StatefulWidget {
  const PaymentSuccesful({super.key});

  @override
  State<PaymentSuccesful> createState() => _PaymentSuccesfulState();
}

class _PaymentSuccesfulState extends State<PaymentSuccesful> {
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Stack(

          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF13640), Color(0xFF8E3E42)],
                      stops: [0.1454, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 280.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image.asset("images/whitetick.png"),
                        Text(
                          "Payment successful",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'FontMain',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),// Example background color
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.6, // Position at the bottom half of the screen
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                      stops: [0.1454, 1.0],
                    ),

                  ),
                  child:Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                     Image.asset("images/greentick.png"),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      Text(
                        "Thank You for your verification",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'FontMain',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: (
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            //   return HomePage(sourceScreen: '', uid: uid, username: '', verificationId: ID2,);
                            // }
                            // ),);
                            ) {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          //   return HomePage(sourceScreen: 'Screen1', uid: uid, username: '', verificationId: ID2,);
                          // }
                          // ),);
                          // Add your onPressed callback function here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.redAccent, // Text color
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        child:  Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'FontMain',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )

                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /2, // Half of the screen height
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
