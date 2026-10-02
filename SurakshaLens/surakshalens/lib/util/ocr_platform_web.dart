import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

@JS('ocrImageBase64')
external JSPromise<JSString> _ocrImageBase64(JSString base64);

class OcrPlatform {
  static Future<String> extractText(Uint8List bytes) async {
    final result =
        await _ocrImageBase64(base64Encode(bytes).toJS).toDart;
    return result.toDart;
  }
}
