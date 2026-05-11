import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiKeyException implements Exception {
  final String message;
  const ApiKeyException(this.message);
}

class GeminiService {
  final String apiKey;

  const GeminiService(this.apiKey);

  Future<String> generateResponse(
    List<Map<String, dynamic>> history,
  ) async {
    final url = Uri.parse(
      '${Config.geminiBaseUrl}/${Config.geminiModel}:generateContent?key=$apiKey',
    );

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'contents': history}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('No response from Gemini');
      }
      final parts =
          (candidates[0]['content'] as Map<String, dynamic>?)?['parts']
              as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      return (parts[0]['text'] as String?)?.trim() ?? '';
    }

    final errorData = jsonDecode(response.body) as Map<String, dynamic>;
    final apiMessage =
        (errorData['error'] as Map<String, dynamic>?)?['message'] as String? ??
            'Unknown error';

    if (response.statusCode == 400 &&
        (apiMessage.toLowerCase().contains('api key') ||
            apiMessage.toLowerCase().contains('expired'))) {
      throw ApiKeyException(apiMessage);
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw ApiKeyException(apiMessage);
    }
    if (response.statusCode == 429 ||
        apiMessage.toLowerCase().contains('quota')) {
      throw ApiKeyException(
        'Quota exceeded. Try a new API key or wait for the daily reset.',
      );
    }

    throw Exception('${response.statusCode}: $apiMessage');
  }
}
