import 'dart:convert';

import 'package:chat_gpt/entity/config_entity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/constants.dart';
import '../theme/global_theme.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _keyEditingController = TextEditingController();
  final TextEditingController _idEditingController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keyEditingController.addListener(_controllerListener);
    _idEditingController.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {});
  }

  Future<void> _insertConfigData(String key,dynamic value) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString(key, value);
    setState(() {
      // prefs.setStringList("firstInsert",)
    });
  }

  void _saveConfig() {
    if (_keyEditingController.text.isEmptyOrNull &&
        _idEditingController.text.isEmptyOrNull) {
      Fluttertoast.showToast(
        msg: "名称或Key不能为空",
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      ConfigEntity entity = ConfigEntity(name: _idEditingController.text.trim(),
        key: _keyEditingController.text.trim(),);

      var json = entity.toJson();
      print(json);

      _insertConfigData(Constants.SP_CONFIG,json);



      Fluttertoast.showToast(
        msg: "保存成功",
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final double kToolbarHeight = 56.0;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalTheme.lightTheme,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            child: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  onPressed: _saveConfig,
                  icon: Icon(Icons.save),
                ),
              ],
              title: Text("配置"),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "名称:",
                  style: TextStyle(fontSize: 24),
                ),
                Expanded(
                  child: TextField(
                    controller: _idEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "请输入名称",
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: _idEditingController.text.isEmpty
                          ? Icon(Icons.create)
                          : IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ],
            ).pOnly(top: 16),
            Container(
              height: 45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "KEY:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _keyEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Your Api-KEY",
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: _keyEditingController.text.length > 0
                            ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _keyEditingController.clear();
                            });
                          },
                        )
                            : Icon(Icons.key_sharp),
                      ),
                    ),
                  )
                ],
              ),
            ).pOnly(top: 16),
          ],
        ).px16(),
      ),
    );
  }
}
