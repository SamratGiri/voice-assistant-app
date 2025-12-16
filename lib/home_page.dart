import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:siri_wave/siri_wave.dart' as siri_wave;
import 'package:animate_do/animate_do.dart';
import 'package:voice_assist_app/glowing_mic_button.dart';
import 'pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();

  bool isListening = false;
  String text = "Press  button and start speaking";
  String greeting = "Hi, how can I help you today?";
  double buttonSize = 30;
  double iconsize = 25;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(radius: 18),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ).copyWith(bottom: 20),
        child: Container(
          margin: EdgeInsets.all(22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Pallete.backgroundColor, Pallete.backgroundColor],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 80),
              FadeInDown(
                child: Text(
                  greeting,
                  style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),

              Spacer(),

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

                    GlowingMicButton(onTap: () {}),

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
      ),
    );
  }
}
