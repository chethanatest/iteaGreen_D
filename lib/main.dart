import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itea_green_d/push_nofitications.dart';

import 'Screen/SpalshScreen.dart';
import 'Screen/home.dart';
import 'Screen/jobSelect.dart';
import 'Screen/loginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SpalshScreen(),
        '/jobSelect': (context) => jobSelect(),
        '/loginScreen': (context) => loginScreen(),
        '/home': (context) => home(),
      },
    ));
  });
}

/* 
  itea Green Dudaction
  2020-12-19
  chethana Kalpa
  copyright © ITS Data Link 2020. all rights reserved
*/
