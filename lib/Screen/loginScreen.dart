import 'package:animated_background/animated_background.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:itea_green_d/Screen/SpalshScreen.dart';
import 'package:itea_green_d/Screen/home.dart';
import 'package:itea_green_d/Screen/jobSelect.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:itea_green_d/class/DB.dart';
import 'package:itea_green_d/class/UrlCreater.dart';
import 'package:itea_green_d/class/htpResponce.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen>
    with TickerProviderStateMixin {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool showPass = true;
  bool isProcessing = false;
  void viewPass() {
    setState(() {
      if (showPass) {
        showPass = false;
        showPassC = Colors.teal;
      } else {
        showPass = true;
        showPassC = Colors.black38;
      }
    });
  }

  Color showPassC = Colors.black38;

  String email_Error = "";

  String Pass_Error = "";

  OutlineInputBorder enable = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, style: BorderStyle.solid));

  OutlineInputBorder focus = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, style: BorderStyle.solid));

  OutlineInputBorder normal = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, style: BorderStyle.solid));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
                baseColor: Colors.teal,
                maxOpacity: 0.1,
                particleCount: 15,
                spawnMaxRadius: 30,
                spawnMaxSpeed: 200)),
        vsync: this,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/logoColor.png"),
                  height: MediaQuery.of(context).size.height / 6,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: email,
                        cursorColor: Colors.teal,
                        style: TextStyle(color: Colors.teal),
                        decoration: InputDecoration(
                          enabledBorder: enable,
                          focusedBorder: focus,
                          border: normal,
                          hintText: 'email@email.com',
                          hintStyle: TextStyle(color: Colors.teal[200]),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.teal),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          prefixText: ' ',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: pass,
                        obscureText: showPass,
                        cursorColor: Colors.teal,
                        style: TextStyle(color: Colors.teal),
                        decoration: InputDecoration(
                          enabledBorder: enable,
                          focusedBorder: focus,
                          border: normal,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.teal[200]),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.teal),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: showPassC,
                            ),
                            onPressed: () => {viewPass()},
                          ),
                          prefixText: ' ',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 17,
                        child: FlatButton(
                          splashColor: Colors.teal[200],
                          color:
                              isProcessing ? Colors.transparent : Colors.teal,
                          shape: ContinuousRectangleBorder(
                              side: BorderSide(
                                  color: Colors.transparent, width: 0),
                              borderRadius: BorderRadius.circular(80.0)),
                          child: isProcessing
                              ? SpinKitRing(color: Colors.green)
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              40),
                                ),
                          onPressed: () =>
                              {!isProcessing ? pressLogin() : null},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "copyright © ITS Data Link 2020. all rights reserved",
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width / 40),
          ),
        ),
      ),
    );
  }

  pressLogin() async {
    if (email.text == '' || pass.text == '') {
      ErrorToster("User Name or Password Can't be Empty");
    } else {
      setState(() {
        isProcessing = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        GetUrl getUrl = GetUrl();
        String emi = await ImeiPlugin.getImei();
        String url = getUrl.loginURL(emi, email.text, pass.text);
        print(url);
        HtpResponce httpReq = HtpResponce(url);

        httpReq.getData().then((value) => {
              if (value['DeviceVerified'] == 1)
                {
                  if (value['success'] == 1)
                    {loginSucces(value)}
                  else
                    {
                      setState(() {
                        isProcessing = false;
                        ErrorToster(value['msg']);
                      })
                    }
                }
              else
                {notVerifiedDevice()}
            });
      } else {
        ErrorToster("Please Check Internet Connection");
      }
    }
  }

  loginSucces(Map value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isUserLogin", true);
    prefs.setInt("idCollector", value['idCollector']);
    prefs.setString("CollectorName", value['CollectorName'].toString());
    prefs.setString("Email", value['Email'].toString());
    prefs.setString("CompanyName", value['CompanyName'].toString());
    crateDB();
    SusccesToster("Wellcome " + value['CollectorName'].toString());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => jobSelect(),
      ),
    );
  }

  notVerifiedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    ErrorToster("Un-Autharized Device");

    prefs.setBool("IsDeviceComform", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpalshScreen(),
      ),
    );
  }
}
