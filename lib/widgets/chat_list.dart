import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:voice_assist_app/core/pallete.dart';
import 'package:voice_assist_app/models/message.dart';
import 'package:voice_assist_app/widgets/chat_message_tile.dart';

/// The scrollable list displaying the conversation history.
class ChatList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Message> conversationHistory;
  final bool isSearching;
  final String lastWords;
  final bool isListening;

  const ChatList({
    super.key,
    required this.scrollController,
    required this.conversationHistory,
    required this.isSearching,
    required this.lastWords,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount:
          conversationHistory.length +
          (isSearching ? 1 : 0) +
          (isListening && lastWords.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        // 1. Handling current voice recognition words
        if (index == conversationHistory.length && isListening) {
          return ChatMessageTile(
            message: Message(
              text: lastWords,
              isUser: true,
              timestamp: DateTime.now(),
            ),
          );
        }

        // 2. Handling the AI search/processing state
        if (index == conversationHistory.length + (isListening ? 1 : 0)) {
          return const SearchingIndicator();
        }

        // 3. Displaying past messages
        final message = conversationHistory[index];
        return ChatMessageTile(
          message: message,
          showTypewriter:
              !message.isUser && index == conversationHistory.length - 1,
        );
      },
    );
  }
}

/// A subtle animated indicator shown when the AI is processing an answer.
class SearchingIndicator extends StatelessWidget {
  const SearchingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Searching...',
              style: Fonts.italianaRegular.copyWith(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
