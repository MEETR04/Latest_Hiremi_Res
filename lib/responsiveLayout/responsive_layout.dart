import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget WebScreenLayout;
  const ResponsiveLayout({super.key, required this.mobileScreenLayout, required this.WebScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder:(context,constraints){
          if(constraints.maxWidth>900){
         return WebScreenLayout;
          }
         return mobileScreenLayout;
        },
    );
  }
}
