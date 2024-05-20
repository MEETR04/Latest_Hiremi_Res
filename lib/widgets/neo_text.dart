import 'package:flutter/material.dart';

class CustomTextWidget extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;


  CustomTextWidget({
    required this.text,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
  });

  @override
  State<CustomTextWidget> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        color: widget.color,
        fontFamily: "FontMain"
      ),
      textAlign: widget.textAlign,
    );

  }
}