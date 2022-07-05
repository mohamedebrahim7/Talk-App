import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_test/ImageClassfiction_screens/camera_screen.dart';
import 'package:tflite_test/ImageClassfiction_screens/card_widget.dart';
import '../ImageClassfiction_screens/image_screen.dart';

class Models extends StatelessWidget {
  var size, height, width;
  final List<CameraDescription> cameras;

  Models(this.cameras, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          BuildCard(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => Camera_screen(
                            cameras: cameras,
                            model: 'assets/mobilenet_v2.tflite',
                            labels: 'assets/labels.txt')),
                  ),

                  ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ImageClassifier(
                       'assets/mobilenet_v2.tflite','assets/labels.txt'
                  ))),
              "Alphabet",
              "assets/UI/alpha.webp"),

          BuildCard(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => Camera_screen(
                            cameras: cameras,
                            model: 'assets/num_model.tflite',
                            labels: 'assets/num_labels.txt')),
                  ),

                  ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ImageClassifier(
                       'assets/num_model.tflite','assets/num_labels.txt'
                  ))),
              "Numbers",
              "assets/UI/number.gif"),

        ],
      ),
    );


  }
}
