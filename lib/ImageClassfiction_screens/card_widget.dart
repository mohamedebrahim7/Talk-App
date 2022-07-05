
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'card_theme.dart';

class BuildCard extends StatelessWidget {
  final VoidCallback callback1 , callback2;
  final String cardName , imgSrc ;
  var size,height,width;

  BuildCard(this.callback1, this.callback2, this.cardName, this.imgSrc);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final CardThumbnail = new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 24.0),
      child:  CircleAvatar(
        radius: 50,
        backgroundImage:AssetImage(imgSrc) ,
      ),
    );

    final MyCard = Container(
      margin: const EdgeInsets.only(left: 72.0, right: 24.0),
      decoration: new BoxDecoration(
        color: Colorss.planetCard,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(color: Colors.black,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0))
        ],
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(cardName, style: TextStyles.planetTitle),
            new Container(
                color: const Color(0xFF00C6FF),
                width: 24.0,
                height: 1.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0)
            ),
            SizedBox(height: 5,),
            OutlinedButton(
              onPressed: callback1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                new Icon(Icons.photo_camera_front, size: 20.0,
                    color: Colorss.planetDistance),
                new Text(
                    'Live Camera', style: TextStyles.planetDistance),
              ],),
            ),
            OutlinedButton(
              onPressed: callback2,
              child: Row(
               mainAxisSize: MainAxisSize.min,
                children: [
                new Icon(Icons.image, size: 20.0,
                    color: Colorss.planetDistance),
                new Text(
                    'Image capture', style: TextStyles.planetDistance),
              ],),
            )
          ],
        ),
      ),
    );

    return new Container(
      height:height*0.25,
      width: width,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: new Stack(
        children: <Widget>[
          MyCard,
          CardThumbnail,
        ],
      ),
    );

  }


}
