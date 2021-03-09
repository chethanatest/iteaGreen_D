import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/Screen/deductionScreen.dart';
import 'package:itea_green_d/class/Alert.dart';

class newDeduction extends StatefulWidget {
  @override
  _newDeductionState createState() => _newDeductionState();
}

class _newDeductionState extends State<newDeduction> {
  String itemName = "Select From List";
  int itemID;
  FocusNode quntityFnobe;
  List itemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      itemList = [
        {
          "id": 1,
          "name": "Item Name 1",
          "subCat": "sub Catagory Name",
        },
        {
          "id": 2,
          "name": "Item Name 2",
          "subCat": "sub Catagory Name",
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    Widget _buildBottomSheetItem(
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
    ) {
      return SafeArea(
        child: Material(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.teal,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Isues Item List",
                          style: GoogleFonts.abhayaLibre(
                              fontSize: deviceWidth / 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Sub Item Catagory",
                          style: GoogleFonts.abhayaLibre(
                              fontSize: deviceWidth / 28, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: itemList.length,
                      itemBuilder: (context, count) {
                        return ListTile(
                          onTap: () => {
                            setItem(itemList[count]['id'],
                                itemList[count]['name'].toString())
                          },
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          focusColor: Colors.teal,
                          leading:
                              Image(image: AssetImage("images/deduction.png")),
                          title: Text(itemList[count]['name'].toString()),
                          subtitle: Text(itemList[count]['subCat'].toString()),
                          trailing: Text(
                            "5",
                            style: GoogleFonts.aBeeZee(),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _showSheetItem() {
      showFlexibleBottomSheet<void>(
        minHeight: 0,
        initHeight: 0.5,
        maxHeight: 1,
        context: context,
        builder: _buildBottomSheetItem,
        anchors: [0, 0.5, 1],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Add New Deduction"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {goTo(context, deductionScreen())}),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Isues Item List",
                    style: GoogleFonts.aBeeZee(fontSize: deviceWidth / 25),
                  ),
                  FlatButton(
                    onPressed: () => {_showSheetItem()},
                    child: Text(
                      "$itemName",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              child: TextField(
                focusNode: quntityFnobe,
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
            )
          ],
        ),
      )),
    );
  }

  void setItem(int id, String name) {
    setState(() {
      itemID = id;
      itemName = name;
    });
    Navigator.pop(context);
  }
}
