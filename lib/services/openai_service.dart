import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assist_app/core/secrets.dart';

class OpenAIService {
  List<Map<String, String>> chatGPTMessages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      debugPrint("📤 Sending prompt to OpenAI: $prompt");

      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
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

      if (res.statusCode == 200) {
        String content = decodedBody['choices'][0]['message']['content'];
        content = content.trim();

        debugPrint("🤖 AI Logic Decision: $content");

        if (content.toLowerCase().contains('yes')) {
          final res = await dalleAPI(prompt);
          return res;
        } else {
          final res = await chatGPTAPI(prompt);
          return res;
        }
      } else {
        debugPrint("❌ API Error (Status ${res.statusCode}): $decodedBody");
        return "An internal error occurred.";
      }
    } catch (e) {
      debugPrint("❌ Exception during OpenAI call: $e");
      return "An internal error occurred.";
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    chatGPTMessages.add({'role': 'user', 'content': prompt});
    try {
      debugPrint("📤 Sending prompt to OpenAI: $prompt");

      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",

          "messages": chatGPTMessages,
          "temperature": 0,
        }),
      );

      final decodedBody = jsonDecode(res.body);

      debugPrint("📩 Full OpenAI Response: $decodedBody");

      if (res.statusCode == 200) {
        String content = jsonDecode(
          res.body,
        )['choices'][0]['message']['content'];
        content = content.trim();
        chatGPTMessages.add({'role': 'assistant', 'content': content});
        return content;
      } else {
        debugPrint("❌ API Error (Status ${res.statusCode}): $decodedBody");
        return "An internal error occurred.";
      }
    } catch (e) {
      debugPrint("❌ Exception during OpenAI call: $e");
      return "An internal error occurred.";
    }
  }

  Future<String> dalleAPI(String prompt) async {
    chatGPTMessages.add({'role': 'user', 'content': prompt});
    try {
      debugPrint("📤 Sending prompt to OpenAI: $prompt");

      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode({
          "model": "dall-e-3",
          "prompt": prompt,
          "n": 1,
          "size": "1024x1024",
        }),
      );

      final decodedBody = jsonDecode(res.body);
      debugPrint("📩 Full OpenAI Response: $decodedBody");

      if (res.statusCode == 200) {
        String imageUrl = decodedBody['data'][0]['url'];
        imageUrl = imageUrl.trim();
        chatGPTMessages.add({'role': 'assistant', 'content': imageUrl});
        return imageUrl;
      } else {
        debugPrint("❌ API Error (Status ${res.statusCode}): $decodedBody");
        return "An internal error occurred.";
      }
    } catch (e) {
      debugPrint("❌ Exception during OpenAI call: $e");
      return "An internal error occurred.";
    }
  }
}
