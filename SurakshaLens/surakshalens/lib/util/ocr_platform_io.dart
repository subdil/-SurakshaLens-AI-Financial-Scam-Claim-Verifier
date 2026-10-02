import 'dart:typed_data';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OcrPlatform {
  static Future<String> extractText(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/screenshot_ocr.jpg');
    await file.writeAsBytes(bytes);
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final inputImage = InputImage.fromFile(file);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognizedText.text;
  }
}
