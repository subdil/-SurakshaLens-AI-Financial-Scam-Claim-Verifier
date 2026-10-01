import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<Map<String, dynamic>> analyzeText(
    String message,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/analyze/text'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    final error = jsonDecode(response.body);

    throw Exception(
      error['message'] ?? 'Unable to analyze message.',
    );
  }
}