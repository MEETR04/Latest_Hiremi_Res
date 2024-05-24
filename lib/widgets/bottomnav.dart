import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/Settings.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _currentindex = 0;
  final List<Widget> _pages = [
    const HomePage(sourceScreen: "sourceScreen", uid: "uid", username: "username", verificationId: "verificationId"),
    const Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentindex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.grey.shade300,
        height: 60,
        items: const [
          Icon(Icons.home,color: Colors.redAccent,size: 40,),
          Icon(Icons.settings, color: Colors.redAccent,size: 40,),
        ],
        onTap: (index){
          setState(() {
            _currentindex = index;
          });
        },

      ),
    );
  }
}
