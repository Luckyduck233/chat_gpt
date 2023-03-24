import 'package:shared_preferences/shared_preferences.dart';

class MySharedpreferences{
  static final MySharedpreferences _instance = MySharedpreferences._internal();
  late SharedPreferences _prefs;

  factory MySharedpreferences(){
    return _instance;
  }

  MySharedpreferences._internal(){
    _init();
  }

  Future _init() async{
    _prefs=await SharedPreferences.getInstance();
  }
}