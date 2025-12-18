import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../core/pallete.dart';
import '../models/message.dart';

class ChatMessageTile extends StatelessWidget {
  final Message message;
  final bool showTypewriter;
  final VoidCallback? onAnimationComplete;

  const ChatMessageTile({
    super.key,
    required this.message,
    this.showTypewriter = false,
    this.onAnimationComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return FadeInDown(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white30,

            borderRadius: BorderRadius.circular(
              20,
            ).copyWith(topLeft: Radius.zero, bottomRight: Radius.zero),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You', style: Fonts.bold.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              Text(
                message.text,
                style: Fonts.italianaRegular.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return FadeInUp(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withValues(alpha: 0.1),
                Colors.deepOrange.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: Colors.orangeAccent.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(
              20,
            ).copyWith(topLeft: Radius.zero, bottomRight: Radius.zero),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('YOVA', style: Fonts.bold.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              if (message.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(message.imageUrl!),
                )
              else if (showTypewriter)
                AnimatedTextKit(
                  key: ValueKey(message.text),
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  displayFullTextOnTap: true,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      message.text,
                      textStyle: Fonts.italianaRegular.copyWith(fontSize: 16),
                      speed: const Duration(milliseconds: 20),
                    ),
                  ],
                )
              else
                Text(
                  message.text,
                  style: Fonts.italianaRegular.copyWith(fontSize: 16),
                ),
            ],
          ),
        ),
      );
    }
  }
}
