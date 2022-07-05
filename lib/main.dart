import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tflite_test/provider/myprovier.dart';
import 'package:tflite_test/screens/home_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: MaterialApp(
          theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
        ),
          debugShowCheckedModeBanner: false,
          home:MyHomePage(cameras)      )
  ));
  // MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage(cameras: cameras,)));
}


