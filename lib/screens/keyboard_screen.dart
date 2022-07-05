import 'package:flutter/material.dart';
import 'package:tflite_test/keyboard_screens/build_keyboard.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key key}) : super(key: key);
  static const Map<String,String> numbersImgSrc = {
    'assets/numbers/0.gif': '0',
    'assets/numbers/1.gif': '1',
    'assets/numbers/2.gif': '2',
    'assets/numbers/3.gif': '3',
    'assets/numbers/4.gif': '4',
    'assets/numbers/5.gif': '5',
    'assets/numbers/6.gif': '6',
    'assets/numbers/7.gif': '7',
    'assets/numbers/8.gif': '8',
    'assets/numbers/9.gif': '9',
    'assets/numbers/10.gif': '10',
  };
  static const Map<String,String> familyImgSrc = {
    'assets/family/0.gif': 'الاسره ',
    'assets/family/1.gif': 'اب ',
    'assets/family/2.gif': 'ام ',
    'assets/family/3.gif': 'اخ ',
    'assets/family/4.gif': 'اخت ',
    'assets/family/5.gif': 'جد ',
  };
  static const Map<String,String> acquaintanceImgSrc = {
    'assets/acquaintance/0.gif': 'السلام عليكم ',
    'assets/acquaintance/1.gif': 'اين تسكن؟ ',
    'assets/acquaintance/2.gif': 'اين تعمل؟ ',
    'assets/acquaintance/3.gif': 'اين مكانك؟ ',
  };
  static const Map<String,String> alphabetImgSrc = {
    'assets/alphabet/1.gif': 'ا',
    'assets/alphabet/2.gif': 'ب',
    'assets/alphabet/3.gif': 'ت',
    'assets/alphabet/4.gif': 'ث',
    'assets/alphabet/5.gif': 'ج',
    'assets/alphabet/6.gif':'ح',
    'assets/alphabet/7.gif':'خ',
    'assets/alphabet/8.gif':'د',
    'assets/alphabet/9.gif':'ذ',
    'assets/alphabet/10.gif':'ر',
    'assets/alphabet/11.gif':'ز',
    'assets/alphabet/12.gif':'س',
    'assets/alphabet/13.gif':'ش',
    'assets/alphabet/14.gif':'ص',
    'assets/alphabet/15.gif':'ض',
    'assets/alphabet/16.gif':'ط',
    'assets/alphabet/17.gif':'ظ',
    'assets/alphabet/18.gif':'ع',
    'assets/alphabet/19.gif':'غ',
    'assets/alphabet/20.gif':'ف',
    'assets/alphabet/21.gif':'ق',
    'assets/alphabet/22.gif':'ك',
    'assets/alphabet/23.gif':'ل',
    'assets/alphabet/24.gif':'م',
    'assets/alphabet/25.gif':'ن',
    'assets/alphabet/26.gif':'ه',
    'assets/alphabet/27.gif':'و',
    'assets/alphabet/28.gif':'لا',
    'assets/alphabet/29.gif':'ي',
    'assets/alphabet/30.gif':'ة',
    'assets/alphabet/31.gif':'ال',
    'assets/alphabet/32.gif':'ء',
    'assets/alphabet/33.gif':'أ',
    'assets/alphabet/34.gif':'ئ',
    'assets/alphabet/35.png':' ',
  };


  @override
  Widget build(BuildContext context) {
    // 3
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffbb86fc),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    //text: 'Incoming',
                    icon: Icon(Icons.sort_by_alpha),
                  ),
                  Tab(
                    //  text: 'Incoming',
                    icon: Icon(Icons.looks_one),
                  ),
                  Tab(
                    //  text: 'Incoming',
                    icon: Icon(Icons.family_restroom),
                  ),
                  Tab(
                    //  text: 'Incoming',
                    icon: Icon(Icons.chat_outlined),
                  )
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BuildKeyboard(imgSrc: alphabetImgSrc),
            BuildKeyboard(imgSrc: numbersImgSrc),
            BuildKeyboard(imgSrc: familyImgSrc),
            BuildKeyboard(imgSrc:acquaintanceImgSrc ),

          ],
        ),
      ),
    );
  }
}

