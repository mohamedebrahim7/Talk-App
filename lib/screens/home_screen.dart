import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:tflite_test/ImageClassfiction_screens/card_theme.dart';
import 'package:tflite_test/screens/info_screen.dart';
import '../main.dart';
import '../provider/myprovier.dart';
import 'keyboard_screen.dart';
import 'model_screen.dart';
import 'live_cam.dart';

var txt = TextEditingController();
class MyHomePage extends StatefulWidget {
   List<CameraDescription> cameras;
  MyHomePage(this.cameras);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var size,height,width;
  final FlutterTts tts = FlutterTts();
  FToast fToast;
  bool _isFirstCall = false;

  void initState() {
    super.initState();
    tts.setLanguage("ar");
    fToast = FToast();
    fToast.init(context);
  _checkFirstCall();
  }

  void _checkFirstCall() async {
    bool ifc = await IsFirstRun.isFirstCall();
    setState(() {
      _isFirstCall = ifc;
    });
  }

  static List<Widget> pages = <Widget>[
    Models(cameras), Keyboard(),LiveCam()];

  void _onItemTapped(int index) {
    setState(() {
      var i = _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        appBar: AppBar(
           backgroundColor: Color(0xff202020),
          title: Column(
           // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Talk",style: TextStyle(fontWeight: FontWeight.bold,fontSize: height*0.03),),
                  IconButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoPage()),
                    );
                  }, icon: Icon(Icons.info,),)
                ],
              ),
              SizedBox(height: height*0.01,),// 1% padding
              Consumer<CounterModel>(builder: (_, value, __) {
                return TextField(
                  readOnly: true,
                  showCursor: true,
                  restorationId: 'life_story_field',
                  controller: txt,
                  //  focusNode: _lifeStory,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "hint text",

                    // helperText: "helper text",
                    labelText: "label text",
                suffixIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                    onPressed: ()  {
                      if(_isFirstCall){
                        Fluttertoast.showToast(
                            msg: "This service needs Internet for the first time.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                          fontSize: height*0.03
                        );
                        // and update the UI
                        setState(() {
                          _isFirstCall=false ;
                        });                      }
                      tts.speak(txt.text);

                    } ,
                    icon: Icon(Icons.volume_up_sharp)),
                    InkWell(
                      onLongPress: (){
                        value.clearall();
                        txt.text=value.text ;
                      },
                      onTap: (){
                        value.clear();
                        txt.text=value.text ;
                      },
                      child:Icon(Icons.label_sharp,) ,
                    ),
                  ],
                ),

                ),
                  onChanged: (newstr){
                    value.text= newstr;
                  },
                  maxLines: 3,
                );
              }),
            ],
          ),
          toolbarHeight: height*0.25, // talk 25% of height

        ),
        body: SafeArea(
          child: pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
         // backgroundColor: Color(0xff92b2fd)#202020,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.linked_camera_outlined),
              label: 'Capture',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.keyboard),
              label: 'Keyboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.live_tv),
              label: 'Live cam',
            ),
          ],
        ));
  }
}
