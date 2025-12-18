import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:voice_assist_app/services/openai_service.dart';
import 'package:voice_assist_app/models/message.dart';
import 'package:voice_assist_app/widgets/history_view.dart';
import 'package:voice_assist_app/core/pallete.dart';

// New Modular Widgets
import 'package:voice_assist_app/widgets/welcome_message.dart';
import 'package:voice_assist_app/widgets/chat_list.dart';
import 'package:voice_assist_app/widgets/control_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool speechEnabled = false;
  bool isSearching = false;
  bool isSpeaking = false;
  final List<Message> conversationHistory = [];

  String greeting = "WELCOME BACK";
  double buttonSize = 25;
  double iconsize = 20;
  String lastWords = '';
  final OpenAIService openAiService = OpenAIService();

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTextToSpeech();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);

    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
    });

    setState(() {});
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

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
    });

    if (result.finalResult && lastWords.trim().isNotEmpty) {
      setState(() {
        isSearching = true;
        // Add user message to history
        conversationHistory.add(
          Message(text: lastWords, isUser: true, timestamp: DateTime.now()),
        );
      });
      scrollToBottom();

      final speech = await openAiService.isArtPromptAPI(lastWords);

      if (speech.contains('https')) {
        setState(() {
          conversationHistory.add(
            Message(
              text: 'Generated image',
              isUser: false,
              timestamp: DateTime.now(),
              imageUrl: speech,
            ),
          );
          isSearching = false;
        });
        scrollToBottom();
      } else {
        setState(() {
          conversationHistory.add(
            Message(text: speech, isUser: false, timestamp: DateTime.now()),
          );
          isSearching = false;
        });
        scrollToBottom();
        await systemSpeak(speech);
      }
    }
  }

  Future<void> onTextSubmit(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      isSearching = true;
      conversationHistory.add(
        Message(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
    scrollToBottom();

    final response = await openAiService.isArtPromptAPI(text);

    setState(() {
      if (response.contains('https')) {
        conversationHistory.add(
          Message(
            text: 'Generated image',
            isUser: false,
            timestamp: DateTime.now(),
            imageUrl: response,
          ),
        );
      } else {
        conversationHistory.add(
          Message(text: response, isUser: false, timestamp: DateTime.now()),
        );
        systemSpeak(response);
      }
      isSearching = false;
    });
    scrollToBottom();
  }

  void clearHistory() async {
    await flutterTts.stop();
    setState(() {
      conversationHistory.clear();
      lastWords = '';
      isSearching = false;
    });
  }

  void showConversationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HistoryBottomSheet(
        conversationHistory: conversationHistory,
        onClearHistory: clearHistory,
      ),
    );
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Pallete.backgroundColor, Pallete.backgroundColor],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: false,
                      floating: true,
                      snap: true,
                      pinned: false,
                      leadingWidth: 60,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://i.pravatar.cc/150?img=11',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello Samrat',
                            style: Fonts.italianaRegular.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.horizontal_split_rounded,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ];
                },
                body:
                    conversationHistory.isEmpty &&
                        !isSearching &&
                        lastWords.isEmpty
                    ? const SingleChildScrollView(child: WelcomeMessage())
                    : ChatList(
                        scrollController: _scrollController,
                        conversationHistory: conversationHistory,
                        isSearching: isSearching,
                        lastWords: lastWords,
                        isListening: speechToText.isListening,
                      ),
              ),
            ),
            ControlBar(
              textController: _textController,
              isListening: speechToText.isListening,
              isSpeaking: isSpeaking,
              onMicTap: () async {
                if (isSpeaking) {
                  await stopSpeaking();
                }
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
              onStopSpeaking: stopSpeaking,
              onTextSubmit: onTextSubmit,
              onShowHistory: showConversationHistory,
            ),
          ],
        ),
      ),
    );
  }
}
