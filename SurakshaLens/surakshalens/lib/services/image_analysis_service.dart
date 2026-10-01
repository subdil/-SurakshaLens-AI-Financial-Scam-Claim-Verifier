import 'dart:convert';

import 'package:http/http.dart' as http;

class ImageAnalysisService {
  static const String baseUrl =
      'http://localhost:5000';

  static Future<Map<String, dynamic>>
      analyzeImage(
    List<int> imageBytes,
    String fileName,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '$baseUrl/api/analyze/image',
      ),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: fileName,
      ),
    );

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
      streamedResponse,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ??
          'Unable to analyze image.',
    );
  }
}