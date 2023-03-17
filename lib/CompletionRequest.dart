class CompletionRequest {
  String model = "text-davinci-003";
  late String prompt;
  int max_tokens = 256;
  double temperature = 0.5;
  int top_p = 1;
  int n = 1;
  bool stream = false;
  bool? logprobs;
  String? stop;

  Map<String,dynamic> toJson(){
    return {
      "model":model,
      "prompt":prompt,
      "max_tokens":max_tokens,
      "temperature":temperature,
      "top_p":top_p,
      "n":n,
      "stream":stream,
      "logprobs":logprobs,
      "stop":stop,
    };
  }
}
