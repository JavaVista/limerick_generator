import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/repositories/abstract/poem_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemRepositoryImpl implements PoemRepository {
  PoemRepositoryImpl();

  @override
  Future<String> getPoems(String productName) async {
    var apiKey = dotenv.get('Gemini_API_KEY');
    const limerickCount = 5;
    List<String> limericks = [];

    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    final headers = {
      'Content-Type': 'application/json',
    };


    for (int i = 0; i < limerickCount; i++) {
      final body = jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    "Write a cool limerick about $productName.  You are an awesome limerick writer, even though you're not Irish."
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 1.0,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 8192,
        }
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          final content = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
          limericks.add(content);
        } else {
          print('Error getting limerick ${i + 1}: ${response.statusCode} - ${response.body}');
          limericks.add("Error generating limerick ${i+1}."); 
        }
      } catch (error) {
        // Handle errors, but continue to try to get other limericks
        print('Error getting limerick ${i + 1}: $error');
        limericks.add("Error generating limerick ${i+1}."); // Placeholder for error
      }
    }

    String result = 'Here are $limerickCount limericks about $productName:\n\n';
    for (int i = 0; i < limericks.length; i++) {
      result += '${i + 1}.\n${limericks[i]}\n\n';
    }

    return result;
  }
}