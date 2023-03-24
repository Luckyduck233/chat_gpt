class ModelGptTurbo {
  String model = "gpt-3.5-turbo";
  int maxTokens = 256;
  double temperature = 0.5;
  int topP = 1;
  int n = 1;
  bool stream = false;
  dynamic stop;
  late List<Message> message;

  ModelGptTurbo(
      {required this.model,
      required this.maxTokens,
      required this.temperature,
      required this.topP,
      required this.n,
      required this.stream,
      required this.stop,
      required this.message});

  factory ModelGptTurbo.fromJson(Map<String, dynamic> json) {
    return ModelGptTurbo(
      model: json["model"],
      maxTokens: json["max_tokens"],
      temperature: json["temperature"],
      topP: json["top_p"],
      stream: json["stream"],
      n: json["n"],
      stop: json["stop"],
      message: List<Message>.from(
        json["message"].map(
          (x) {
            return Message.fromJson(x);
          },
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "model": model,
      "max_tokens": maxTokens,
      "temperature": temperature,
      "top_p": topP,
      "stop": stop,
      "message": List<dynamic>.from(
        message.map(
          (e) => e.toJson(),
        ),
      ),
    };
  }
}

class Message {
  String role;
  String content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json["role"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }
}
// {
// "model":"gpt-3.5-turbo",
// "max_tokens":256,
// "temperature":0.5,
// "top_p":1,
// "n":1,
// "stream":false,
// "stop":null,
// "messages":
// [
// {
// "role":"system","content":"你是一个乐于助人的助手"
// },
// {
// "role": "user",
// "content": "我帅吗"
// },
// {
// "role":"assistant","content":"你很帅"
// },
// {
// "role": "user",
// "content": "我刚刚问了什么问题"
// },{
// "role": "assistant",
// "content": "你问了我“我帅吗？”的问题。"
// },{
// "role": "user",
// "content": "那你回答了什么"
// }
// ]
// }
