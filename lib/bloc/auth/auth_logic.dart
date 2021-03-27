import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

abstract class AuthLogic {
  Future<Map<String, dynamic>> signUp(String email, String password,
      String confirm_pwd, String names, String lastName);

  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<Map<String, dynamic>> logout();
}

class SignInException implements Exception {}

class JWTAuth extends AuthLogic {
  String url = 'https://painless-v2.herokuapp.com';

  // String url = 'http://192.168.88.5:5000';
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> logout() async {
    await this.storage.delete(key: "jwt");
    return {"message": true};
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    String path = '/signin';
    String uri = '$url$path';
    print(uri);
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> body = {
      "username": email,
      "password": password,
    };
    http.Response res =
        await http.post(uri, body: jsonEncode(body), headers: headers);
    print(res.body);
    print(res.statusCode);
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      Map<String, dynamic> responseBody = jsonDecode(res.body);
      if (await storage.read(key: "jwt") == null) {
        print(storage.read(key: "jwt"));
        await storage.delete(key: "jwt");
      }
      await this.storage.write(key: "jwt", value: responseBody['access_token']);
      return {"message": true};
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password,
      String confirm_pwd, String names, String lastName) async {
    String path = '/signup';
    String uri = '$url$path';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> body = {
      "email": email,
      "password": password,
      "name": names,
      "lastname": lastName,
      "confirm_pwd": confirm_pwd
    };
    http.Response res =
        await http.post(uri, body: jsonEncode(body), headers: headers);
    print(res.statusCode);
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      return {"message": true};
    }
  }
}
