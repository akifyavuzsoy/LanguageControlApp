import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ocr/Screen/recognization_page.dart';
import 'package:flutter_ocr/Utils/image_cropper_page.dart';
import 'package:flutter_ocr/Utils/image_picker_class.dart';
import 'package:flutter_ocr/Widgets/modal_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Languages Compare'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to The Language Control Application',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // Diğer stil özellikleri de buraya eklenebilir
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 40,
            child: Text(
              'BEKO',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 12,
            child: Text(
              'by Akif Yavuzsoy',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            log("Camera");
            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            log("Gallery");
            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          });
        },
        tooltip: 'Increment',
        label: const Text("Scan photo"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
