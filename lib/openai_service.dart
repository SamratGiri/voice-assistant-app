import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assist_app/secrets.dart';

class OpenAiService {
  Future<Map<String, dynamic>> isArtPromptAPI(String prompt) async {
    try {
      debugPrint("📤 Sending prompt to OpenAI: $prompt");

      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode({
          "model":
              "gpt-4o-mini", 


          "messages": [
            {
              "role": "user",
              "content":
                  "Answer only YES or NO. Does the following message want to generate an image, art, or picture?\nMessage: $prompt",
            },
          ],
          "temperature": 0,
        }),
      );

      final decodedBody = jsonDecode(res.body);

      debugPrint("📩 Full OpenAI Response: $decodedBody");

      if (res.statusCode != 200) {
        debugPrint("❌ API Error (Status ${res.statusCode}): $decodedBody");
        return {"success": false};
      }

      return {"success": true};
    } catch (e) {
      debugPrint("❌ Exception during OpenAI call: $e");
      return {"success": false};
    }
  }

  Future<String> chatGPTAPI() async {
    return 'CHATGPT';
  }

  Future<String> dalleAPI() async {
    return 'DalleAPI';
  }
}
