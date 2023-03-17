import 'package:chat_gpt/chat_message.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      home: ChatScreen()
    );
  }
}
