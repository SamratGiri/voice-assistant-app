import 'package:flutter/material.dart';

import 'package:voice_assist_app/home_page.dart';
import 'package:voice_assist_app/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter voice assistant application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: Pallete.backgroundColor),
      home: HomePage(),
    );
  }
}
