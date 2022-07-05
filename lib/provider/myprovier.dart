import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  String text = "";
  void add(String s) {
    text+= s;
    notifyListeners();
  }
  void clear() {
    if(text.isNotEmpty)
   text= text.substring(0, text.length - 1);

   notifyListeners();
  }
  void clearall() {
    if(text.isNotEmpty)
   text="";
   notifyListeners();
  }


}