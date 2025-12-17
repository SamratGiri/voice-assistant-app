import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:animate_do/animate_do.dart';
import 'package:voice_assist_app/glowing_mic_button.dart';
import 'package:voice_assist_app/openai_service.dart';
import 'pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListening = false;

  String greeting = "Hi, how can I help you today?";
  double buttonSize = 30;
  double iconsize = 25;
  String lastWords = '';
  final OpenAiService openAiService = OpenAiService();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    speechEnabled = await speechToText.initialize(debugLogging: true);
    setState(() {});
  }

  Future<void> startListening() async {
    isListening = true;
    debugPrint("🎤 Started listening");
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    isListening = false;
    debugPrint("🛑 Stopped listening");
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });

    debugPrint(
      "🗣️ Recognized words: ${result.recognizedWords} (Final: ${result.finalResult})",
    );

    // 🔥 THIS IS THE KEY FIX 🔥
    // Only call OpenAI when we get the FINAL result
    if (result.finalResult && lastWords.trim().isNotEmpty) {
      debugPrint("🎉 FINAL SPEECH RESULT RECEIVED: $lastWords");
      debugPrint("🚀 Now calling OpenAI API...");

      // Call OpenAI here (async, so it won't block UI)
      openAiService.isArtPromptAPI(lastWords).then((result) {
        debugPrint("📩 OpenAI call finished. Result: $result");
      });
    }
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YOVA', style: Fonts.bold),
            Text('Your virtual assistant ', style: Fonts.medium),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(radius: 18),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Pallete.backgroundColor, Pallete.backgroundColor],
          ),
        ),
        child: Column(
          children: [
            FadeInDown(child: Text(greeting, style: Fonts.italianaRegular)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(lastWords, style: Fonts.medium),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: buttonSize,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.message_rounded, size: iconsize),
                  ),
                  GlowingMicButton(
                    isListening: isListening,
                    onTap: () async {
                      if (!speechEnabled) {
                        await initSpeech();
                        return;
                      }

                      if (isListening) {
                        await stopListening();
                        // No API call here anymore — it's moved to onSpeechResult
                      } else {
                        if (await speechToText.hasPermission) {
                          await startListening();
                        } else {
                          await initSpeech();
                        }
                      }
                    },
                  ),
                  CircleAvatar(
                    radius: buttonSize,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.close, size: iconsize),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
