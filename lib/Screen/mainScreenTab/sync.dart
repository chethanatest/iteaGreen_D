import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/Screen/jobSelect.dart';
import 'package:itea_green_d/class/UrlCreater.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sync extends StatefulWidget {
  @override
  _syncState createState() => _syncState();
}

class _syncState extends State<sync> {
  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: PageView(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Data Sync States",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aclonica(fontSize: deviceHieght / 35)),
                  SizedBox(
                    height: deviceHieght / 30,
                  ),
                  PieChart(dataMap: {
                    "Sync": 15,
                    "Not Sync Yet": 12,
                  }, colorList: [
                    Colors.green[300],
                    Colors.black12
                  ]),
                  SizedBox(
                    height: deviceHieght / 20,
                  ),
                  SizedBox(
                    width: deviceWidth / 1.8,
                    height: deviceHieght / 15,
                    child: FlatButton.icon(
                        onPressed: () => {getSync()},
                        color: Colors.green,
                        icon: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Sync",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("End This Job",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aclonica(fontSize: deviceHieght / 35)),
                  SizedBox(
                    height: deviceHieght / 30,
                  ),
                  SizedBox(
                    width: deviceWidth / 1.8,
                    height: deviceHieght / 15,
                    child: FlatButton.icon(
                        onPressed: () => {},
                        color: Colors.red,
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "End Day",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Get New System Data From Server",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aclonica(fontSize: deviceHieght / 35)),
                  SizedBox(
                    height: deviceHieght / 30,
                  ),
                  SizedBox(
                    width: deviceWidth / 1.8,
                    height: deviceHieght / 15,
                    child: FlatButton.icon(
                        onPressed: () => {},
                        color: Colors.blueAccent,
                        icon: Icon(
                          Icons.system_update,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Sync System Data",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Change This Job",
                      style: GoogleFonts.aclonica(fontSize: deviceHieght / 35)),
                  SizedBox(
                    height: deviceHieght / 30,
                  ),
                  SizedBox(
                    width: deviceWidth / 1.8,
                    height: deviceHieght / 15,
                    child: FlatButton.icon(
                        onPressed: () => {changeJob()},
                        color: Colors.amber,
                        icon: Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Change Job",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getSync() {}

  changeJob() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasJob", false);
    prefs.setBool("IsActiveJob", false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => jobSelect(),
      ),
    );
  }
}
