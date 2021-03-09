import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/Screen/deductionScreen.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../../push_nofitications.dart';

class homeTab extends StatefulWidget {
  @override
  _homeTabState createState() => _homeTabState();
}

class _homeTabState extends State<homeTab> {
  String userName = "No User";
  String rootName = "No Route";
  String companyName = "No Companay";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommenData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    openDeduction() {
      goTo(context, deductionScreen());
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("License to $companyName",
                  style: GoogleFonts.adventPro(
                      color: Colors.white, fontSize: deviceWidth / 25)),
            ),
          ),
          SizedBox(
            height: deviceHieght / 50,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: Colors.teal,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              userName.toString(),
                              style: GoogleFonts.adamina(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Colors.teal,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              rootName.toString(),
                              style: GoogleFonts.adamina(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceHieght / 20,
          ),
          // DigitalClock(
          //   digitAnimationStyle: Curves.elasticOut,
          //   is24HourTimeFormat: false,
          //   areaDecoration: BoxDecoration(
          //     color: Colors.transparent,
          //   ),
          //   hourMinuteDigitTextStyle: TextStyle(
          //     color: Colors.blueGrey,
          //     fontSize: 50,
          //   ),
          //   amPmDigitTextStyle:
          //       TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: deviceHieght / 20,
          ),
          Container(
            width: double.infinity,
            height: deviceHieght / 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.teal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Today Total Deduction",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Rs.000.00",
                          style: GoogleFonts.abel(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.teal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No. of Records",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "0",
                          style: GoogleFonts.abel(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceHieght / 15,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () => {openDeduction()},
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.green[300],
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: deviceHieght / 10,
                        child:
                            Image(image: AssetImage("images/deduction.png"))),
                    Text(
                      "Deduction",
                      style: GoogleFonts.acme(
                          fontSize: deviceHieght / 30, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getCommenData() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.getInt("rootID");
    setState(() {
      userName = prefs.getString("CollectorName");
      rootName = prefs.getString("rootName");
      companyName = prefs.getString("CompanyName");
    });
  }
}
