import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:painless_app/envVariables.dart';
import 'package:geolocator/geolocator.dart';

abstract class PhraseLogic {
  Future<List<Map<String, dynamic>>> getPhrases();

  Future<Map<String, dynamic>> createPhrase(
      {String phrase, String dateClassified, String time, bool classifiedAs});
}

class PhraseRequestException implements Exception {}

class HttpPhraseLogic extends PhraseLogic {
  String url = "${envVars.URL_TS}/api";

  SharedPreferences storage;

  initInstance() async {
    storage = await SharedPreferences.getInstance();
  }

  HttpPhraseLogic() {
    initInstance();
  }

  @override
  Future<Map<String, dynamic>> createPhrase(
      {String phrase,
      String dateClassified,
      String time,
      bool classifiedAs}) async {
    try {
      storage = await SharedPreferences.getInstance();
      String path = "/phrase";
      final GeolocatorPlatform _geoLocationPlatform =
          GeolocatorPlatform.instance;
      var position = await _geoLocationPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      path = '${envVars.URL_TS}/api$path';
      String token = "";
      token = storage.getString("jwt");
      if (token == null) {
        throw ("no hay token");
      }
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Map<String, dynamic> body = {
        "phrase": phrase,
        "classified_as": classifiedAs,
        "date_classified": dateClassified,
        "time": time,
        "longitude": position.longitude,
        "latitude": position.latitude
      };
      http.Response res = await http.post(Uri.parse(path),
          body: jsonEncode(body), headers: headers);
      var bodyDecoded = jsonDecode(res.body);
      return {"message": bodyDecoded};
    } catch (e) {
      print(e);
      return {
        "error": e,
        "message": "no se guardó, no se inició sesión",
        "saved": false,
      };
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPhrases() async {
    try {
      String path = "/phrase";
      path = '${envVars.URL_TS}/api$path';
      String token = "";
      storage = await SharedPreferences.getInstance();
      token = storage.getString('jwt');
      if (token == null) {
        throw ({
          "error": "There was an error",
          "message": "Unauthorized",
          "status_code": "401",
        });
      }
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      http.Response res = await http.get(Uri.parse(path), headers: headers);
      if (res.statusCode != 200) {
        final message = json.decode(res.body)['message'];
        throw ({
          "error": "There was an error",
          "message": message,
          "status_code": "${res.statusCode}",
        });
      }
      return List<Map<String, dynamic>>.from(json.decode(res.body)["message"]);
    }catch(error){
      throw error;
    }
  }
}
