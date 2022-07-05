import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_test/ImageClassfiction_screens/card_theme.dart';
import 'package:tflite_test/livecam_screens/call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole _role = ClientRole.Broadcaster;
  var size,height,width;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }
  Future<void> onJoin() async{

    setState(() {
      _channelController.text.isEmpty ? _validateError=true : _validateError=false;
    });

    if(_channelController.text.isNotEmpty){
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Callpage(channelName: _channelController.text,role: _role,)),
      );
    }
  }
  Future<void> _handleCameraAndMic(Permission permission) async{
    final status = await permission.request();
     print( status.toString());
   // log(status.toString());
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              height: height*0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset("assets/UI/live.gif"),
              ),
            ),
            const SizedBox(height: 10,),

            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: _validateError ? 'channel name is needed ': null,
                border: UnderlineInputBorder(),
              hintText: 'Channel name '
              ),
            ),
            const SizedBox(height: 10,),
            RadioListTile(
              title: const Text('broacaster'),
              onChanged: (ClientRole value){
                setState(() {
                  _role=value;
                });
              },
              value: ClientRole.Broadcaster,
              groupValue: _role,
            ),
            RadioListTile(
              title: const Text('audience'),
              onChanged: (ClientRole value){
                setState(() {
                  _role=value;
                });
              },
              value: ClientRole.Audience,
              groupValue: _role,
            ),
            ElevatedButton(onPressed: onJoin, child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Join ",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.video_call, size: 14),
                  ),

                ],
              ),
            )  )

          ],
        ),
      ),
    );
  }

}
