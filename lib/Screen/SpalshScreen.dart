import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:itea_green_d/Screen/error/noSuchDevice.dart';
import 'package:itea_green_d/Screen/jobSelect.dart';
import 'package:itea_green_d/Screen/loginScreen.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:itea_green_d/class/UrlCreater.dart';
import 'package:itea_green_d/class/htpResponce.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpalshScreen extends StatefulWidget {
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  EasyRefreshController _controller = EasyRefreshController();
  int lodingValue = 20;
  bool isDeviceComform;
  String currentStatus = "Check Device Valid";
  bool hasCon = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAlredyLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !hasCon
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => {relode()},
              child: IconButton(
                icon: Icon(Icons.repeat),
                color: Colors.teal,
              ),
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.teal[600],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("images/logo_full_white.png"),
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Container(
              child: TextLiquidFill(
                text: 'iTea Green D',
                waveColor: Colors.white,
                boxBackgroundColor: Colors.teal[600],
                textStyle: GoogleFonts.acme(
                  color: Colors.white,
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 9),
                ),
                boxHeight: MediaQuery.of(context).size.height / 10,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 19,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FAProgressBar(
                  size: 20,
                  animatedDuration: Duration(milliseconds: 5000),
                  backgroundColor: Colors.teal,
                  progressColor: Colors.white,
                  currentValue: lodingValue,
                  displayText: '%',
                ),
              ),
            ),
            SizedBox(
              child: Text(
                "$currentStatus",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Version 1.0.1",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  checkAlredyLog() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLog = prefs.getBool("IsDeviceComform") ?? false;
    setState(() {
      setIsDeviceComform(isLog);
      currentStatus = "Device Device Verifing...";
      lodingValue = 30;
    });
  }

  setIsDeviceComform(bool isComform) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDeviceComform = isComform;

      if (isDeviceComform) {
        prefs.setBool("IsDeviceComform", true);
        currentStatus = "Device verified...";
        lodingValue = 100;
      } else {
        prefs.setBool("IsDeviceComform", false);

        currentStatus = "Try ti connect With Server...";
        lodingValue = 40;
      }
    });

    if (isComform) {
      final prefs = await SharedPreferences.getInstance();
      bool isUserLogin = prefs.getBool("isUserLogin") ?? false;

      if (!isUserLogin) {
        Timer(Duration(seconds: 6), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => loginScreen(),
            ),
          );
        });
      } else {
        Timer(Duration(seconds: 6), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => jobSelect(),
            ),
          );
        });
      }
    } else {
      checkDeviceValid();
    }
  }

  checkDeviceValid() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      currentStatus = "connected to Server...";
      lodingValue = 50;

      GetUrl getUrl = GetUrl();
      String emi = await ImeiPlugin.getImei();
      String url = getUrl.deviceCheck(emi);
      print(url);
      HtpResponce httpReq = HtpResponce(url);

      httpReq.getData().then((value) => {
            if (value['success'] == 1)
              {setIsDeviceComform(true)}
            else
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => noSuchDevices(),
                  ),
                )
              }
          });
    } else {
      setState(() {
        hasCon = false;
      });
      ErrorToster("Please Check Internet Connection");
      currentStatus = "No Internet Connection...";
      lodingValue = 0;
    }
  }

  relode() {
    Timer(Duration(seconds: 0), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpalshScreen(),
        ),
      );
    });
  }

  noSuchDevice() {}
}
