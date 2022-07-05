import 'package:flutter/material.dart';
import 'package:tflite_test/keyboard_screens/itemtile_widget.dart';

class BuildKeyboard extends StatelessWidget {
  const BuildKeyboard({Key key, this.imgSrc}) : super(key: key);

  final Map<String,String> imgSrc ;


  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      itemCount: imgSrc.length,
      itemBuilder: (context, index) => ItemTileWidget(imgSrc.keys.elementAt(index),imgSrc.values.elementAt(index)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
    );
  }
}

