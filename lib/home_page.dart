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

  String greeting = "Hi, how can I help you today?";
  String? generatedContent;
  String? generatedImageUrl;
  double buttonSize = 30;
  double iconsize = 25;
  String lastWords = '';
  final OpenAIService openAiService = OpenAIService();

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
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    debugPrint("🛑 Stopped listening");
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
    });

    debugPrint(
      "🗣️ Recognized words: ${result.recognizedWords} (Final: ${result.finalResult})",
    );

    if (result.finalResult && lastWords.trim().isNotEmpty) {
      debugPrint("🎉 FINAL SPEECH RESULT RECEIVED: $lastWords");
      debugPrint("🚀 Now calling OpenAI API...");

      final speech = await openAiService.isArtPromptAPI(lastWords);
      debugPrint("📩 OpenAI call finished. Result: $speech");

      if (speech.contains('https')) {
        generatedImageUrl = speech;
        generatedContent = null;
        setState(() {});
      } else {
        generatedImageUrl = null;
        generatedContent = speech;
        setState(() {});
      }
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
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              )
            else
              FadeInDown(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    generatedContent == null ? greeting : generatedContent!,
                    style: Fonts.italianaRegular.copyWith(
                      fontSize: generatedContent == null ? 25 : 18,
                    ),
                  ),
                ),
              ),
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
                    onTap: () async {
                      if (!speechEnabled) {
                        await initSpeech();
                        return;
                      }

                      if (speechToText.isListening) {
                        await stopListening();
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
