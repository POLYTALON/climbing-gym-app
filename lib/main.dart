import 'package:climbing_gym_app/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load();
  final keyApplicationId = DotEnv.env['BACK4APP_APPLICATIONID'];
  final keyClientKey = DotEnv.env['BACK4APP_CLIENTSECRET'];
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(fontFamily: 'NunitoSans'),
      home: StartScreen(),
    );
  }
}
