import 'package:flutter/material.dart';
class CustomDialogBox extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onOkPressed;

  CustomDialogBox({
    required this.title,
    required this.message,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: [
        Column(
          children: [
            SizedBox(height: 30,),
            Center(child: Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "FontMain",
                fontSize: 18,
                color: Color(0xFFBD232B),
              ),)),
            SizedBox(height: 35,),
            ElevatedButton(
              onPressed: () {
                // Pop the current route (the AlertDialog)
                Navigator.of(context).pop();

                // Navigate to the HomePage

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF13640),
                minimumSize: Size(250, 50),
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
        )
      ],
    );
  }
}

