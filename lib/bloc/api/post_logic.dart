import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:painless_app/envVariables.dart';

abstract class PostLogic {
  Future<Map<String, dynamic>> sendAggression(String sentence);
}

class HttpException implements Exception {}

class SimpleHttpLogic extends PostLogic {
  String url = envVars.URL_PY;

  @override
  Future<Map<String, dynamic>> sendAggression(String sentence) async {
    try {
      String path = '/aggression';
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, String> queryParameters = {"phrase": sentence};
      String uri = Uri.https(envVars.URL_PY, path, queryParameters).toString();
      http.Response response = await http.get(Uri.parse(uri), headers: headers);
      Map<String, dynamic> body =
          jsonDecode(response.body); //Convierte una cadena en JSON
      return body;
    } catch (error) {
      print(error);
    }
  }
}
