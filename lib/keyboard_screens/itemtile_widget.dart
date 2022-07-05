
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/myprovier.dart';
import '../screens/home_screen.dart';

class ItemTileWidget extends StatelessWidget {
  final String image_src,imgText;

  const ItemTileWidget(
      this.image_src,  this.imgText,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<CounterModel>(context,
            listen: false).add(imgText);
        txt.text = Provider.of<CounterModel>(
            context,
            listen: false)
            .text;
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(image_src)),
      ),
    );
  }
}
