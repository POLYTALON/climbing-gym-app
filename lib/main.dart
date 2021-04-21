import 'package:climbing_gym_app/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  /*
  FIXME: we need to hide our api secrets. but how?
  using an .env file is not working after building for web
  
    await DotEnv.load();
    final keyApplicationId = DotEnv.env['BACK4APP_APPLICATIONID'];
    final keyClientKey = DotEnv.env['BACK4APP_CLIENTSECRET'];
  */

  final keyApplicationId = 'PfW1Xzrs8RNZ44jbnLRBRArDepC3WCLFLVvO75Ic';
  final keyClientKey = 'Vxz2kY9cbXOH4LmOigiuGqkU3e9yrXxnRDe0cO3o';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  // Test: Create object in Back4App Storage
  var firstObject = ParseObject('FirstClass')
    ..set(
        'message', 'Hey ! First message from Flutter. Parse is now connected');
  await firstObject.save();
  print('done');

  // run app
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
