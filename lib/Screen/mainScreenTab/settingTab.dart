import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_bluetooth/flutter_bluetooth.dart';

class settingTab extends StatefulWidget {
  @override
  _settingTabState createState() => _settingTabState();
}

class _settingTabState extends State<settingTab> {
  List<BluetoothDevice> bluetoothDevices = [];
  BlueThermalPrinter bluetoothPrint = BlueThermalPrinter.instance;
  // Setting Veribles
  bool isBlutoothon = true;
  bool isSound = false;

  @override
  void initState() {
    checkBlutoothOn();
  }

  checkBlutoothOn() async {
    List<BluetoothDevice> listDevice = [];
    try {
      listDevice = await bluetoothPrint.getBondedDevices();
    } catch (e) {
      print(e);
    }
    bool isOn = await FlutterBluetooth.isEnabled();
    if (!isOn) {
      ErrorToster("Blutooth Is Not turn On");
    }
    setState(() {
      isBlutoothon = isOn;
      bluetoothDevices = listDevice;
    });
  }

  connectToBlutooth() async {
    Vibration.vibrate(duration: 500);

    if (!await FlutterBluetooth.isEnabled()) {
      List<BluetoothDevice> listDevice = [];
      FlutterBluetooth.turnOn();
      try {
        listDevice = await bluetoothPrint.getBondedDevices();
      } catch (e) {
        print(e);
      }
      setState(() {
        isBlutoothon = true;
        listDevice = bluetoothDevices;
      });
    } else {
      FlutterBluetooth.turnOff();
      setState(() {
        isBlutoothon = false;
        bluetoothDevices = [];
      });
    }
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
                    "Device Settings",
                    style: GoogleFonts.aBeeZee(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: deviceHieght / 30,
                    ),
                    onPressed: () => {}),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {connectToBlutooth()},
            child: Container(
              width: double.infinity,
              height: deviceHieght / 20,
              color: isBlutoothon ? Colors.green : Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    isBlutoothon
                        ? "Blutooth connected"
                        : "Blutooth Disconnected",
                    style: GoogleFonts.acme(color: Colors.white),
                  ),
                  IconButton(
                      icon: Icon(isBlutoothon
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled),
                      onPressed: null)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {checkBlutoothOn()},
            child: Container(
              color: Colors.teal[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blutooth Device Name",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: deviceHieght / 4,
              child: EasyRefresh(
                onRefresh: () async {
                  checkBlutoothOn();
                },
                child: ListView.builder(
                    itemCount: bluetoothDevices.length,
                    itemBuilder: (context, count) {
                      return ListTile(
                        selected: true,
                        leading: Icon(Icons.bluetooth_searching),
                        title: Text(bluetoothDevices[count].name.toString()),
                        subtitle:
                            Text(bluetoothDevices[count].address.toString()),
                        trailing: bluetoothDevices[count].connected == true
                            ? Icon(
                                Icons.bluetooth_connected,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.settings_bluetooth,
                                color: Colors.grey,
                              ),
                      );
                    }),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "More Settings",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.alef(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.music_video),
                title: Text("Sound"),
                subtitle: Text("Is Paly System Sound "),
                trailing: IconButton(
                  onPressed: () => {soundONoff(isSound)},
                  icon: Icon(
                    isSound ? Icons.volume_up : Icons.vibration,
                    color: isSound ? Colors.green : Colors.black38,
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  // setting function
  soundONoff(bool isSoundOn) async {
    final prefs = await SharedPreferences.getInstance();

    bool newStatus;
    if (isSoundOn) {
      newStatus = false;
    } else {
      newStatus = true;
    }

    prefs.setBool("isSoundOn", newStatus);
    setState(() {
      isSound = newStatus;
    });
  }
}
