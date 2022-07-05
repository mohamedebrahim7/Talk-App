import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import '../provider/myprovier.dart';
import '../screens/home_screen.dart';

class ImageClassifier extends StatefulWidget {
  final String model ;

  ImageClassifier(this.model, this.label);

  final String label ;

  @override
  _ImageClassifierState createState() => _ImageClassifierState();
}

class _ImageClassifierState extends State<ImageClassifier> {
  var size, height, width;
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;
  final FlutterTts tts = FlutterTts();

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {});
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
    );

    setState(() {
      _loading = false;
      _output = output;
     // print(_output);
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: widget.model,
      labels: widget.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(
      child: Scaffold(
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
            children: <Widget>[
              SizedBox(height: height * 0.05),
              Container(
                // padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.01),
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: width*0.7,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: height*0.3,
                                        width: width,
                                        child: Icon(Icons.wallpaper,size:width*0.5 ,)),
                                    SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _image,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _output != null
                                        ? Column(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Card(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            children: [
                                                              //  Text(predOne),Text(confidence.toStringAsFixed(2)),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      _output[0]
                                                                          [
                                                                          'label'],
                                                                      // 'Apple',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 16.0,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 8,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          32.0,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          LinearProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(Color(0xff6200EE)),
                                                                            value:
                                                                                _output[0]['confidence'],
                                                                            backgroundColor:
                                                                                Colors.grey.withOpacity(0.2),
                                                                            minHeight:
                                                                                50.0,
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Text(
                                                                              (_output[0]['confidence'] * 100).toStringAsFixed(2),
                                                                              //'${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Provider.of<CounterModel>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .add(_output[0]
                                                                              [
                                                                              'label']);
                                                                      txt.text = Provider.of<CounterModel>(
                                                                              context,
                                                                              listen: false)
                                                                          .text;
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .add_circle_outlined),
                                                                    color: Color(
                                                                        0xff6200EE),
                                                                  ),
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

                                            _output.length==2 ?  Container(
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Card(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            children: [
                                                              //  Text(predOne),Text(confidence.toStringAsFixed(2)),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      _output[1]
                                                                          [
                                                                          'label'],
                                                                      // 'Apple',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 16.0,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 8,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          32.0,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          LinearProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(Color(0xff6200EE)),
                                                                            value:
                                                                                _output[1]['confidence'],
                                                                            backgroundColor:
                                                                                Colors.grey.withOpacity(0.2),
                                                                            minHeight:
                                                                                50.0,
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Text(
                                                                              (_output[1]['confidence'] * 100).toStringAsFixed(2),
                                                                              //'${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Provider.of<CounterModel>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .add(_output[1]
                                                                              [
                                                                              'label']);
                                                                      txt.text = Provider.of<CounterModel>(
                                                                              context,
                                                                              listen: false)
                                                                          .text;
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .add_circle_outlined),
                                                                    color: Color(
                                                                        0xff6200EE),
                                                                  ),
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
                                              ): Container(),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(height: height * 0.01),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: pickImage,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "From Camera ",
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.photo_camera, size: 14),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: pickGalleryImage,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "From Gallery ",
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.photo, size: 14),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
