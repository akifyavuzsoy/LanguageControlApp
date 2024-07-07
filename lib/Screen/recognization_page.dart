import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  bool isMatchFound = false;
  bool isComparisonDone = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recognized Page")),
      body: Stack(
        children: [
          _isBusy
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              maxLines: MediaQuery.of(context).size.height.toInt(),
              controller: controller,
              decoration:
              const InputDecoration(hintText: "Text goes here..."),
            ),
          ),
          if (isComparisonDone)
            Positioned(
              top: 16,
              left: 280,
              child: Icon(
                isMatchFound ? Icons.check : Icons.close,
                color: isMatchFound ? Colors.green : Colors.red,
                size: 100,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          compareTextWithExcel();
        },
        tooltip: 'Compare',
        label: const Text("Compare To Excel"),
      ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      _isBusy = true;
    });
    log(image.filePath!);
    final RecognizedText recognizedText = await textRecognizer.processImage(image);
    controller.text = recognizedText.text;
    setState(() {
      _isBusy = false;
    });
  }

  void compareTextWithExcel() async {
    // Alınan text
    log(controller.text);
    String recognizedText = controller.text;

    setState(() {
      isMatchFound = false; // Eşleşme bulunmadı, durumu güncelle
      isComparisonDone = false; // Karşılaştırma yapılıyor
    });

    ByteData data = await rootBundle.load('assets/languages.xlsx');
    var bytes = data.buffer.asUint8List();

    // Excel'i aç
    var excel = Excel.decodeBytes(bytes);

    // Excel dosyasındaki verileri karşılaştırma
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows) {
        for (var cell in row) {
          //if (cell != null && cell.value.toString().contains("Riscaldamento")) {
            //log('${cell.value}');
          //}
          if (cell != null && cell.value.toString() == recognizedText) {
            log('Eşleşen veri bulundu: ${cell.value}');
            setState(() {
              isMatchFound = true; // Eşleşme bulundu, durumu güncelle
              isComparisonDone = true; // Karşılaştırma tamamlandı
            });
            break; // Eşleşme bulunduğunda döngüyü kır
          }
        }
        if (isMatchFound) break; // Eşleşme bulunduğunda döngüyü kır
      }
      if (isMatchFound) break; // Eşleşme bulunduğunda döngüyü kır
    }

    setState(() {
      isComparisonDone = true; // Karşılaştırma tamamlandı
    });
  }
}
