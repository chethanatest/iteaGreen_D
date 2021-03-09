import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/Screen/deductionScreen.dart';
import 'package:itea_green_d/class/Alert.dart';

class issues extends StatefulWidget {
  @override
  _issuesState createState() => _issuesState();
}

class _issuesState extends State<issues> {
  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Issues"),
        leading: BackButton(
          onPressed: () => {goTo(context, deductionScreen())},
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Isues Item",
                    style: GoogleFonts.aBeeZee(fontSize: deviceWidth / 25),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    focusColor: Colors.teal,
                    leading: Image(image: AssetImage("images/deduction.png")),
                    title: Text("Item Name"),
                    subtitle: Text("Sub Catagory name"),
                    trailing: Text(
                      "5",
                      style: GoogleFonts.aBeeZee(),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              child: TextField(
                keyboardType: TextInputType.number,
                autofocus: false,
                cursorColor: Colors.teal,
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  labelText: 'Quntity',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: const Icon(
                    Icons.account_balance,
                    color: Colors.teal,
                  ),
                  prefixText: ' ',
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: 120,
              child: FlatButton.icon(
                  highlightColor: Colors.amber,
                  color: Colors.teal,
                  onPressed: () => {},
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Add",
                    style: GoogleFonts.amaranth(
                      color: Colors.white,
                    ),
                  )),
            ),
            SizedBox(
              height: deviceHieght / 3,
            )
          ],
        ),
      ),
    );
  }
}
