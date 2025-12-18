import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/pallete.dart';
import '../models/message.dart';

class HistoryBottomSheet extends StatelessWidget {
  final List<Message> conversationHistory;
  final VoidCallback onClearHistory;

  const HistoryBottomSheet({
    super.key,
    required this.conversationHistory,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Pallete.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text('History', style: Fonts.bold.copyWith(fontSize: 20)),
                    ],
                  ),
                  if (conversationHistory.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Colors.orangeAccent,
                      ),
                      onPressed: () {
                        onClearHistory();
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: conversationHistory.isEmpty
                  ? Center(
                      child: Text(
                        'No conversation history yet',
                        style: Fonts.medium.copyWith(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: conversationHistory.length,
                      itemBuilder: (context, index) {
                        final message = conversationHistory[index];
                        return FadeInUp(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? Colors.white60
                                  : Colors.orange.withValues(alpha: 0.1),
                              border: Border.all(
                                color: message.isUser
                                    ? Pallete.borderColor
                                    : Colors.orangeAccent.withValues(
                                        alpha: 0.3,
                                      ),
                              ),
                              borderRadius: BorderRadius.circular(15).copyWith(
                                topLeft: message.isUser
                                    ? Radius.zero
                                    : const Radius.circular(15),
                                bottomRight: message.isUser
                                    ? Radius.zero
                                    : const Radius.circular(15),
                                topRight: message.isUser
                                    ? const Radius.circular(15)
                                    : Radius.zero,
                                bottomLeft: message.isUser
                                    ? const Radius.circular(15)
                                    : Radius.zero,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      message.isUser ? 'You' : 'YOVA',
                                      style: Fonts.bold.copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                      style: Fonts.medium.copyWith(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (message.imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      message.imageUrl!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Text(
                                    message.text,
                                    style: Fonts.medium.copyWith(
                                      color: message.isUser
                                          ? Colors.black87
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
