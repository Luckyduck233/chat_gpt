import 'dart:async';

import 'package:chat_gpt/HttpUtil.dart';
import 'package:chat_gpt/chat_message.dart';
import 'package:chat_gpt/clearance_token.dart';
import 'package:chat_gpt/model/loading.dart';
import 'package:chat_gpt/model/response.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessages> _messagesList = [];

  final tController = StreamController.broadcast();

  bool _isTyping = false;

  final openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: Duration.secondsPerMinute),
      isLogger: true);

  void _chat() async {
    final request = CompleteText(
        prompt: _textEditingController.text,
        maxTokens: 256,
        model: kTranslateModelV3);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _sendMessage() {
    ChatMessages message =
        ChatMessages(text: _textEditingController.text, sender: "user");

    setState(() {
      _messagesList.insert(0, message);

      _isTyping = true;
    });
    _sendPrompt(_textEditingController.text);
    // print(_textEditingController.text);

    _textEditingController.clear();

    // openAI.build()
  }

  void _receiveMessage(String resultText) {
    var receiveMessage = ChatMessages(
      text: resultText,
      sender: "GPT-3",
    );

    setState(() {
      _messagesList.insert(0, receiveMessage);

      _isTyping = false;
    });
  }

  void _sendPrompt(String prompt) {
    var response_json = HttpUtil(Constants.API_KEY).completion(prompt).then((value) {
      Response responseObj = Response.fromJson(value.data);
      var text = responseObj.choices[0].text;
      print(text);

      _receiveMessage(text.replaceAll("\n", ""));
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _textEditingController,
          onSubmitted: (value) {
            return _sendMessage();
          },
          decoration: InputDecoration.collapsed(hintText: "发送一条消息"),
        )),
        IconButton(
            onPressed: () {
              _sendMessage();
            },
            icon: Icon(Icons.send)),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ChatGPT DEMO"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messagesList.length,
              itemBuilder: (BuildContext context, int index) {
                return _messagesList[index];
              },
            )),
            if (_isTyping) Loading(),
            Divider(
              height: 1,
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(color: context.cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}
