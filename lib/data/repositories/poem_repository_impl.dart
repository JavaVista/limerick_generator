import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/repositories/abstract/poem_repository.dart';
// ignore: unused_import
import 'dart:convert';
// ignore: unused_import
import 'package:http/http.dart' as http;

class PoemRepositoryImpl implements PoemRepository {
  PoemRepositoryImpl();

  @override
  Future<String> getPoems(String productName) async {
    var apiKey = dotenv.get('PaLM_API_KEY');
    const limerickCount = 5;

    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey");
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "prompt": {
        "context": "You are an not irish but you are an awesome limerick writer.",
        "examples": [
          {
            "input": {
              "content": "Write a limerick about Google Developer Group."
              },
            "output": {
              "content":
                   "There once was a GDG in town,\nWhose members were always up for fun.\nThey learned new tech,\nAnd shared their know-how,\nAnd made the web a better place for all.",
            }
          }
        ],
        "messages": [
          {"content": "Write a cool limerick for $productName."}
        ]
      },
      "candidate_count": limerickCount,
      "temperature": 1,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        String limericks = 'Here are $limerickCount limerick about $productName:\n\n';
        for (var i = 0; i < limerickCount; i++) {
          limericks += '${i + 1}.\n';
          limericks += decodedResponse['candidates'][i]['content'] + '\n\n';
        }
        return limericks;
      } else {
        return 'Something went wrong, it failed with status: ${response.statusCode}.\n\n${response.body}';
      }
    } catch (error) {
      throw Exception('Something went wrong, sending POST request: $error.');
    }
  }
}
