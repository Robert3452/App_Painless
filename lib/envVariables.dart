import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  var URL_PY;
  var URL_TS;

  EnvConfig() {
    this.initDotenv();
  }

  initDotenv() async {
    await dotenv.load(fileName: '.env');
    this.URL_PY = dotenv.env['API_URL_PY'];
    this.URL_TS = dotenv.env['API_URL_TS'];
  }
}

final envVars = new EnvConfig();
