import 'package:chat_gpt/components/chat_message.dart';
import 'package:chat_gpt/theme/global_theme.dart';
import 'package:flutter/material.dart';

import 'page/chat_page.dart';

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
      theme: GlobalTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: ChatScreen()
    );
  }
}
