import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:voice_assist_app/core/pallete.dart';
import 'package:voice_assist_app/widgets/glowing_mic_button.dart';

/// The bottom interaction bar containing the mic, text field, and history buttons.
class ControlBar extends StatelessWidget {
  final TextEditingController textController;
  final bool isListening;
  final bool isSpeaking;
  final VoidCallback onMicTap;
  final VoidCallback onStopSpeaking;
  final Function(String) onTextSubmit;
  final VoidCallback onShowHistory;

  const ControlBar({
    super.key,
    required this.textController,
    required this.isListening,
    required this.isSpeaking,
    required this.onMicTap,
    required this.onStopSpeaking,
    required this.onTextSubmit,
    required this.onShowHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 25, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GlowingMicButton(animate: isListening, onTap: onMicTap),
          if (isSpeaking)
            FadeIn(
              child: IconButton(
                icon: const Icon(
                  Icons.stop_circle_rounded,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: onStopSpeaking,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: textController,
              onSubmitted: onTextSubmit,
              style: Fonts.medium.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.normal,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: Fonts.medium.copyWith(
                  color: Colors.white38,
                  fontStyle: FontStyle.normal,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: textController,
            builder: (context, child) {
              return IconButton(
                icon: Icon(
                  textController.text.isEmpty
                      ? Icons.history_rounded
                      : Icons.send_rounded,
                  color: Colors.orangeAccent,
                ),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    onTextSubmit(textController.text);
                  } else {
                    onShowHistory();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
