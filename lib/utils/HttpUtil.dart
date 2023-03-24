import 'dart:convert';

import 'package:chat_gpt/entity/CompletionRequest.dart';
import 'package:dio/dio.dart';


class HttpUtil{
  late Dio dio;
  static Map<String,HttpUtil> _cache = <String,HttpUtil>{};

  factory HttpUtil(String key){
    return _cache.putIfAbsent(key,(){
      return HttpUtil._internal(key);
    });
  }

  HttpUtil._internal(String key){
    var options = BaseOptions(
      baseUrl: "https://api.openai.com/v1/",
      connectTimeout: 15000,
      receiveTimeout: 15000,
      headers: {
        "Authorization":"Bearer "+key,
      }
    );
    dio=Dio(options);
  }
  Future<Response> post<T>(String path,Map<String,dynamic> data) async{
    var response = dio.post(path,data:data);
    return response;
  }

  Future<Response> completion(String content) async {
    var completionRequest = new CompletionRequest();
    completionRequest.prompt=content;
    var reqJson = jsonEncode(completionRequest);

    print(reqJson);

    var response =await dio.post("completions",data: reqJson);

    print(response);

    return response;
  }
}
