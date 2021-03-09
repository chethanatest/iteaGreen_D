import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itea_green_d/Screen/mainScreenTab/sync.dart';
import 'package:itea_green_d/push_nofitications.dart';

import 'mainScreenTab/homeTab.dart';
import 'mainScreenTab/settingTab.dart';
import 'mainScreenTab/suplierTab.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  FlutterLocalNotificationsPlugin fltrNotification;
  int _screenIndex;
  @override
  void initState() {
    _screenIndex = 0;
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  setScreenIndex(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  Future notificationSelected(String payload) async {
    showDialog();
  }

  Future showNotification(String title, String msg) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "ITS DATA Link", "iTea Deduction",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    await fltrNotification.show(0, "$title", "$msg", generalNotificationDetails,
        payload: "Task");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.teal,
        color: Colors.teal,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
          Icon(Icons.settings_backup_restore, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setScreenIndex(index);
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Screen(),
        ),
      ),
    );
  }

  Widget Screen() {
    switch (_screenIndex) {
      case 0:
        return homeTab();
        break;
      case 1:
        return suplierTab();
        break;
      case 2:
        return settingTab();
        break;
      case 3:
        return sync();

        break;
      default:
        return Text("1");
        break;
    }
  }
}
