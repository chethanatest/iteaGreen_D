import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/Screen/home.dart';
import 'package:itea_green_d/Screen/issues.dart';
import 'package:itea_green_d/Screen/newDeduction.dart';
import 'package:itea_green_d/class/Alert.dart';

class deductionScreen extends StatefulWidget {
  @override
  _deductionScreenState createState() => _deductionScreenState();
}

class _deductionScreenState extends State<deductionScreen> {
  bool hasSup = false;
  List sheduleItem = [
    {
      "Item": "item name",
      "SubCat": "Sub Catagory Name",
      "Aded_DateTime": "2021-12-25",
      "Deleverd_DateTime": "2021-12-25",
      "IsDeleverd": 0,
    },
    {
      "Item": "item name",
      "SubCat": "Sub Catagory Name",
      "Aded_DateTime": "2021-12-25",
      "Deleverd_DateTime": "2021-12-25",
      "IsDeleverd": 1,
    }
  ];
  String barcodeScanRes = "";
  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    if (!hasSup) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.home), onPressed: () => {goTo(context, home())}),
          backgroundColor: Colors.teal,
          title: Text("Deduction Screen"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("images/noUser.png")),
                SizedBox(
                  height: deviceHieght / 20,
                ),
                Text(
                  "Suppliers is Not Selected",
                  style: GoogleFonts.aclonica(fontSize: deviceWidth / 20),
                ),
                SizedBox(
                  height: deviceHieght / 20,
                ),
                FlatButton(
                    onPressed: () => {sacnSuplier()},
                    color: Colors.teal,
                    child: Text(
                      "Scan QR",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.home), onPressed: () => {goTo(context, home())}),
          backgroundColor: Colors.teal,
          title: Text("Deduction Screen"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {sacnSuplier()},
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.camera,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: deviceHieght / 25,
                    backgroundImage: AssetImage("images/userIcon.png"),
                  ),
                  SizedBox(
                    width: deviceWidth / 15,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Chethana Kalpa",
                            style: GoogleFonts.aBeeZee(
                                textStyle:
                                    TextStyle(fontSize: deviceHieght / 40))),
                        Text("BA-1282",
                            style: GoogleFonts.abel(
                                textStyle:
                                    TextStyle(fontSize: deviceHieght / 50))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHieght / 30,
            ),
            Container(
              color: Colors.teal,
              child: ListTile(
                onTap: () => {goTo(context, newDeduction())},
                leading: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                title: Text(
                  "Add New Deduction",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceHieght / 50,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: sheduleItem.length,
                  itemBuilder: (context, count) {
                    return ListTile(
                      onTap: () => {goTo(context, issues())},
                      leading: Icon(
                        Icons.chrome_reader_mode,
                        color: Colors.teal,
                      ),
                      title: Text(sheduleItem[count]['Item'].toString()),
                      subtitle: Text(sheduleItem[count]['SubCat'].toString()),
                      isThreeLine: true,
                      trailing: sheduleItem[count]['IsDeleverd'] == 1
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.departure_board,
                              color: Colors.grey,
                            ),
                    );
                  }),
            )
          ],
        )),
      );
    }
  }

  Future<void> sacnSuplier() async {
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);

      if (barcodeScanRes != '') {
        try {} catch (e) {}
      }

      FlutterBeep.beep();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      hasSup = true;
    });
    if (!mounted) return;
  }
}
