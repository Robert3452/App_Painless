import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:painless_app/envVariables.dart';

abstract class AuthLogic {
  Future<Map<String, dynamic>> signUp(String email, String password,
      String confirm_pwd, String names, String lastName);

  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<Map<String, dynamic>> logout();
}

class SignInException implements Exception {}

class JWTAuth extends AuthLogic {
  String url = "${envVars.URL_TS}/api/profile";

  SharedPreferences storage;

  initInstance() async {
    storage = await SharedPreferences.getInstance();
  }

  JWTAuth() {
    initInstance();
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    storage = await SharedPreferences.getInstance();
    await storage.remove("jwt");
    return {"message": true};
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    String path = '/signin';
    storage = await SharedPreferences.getInstance();
    String uri = '${envVars.URL_TS}/api/profile$path';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));
    print(basicAuth);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "authorization": basicAuth
    };
    http.Response res = await http.post(Uri.parse(uri), headers: headers);
    print(res.body);
    print(res.statusCode);
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      Map<String, dynamic> responseBody = jsonDecode(res.body);
      if (storage.getString("jwt") != null) {
        print(storage.getString("jwt"));
        storage.remove("jwt");
      }
      await storage.setString("jwt", responseBody['token']);
      return {"message": true};
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password,
      String confirm_pwd, String names, String lastName) async {
    storage = await SharedPreferences.getInstance();
    String path = '/signup';
    String uri = '${envVars.URL_TS}/api/profile$path';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> body = {
      "email": email,
      "password": password,
      "name": names,
      "lastname": lastName,
      "confirm_pwd": confirm_pwd
    };
    http.Response res = await http.post(Uri.parse(uri),
        body: jsonEncode(body), headers: headers);
    print(res.statusCode);
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      return {"message": true};
    }
  }
}
