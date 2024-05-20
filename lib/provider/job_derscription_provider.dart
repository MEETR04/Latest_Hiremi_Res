import 'package:flutter/material.dart';

class CheckboxModel extends ChangeNotifier {
  bool isChecked = false;

  void toggleCheckbox(bool value) {
    isChecked = value;
    notifyListeners();
  }
}
