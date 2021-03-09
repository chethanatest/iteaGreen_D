import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/class/DMO/Suplier.dart';
import 'package:itea_green_d/class/UrlCreater.dart';
import 'package:itea_green_d/class/htpResponce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class suplierTab extends StatefulWidget {
  @override
  _suplierTabState createState() => _suplierTabState();
}

class _suplierTabState extends State<suplierTab> {
  String recodeCount = "";

  List supliers = [
    {
      "Ref": 1,
      "name": "Nimal KarunaSena",
      "RegNo": "BA-225",
      "routeName": "Baddegama",
      "IsClaim": 5
    },
    {
      "Ref": 2,
      "name": "Darmaraja Sumatipala",
      "RegNo": "BA-226",
      "routeName": "Baddegama",
      "IsClaim": 0
    },
    {
      "Ref": 3,
      "name": "Damith Pasinthira",
      "RegNo": "BA-230",
      "routeName": "Baddegama",
      "IsClaim": 1
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    recodeCount = supliers.length.toString() + " Supliers";
  }

  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: deviceHieght / 20,
            color: Colors.teal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Supliers List",
                    style: GoogleFonts.aBeeZee(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    recodeCount,
                    style: GoogleFonts.actor(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: deviceHieght / 30,
          ),
          Expanded(
            child: EasyRefresh(
              onRefresh: () async {
                getSupliersFromServer();
              },
              child: ListView.builder(
                  itemCount: supliers.length,
                  itemBuilder: (context, count) {
                    return ListTile(
                      leading: Image(image: AssetImage("images/userIcon.png")),
                      title: Text(supliers[count]['name'].toString()),
                      subtitle: Text(supliers[count]['routeName'].toString()),
                      trailing: supliers[count]['IsClaim'] == 5
                          ? Icon(Icons.watch_later, color: Colors.orange)
                          : supliers[count]['IsClaim'] == 1
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.not_interested, color: Colors.red),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  getSupliersFromServer() async {
    final prefs = await SharedPreferences.getInstance();
    int rootID = prefs.getInt("idCollector") ?? 0;
    int companyID = prefs.getInt("idCollector") ?? 0;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      GetUrl getUrl = GetUrl();
      String url = getUrl.getSupliers(rootID, companyID);
      HtpResponce httpReq = HtpResponce(url);

      httpReq.getData().then((value) => {setDatatoDB(value)});
    }
  }

  setDatatoDB(Map data) async {
    var database = await openDatabase('iTeaGereen.db');
    try {
      database.delete("Spulier");
      print("SYS: Clear Data Base Suplier");
    } catch (e) {
      print("SYS: " + e);
    }
    int i = 0;
    final prefs = await SharedPreferences.getInstance();
    int job = prefs.getInt("JobID") ?? 0;
    for (var i = 0; i < data['count']; i++) {
      Supplier sup = Supplier.fromServer(data['sup'][i], job);
      sup.addtoDataBase();
      setState(() {
        recodeCount =
            data.length.toString() + " out of " + i.toString() + " Records";
      });
    }
  }
}
