import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_test/ImageClassfiction_screens/camera_widget.dart';

import '../provider/myprovier.dart';
import '../screens/home_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Camera_screen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String model, labels;

  Camera_screen({this.cameras, this.model, this.labels});

  @override
  _Camera_screenState createState() => _Camera_screenState();
}

class _Camera_screenState extends State<Camera_screen> {
  var size, height, width;
  String predOne = '', predTwo = '';
  double confidence = 0, confidence2 = 0;
  bool enableButton = true ;
  final FlutterTts tts = FlutterTts();


  @override
  void initState() {
    super.initState();
    loadTfliteModel();
    tts.setLanguage("ar");

  }

  loadTfliteModel() async {
    String res;
    res = await Tflite.loadModel(model: widget.model, labels: widget.labels);
  }

  setRecognitions(outputs) {
    List<dynamic> mylist = outputs;
    print(outputs);

    setState(() {

      predOne = mylist[0]['label'];
      confidence = mylist[0]['confidence'];
   /*   print("value 1*********8");
      print(predOne);
      print(confidence);
      print("fdddddddddddddddddddddd");*/

      if (mylist.length == 2) {
        predTwo = mylist[1]['label'];
        confidence2 = mylist[1]['confidence'];
        enableButton=true;
    /*    print("value 2 found *********");
        print(predTwo);
        print(confidence2);
        print("fdddddddddddddddddddddd");*/
      } else {
        predTwo = "-";
        confidence2 = 0.0;
        enableButton=false;
       /* print("value 2 not found *********");
        print(predTwo);
        print(confidence2);
        print("fdddddddddddddddddddddd");*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
     // backgroundColor: Colors.blueGrey,
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
                          onPressed: (){
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Camera(widget.cameras, setRecognitions),
            Container(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //  Text(predOne),Text(confidence.toStringAsFixed(2)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    predOne,
                                    // 'Apple',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                    height: 32.0,
                                    child: Stack(
                                      children: [
                                        LinearProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xff6200EE)),
                                          value: confidence,
                                          backgroundColor: Colors.grey
                                              .withOpacity(0.2),
                                          minHeight: 50.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            (confidence * 100)
                                                .toStringAsFixed(2),
                                            //'${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Provider.of<CounterModel>(context, listen: false).add(predOne);
                                      txt.text = Provider.of<CounterModel>(context, listen: false).text;
                                    },
                                    icon: Icon(Icons.add_circle_outlined),color: Color(0xff6200EE),),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Container(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //  Text(predOne),Text(confidence.toStringAsFixed(2)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    predTwo,
                                    // 'Apple',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                    height: 32.0,
                                    child: Stack(
                                      children: [
                                        LinearProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xff6200EE)),
                                          value: confidence2,
                                          backgroundColor: Colors.grey
                                              .withOpacity(0.2),
                                          minHeight: 50.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            (confidence2 * 100)
                                                .toStringAsFixed(2),
                                            //'${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if(enableButton){
                                        Provider.of<CounterModel>(context, listen: false).add(predTwo);
                                        txt.text = Provider.of<CounterModel>(context, listen: false).text;}
                                    },
                                    icon: Icon(Icons.add_circle_outlined),color: Color(0xff6200EE),),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
