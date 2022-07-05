import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key}) : super(key: key);
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff202020),
        title: Center(
          child: Text(
            "Talk",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: height * 0.03),
          ),
        ),
      ),
      body: SafeArea(child:
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              "This app for those with hearing disabilities to help them communicate with other...",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: height * 0.03),

            ),
        SizedBox(height: height*0.25,),
        Text("* Introductory video will be added soon *",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: height * 0.03),
            ),
          ],
        ),
      )
      ),
    );
  }
}
