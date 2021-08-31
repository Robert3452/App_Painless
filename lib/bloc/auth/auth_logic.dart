import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:painless_app/envVariables.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthLogic {
  Future<Map<String, dynamic>> signUp(String email, String password,
      String confirm_pwd, String names, String lastName);

  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<Map<String, dynamic>> logout();

  Future<Map<String, dynamic>> signInGoogle();

  Future<Map<String, dynamic>> signOutGoogle();
}

class SignInException implements Exception {}

class JWTAuth extends AuthLogic {
  String url = "${envVars.URL_TS}/api/profile";
  SharedPreferences storage;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<Map<String, dynamic>> logout() async {
    storage = await SharedPreferences.getInstance();
    if (storage.containsKey("jwt")) {
      await storage.remove("jwt");
    }

    return {"message": true};
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    String path = '/signin';
    storage = await SharedPreferences.getInstance();
    String uri = '${envVars.URL_TS}/api/profile$path';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "authorization": basicAuth
    };
    http.Response res = await http.post(Uri.parse(uri), headers: headers);
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      Map<String, dynamic> responseBody = jsonDecode(res.body);
      if (storage.containsKey("jwt") != null) {
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
    if (res.statusCode != 200) {
      return {"message": false};
    } else {
      return {"message": true};
    }
  }

  @override
  Future<Map<String, dynamic>> signInGoogle() async {
    try {
      storage = await SharedPreferences.getInstance();
      GoogleSignInAccount user = await _googleSignIn.signIn();
      String uri = '${envVars.URL_TS}/api/profile/signinGoogle';
      Map<String, dynamic> body = {
        "email": user.email,
        "id": user.id,
        "names": user.displayName,
      };
      Map<String, String> headers = {'Content-type': 'application/json'};
      http.Response res = await http.post(Uri.parse(uri),
          body: jsonEncode(body), headers: headers);
      Map<String, dynamic> responseBody = jsonDecode(res.body);
      if (storage.containsKey("jwt") != null) {
        await storage.remove("jwt");
      }
      await storage.setString("jwt", responseBody['token']);
      return responseBody;
    } catch (error) {
      print(error);
    }
  }

  @override
  Future<Map<String, dynamic>> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      if (storage.containsKey("jwt") != null) {
        await storage.remove("jwt");
      }

      return {"message": "Signed out", "status": 200};
    } catch (error) {
      print(error);
    }
  }
}
