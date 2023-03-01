import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

List<String> myList = [
'keyAPI'
];

var random = Random();
int index = random.nextInt(myList.length);
String apiKey = myList[index];

class ApiServices {
  static String baseUrl = "https://api.openai.com/v1/completions";

  static Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  static sendMessage(String? message) async {
    var res = await http.post(Uri.parse(baseUrl),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": '$message',
          "temperature": 0,
          "max_tokens": 1000,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": [ "Human:", " AI"]
        })
    );

    if(res.statusCode == 200) {
      var data = jsonDecode(utf8.decode(res.bodyBytes));
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print("Failed to fetch data");
      return '';
    }
  }
}