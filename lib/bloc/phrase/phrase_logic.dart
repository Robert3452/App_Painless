import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PhraseLogic {
  Future<List<Map<String, dynamic>>> getPhrases();

  Future<Map<String, dynamic>> createPhrase(
      {String phrase, String dateClassified, String time, bool classifiedAs});
}

class PhraseRequestException implements Exception {}

class HttpPhraseLogic extends PhraseLogic {
  String url = 'https://painless-v2.herokuapp.com';

  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> createPhrase({String phrase,
    String dateClassified,
    String time,
    bool classifiedAs}) async {
    String path = "/phrase";
    path = '$url$path';
    String token = "";
    try {
      token = await storage.read(key: 'jwt');
    } catch (e) {
      // print('No se guardó $e');
      return {
        "message": "no se guardó, no se inició sesión",
        "saved": false,
      };
    }
    // print(token);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> body = {
      "phrase": phrase,
      "classified_as": classifiedAs,
      "date_classified": dateClassified,
      "time": time
    };
    http.Response res =
    await http.post(path, body: jsonEncode(body), headers: headers);
    print(res.body);
    var bodyDecoded = jsonDecode(res.body);
    return {"message": bodyDecoded};
  }

  @override
  Future<List<Map<String, dynamic>>> getPhrases() async {
    String path = "/phrases";
    path = '$url$path';
    String token = "";
    try {
      token = await storage.read(key: 'jwt');
      print(token);
    } catch (e) {
      print('on error');
    }
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response res = await http.get(path, headers: headers);
    if (res.statusCode != 200)
      throw ({
        "message": "You're not logged yet",
        "status_code": res.statusCode,
      });
    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }
}
