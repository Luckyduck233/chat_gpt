import 'dart:async';

import 'package:chat_gpt/page/config_page.dart';
import 'package:chat_gpt/utils/HttpUtil.dart';
import 'package:chat_gpt/components/chat_message.dart';
import 'package:chat_gpt/constants/clearance_token.dart';
import 'package:chat_gpt/enum/menu_value.dart';
import 'package:chat_gpt/components/loading.dart';
import 'package:chat_gpt/model/text_davinci_003_response.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessages> _messagesList = [];
  late SharedPreferences prefs;
  final tController = StreamController.broadcast();
  bool _isTyping = false;

  void _initData() async {
    prefs = await SharedPreferences.getInstance();
  }

  dynamic _getSpData(String key) {
    var string = prefs.getString(key);
    return string;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
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
    var response_json =
        HttpUtil(Constants.API_KEY).completion(prompt).then((value) {
      if (value.statusCode == 200) {
        ModelDavinci003 responseObj = ModelDavinci003.fromJson(value.data);
        var text = responseObj.choices[0].text;
        print(text);
        _receiveMessage(text.replaceAll("\n", ""));
      } else {
        print("connect time out");
      }
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
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.add),
            offset: Offset(0, 50),
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: Text("配置"),
                  value: "1",
                ),
                PopupMenuItem(
                  child: Text("2"),
                  value: "2",
                ),
              ];
            },
            onSelected: (value) {
              if (value == "1") {
                Navigator.of(context).push(
                  PageAnimationTransition(
                    page: ConfigPage(),
                    pageAnimationType: RightToLeftFadedTransition(),
                  ),
                );
              } else if (value == "2") {
                print("2");
              }
            },
          )
        ],
        leading: IconButton(
          onPressed: () {
            print(_getSpData(Constants.SP_CONFIG));
          },
          icon: Icon(Icons.cabin),
        ),
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
