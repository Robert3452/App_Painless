import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class PostLogic {
  Future<Map<String, dynamic>> postAggression(String sentence);
}

class HttpException implements Exception {}

class SimpleHttpLogic extends PostLogic {
  // 'https://painless-v2.herokuapp.com/aggresion'
  String url = 'https://painless-v2.herokuapp.com/aggresion';
  @override
  Future<Map<String, dynamic>> postAggression(String sentence) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode({"sentence": sentence});

    http.Response response =
        await http.post(this.url, headers: headers, body: json);

    Map<String, dynamic> body =
        jsonDecode(response.body); //Convierte una cadena en JSON
    print(body);

    return body;
  }
}
