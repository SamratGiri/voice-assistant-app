import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:voice_assist_app/core/pallete.dart';

/// The initial welcome screen shown when there is no conversation history.
class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'WELCOME BACK',
                  textStyle: Fonts.italianaRegular.copyWith(
                    fontSize: 32,
                    letterSpacing: 2,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
            ),
          ),
          const SizedBox(height: 5),
          FadeInDown(
            delay: const Duration(milliseconds: 1500),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'ASK ANYTHING YOU WANT',
                  textStyle: Fonts.italianaRegular.copyWith(
                    fontSize: 24,
                    letterSpacing: 1.2,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
            ),
          ),
          const SizedBox(height: 50),
          // Feature Info Boxes
          FadeInUp(
            delay: const Duration(milliseconds: 2500),
            child: const FeatureBox(
              color: Pallete.firstSuggestionBoxColor,
              headerText: 'Smart Chat Assistant',
              descriptionText:
                  'A smarter way to stay organized and informed with ChatGPT',
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 2800),
            child: const FeatureBox(
              color: Pallete.secondSuggestionBoxColor,
              headerText: 'Dall-E',
              descriptionText:
                  'Get inspired and stay creative with your personal assistant powered by Dall-E',
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 3100),
            child: const FeatureBox(
              color: Pallete.thirdSuggestionBoxColor,
              headerText: 'ChatGPT',
              descriptionText:
                  'Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E',
            ),
          ),
        ],
      ),
    );
  }
}

/// A styled box used to display feature highlights on the welcome screen.
class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;

  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: Fonts.bold.copyWith(color: color, fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(
            descriptionText,
            style: Fonts.medium.copyWith(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
