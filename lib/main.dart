import 'package:flutter/material.dart';

import 'package:voice_assist_app/pages/home_page.dart';
import 'package:voice_assist_app/core/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
