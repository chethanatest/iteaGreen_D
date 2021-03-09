import 'package:sqflite/sqflite.dart';

class Supplier {
  String name;
  int Ref;
  String CardID;
  String RegNo;
  int RootRef;
  String Root;
  int JobId;

  Supplier(int id, String name, int Ref, String CardID, String RegNo,
      int RootRef, String Root, int JobId) {
    this.name = name;
    this.Ref = Ref;
    this.CardID = CardID;
    this.RegNo = RegNo;
    this.RootRef = RootRef;
    this.Root = Root;
    this.JobId = JobId;
  }

  Supplier.fromServer(Map value, int job) {
    this.name = value['name'];
    this.Ref = value['id'];
    this.CardID = value['cardId'];
    this.RegNo = value['regNo'];
    this.RootRef = value['route'];
    this.Root = value['routeN'];
    this.JobId = job;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "Ref": Ref,
        "CardID": CardID,
        "RegNo": RegNo,
        "Root": Root,
        "RootRef": RootRef,
        "JobId": JobId,
      };

  addtoDataBase() async {
    var database = await openDatabase('iTeaGereen.db');
    int recordId = await database.insert('Spulier', {
      'RegNo': this.RegNo,
      'CardID': this.CardID,
      'name': this.name,
      'Root': this.Root,
      'RootRef': this.RootRef,
      'JobId': this.JobId,
    });
  }
}
