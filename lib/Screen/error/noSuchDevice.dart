import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:itea_green_d/Screen/SpalshScreen.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:itea_green_d/class/UrlCreater.dart';
import 'package:itea_green_d/class/htpResponce.dart';

class noSuchDevices extends StatefulWidget {
  @override
  _noSuchDevicesState createState() => _noSuchDevicesState();
}

class _noSuchDevicesState extends State<noSuchDevices> {
  String emi;
  void initState() {
    super.initState();
    emigeter();
  }

  emigeter() async {
    emi = await ImeiPlugin.getImei();
  }

  checkDeviceValid() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      GetUrl getUrl = GetUrl();
      String emi = await ImeiPlugin.getImei();
      String url = getUrl.deviceCheck(emi);
      print(url);
      HtpResponce httpReq = HtpResponce(url);

      httpReq.getData().then((value) => {
            if (value['success'] == 1)
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpalshScreen(),
                  ),
                )
              }
            else
              {ErrorToster("Stil not Verified")}
          });
    } else {
      ErrorToster("Please Check Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: EasyRefresh(
        onRefresh: () async {
          checkDeviceValid();
        },
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHieght / 7,
            ),
            Center(
              child: Image(
                width: deviceWidth / 2,
                image: AssetImage(
                  "images/error/nosuchDevice.png",
                ),
              ),
            ),
            SizedBox(
              height: deviceHieght / 10,
            ),
            Text("This Device not verified",
                style: GoogleFonts.aclonica(
                    fontSize: deviceWidth / 20, color: Colors.blue)),
            SizedBox(
              height: deviceHieght / 24,
            ),
            FlatButton(
              onPressed: () => {send_sms_req()},
              child: Text(
                "Send Activation Reqvest",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            SizedBox(
              height: deviceHieght / 24,
            ),
            Text("$emi")
          ],
        )),
      ),
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  sendFirebase() async {
    FirebaseDatabase database = new FirebaseDatabase();
    String emiAddress = await ImeiPlugin.getImei();
    print(emiAddress);
    DatabaseReference _userRef = database.reference().child('deviceREQ');
    _userRef.set({"emi": emiAddress});
  }

  send_sms_req() {
    sendFirebase();
    // String message = "This is a test message!";
    // List<String> recipents = ["0773111328"];

    // _sendSMS(message, recipents);
  }
}
