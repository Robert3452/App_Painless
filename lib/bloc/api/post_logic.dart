import 'dart:convert';
import 'package:http/http.dart' as http;
abstract class PostLogic {
  Future<Map<String, dynamic>> postAggression(String sentence);
}

class HttpException implements Exception {}

class SimpleHttpLogic extends PostLogic {
  String url = 'painless-v2.herokuapp.com';

  @override
  Future<Map<String, dynamic>> postAggression(String sentence) async {
    String path = '/aggression';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> queryParameters = {"phrase": sentence};
    String uri = Uri.https(this.url, path, queryParameters).toString();
    http.Response response = await http.get(uri, headers: headers);
    print(response.body);
    Map<String, dynamic> body =
        jsonDecode(response.body); //Convierte una cadena en JSON
    return body;
  }
}
