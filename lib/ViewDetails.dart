import 'package:flutter/material.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key, required index});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
            child:Column(
              children: [
               Image.asset('images/Back_Button.png'),
              ],
            ),
      ),
    );
  }
}
