import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tflite_test/utils/settings.dart';

class Callpage extends StatefulWidget {
  final String channelName;

  final ClientRole role;

  const Callpage({Key key, this.role, this.channelName}) : super(key: key);

  @override
  State<Callpage> createState() => _CallpageState();
}

class _CallpageState extends State<Callpage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPannel = false;
  RtcEngine _engine  ;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    connectionvia();
    fToast = FToast();
    fToast.init(context);
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  void connectionvia() async{
    var status = await Connectivity().checkConnectivity();
    switch (status) {
      case ConnectivityResult.wifi:
        fToast.showToast(
          child: Icon(Icons.wifi,color: Colors.tealAccent,),
          toastDuration: Duration(seconds: 5),
          gravity:ToastGravity.CENTER

        );
        break;
      case ConnectivityResult.mobile:
        fToast.showToast(
          child: Row(
            children: [
              Icon(Icons.four_g_mobiledata_outlined,color: Colors.tealAccent,),
              Icon(Icons.wifi,color: Colors.tealAccent,)
            ],
          ),
            gravity:ToastGravity.CENTER,
          toastDuration: Duration(seconds: 5),
        );
        break;
      case ConnectivityResult.none:
        fToast.showToast(
          child: Icon(Icons.wifi_off_sharp,color: Colors.tealAccent,),
    gravity:ToastGravity.CENTER,
          toastDuration: Duration(seconds: 5),
        );        break;
    }
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
            "App id is missing , please provide your app_id in settings.dart");
        _infoStrings.add("Agora engine is not starting");
      });
      return;
    }
    // initagoraRtcEngine

    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    //! addAgoraEventHandlers
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, widget.channelName, null, 0);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = "error: ${code}";
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'join channel: $channel uid: $uid ';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('leave channel');
        _users.clear();
      });
    }, userJoined: (uid, elpased) {
      setState(() {
        final info = "user joind : $uid";
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elpased) {
      setState(() {
        final info = "user offline : $uid";
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = "first remote video: $uid ${width} X ${height} ";
        _infoStrings.add(info);
      });
    }));
  }


  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(const rtc_local_view.SurfaceView());
    }
    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: widget.channelName,
      ));
    }
    final views = list;
    return Column(
        children: List.generate(
      views.length,
      (index) => Expanded(
        child: views[index],
      ), // Expanded), // List.generate
    ));
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              setState(() {
                muted = !muted;
              });
              _engine.muteLocalAudioStream(muted);
            },
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            // Icon
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            // Icon
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
              onPressed: () {
                _engine.switchCamera();
              },
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              // Icon
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0)) // RawMaterialButton
        ],
      ),
    );
  }

  Widget _panel() {
    return Visibility(
      visible: viewPannel,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: _infoStrings.length,
              itemBuilder: (BuildContext context, int index) {
                if (_infoStrings.isEmpty) {
                  return const Text("no info");
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Container(
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ))
                    ],
                  ),
                );
              },
            ), // Listview.builder
          ), // Container
        ), // FractionallysizedBox
      ), // Container
    ); // Visibility
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Talk"),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          setState(() {
            viewPannel=!viewPannel;
          });
        }, icon: const Icon(Icons.info_outline) )],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Stack(children: <Widget>[
        _viewRows(),
        _panel(),
        _toolbar()

        ],)),
    );
  }
}
