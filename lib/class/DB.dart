import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

crateDB() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'iTeaGereenD.db');

// open the database
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // suplierTable
    await db.execute(
        'CREATE TABLE Spulier (id INTEGER PRIMARY KEY, name TEXT, Ref INTEGER , CardID TEXT ,RegNo TEXT , Root TEXT, RootRef INTEGER,JobId INTEGER)');

    // lefeRecodes_T
    // await db.execute(
    //     'CREATE TABLE lefeRecodes_T (id INTEGER PRIMARY KEY, Suplier INTEGER, TotalWeight NUMERIC , BagCount INTEGER , Water NUMERIC , Tare NUMERIC, bagWeight NUMERIC , Coarse NUMERIC, leafType Text, PureWeight NUMERIC ,  RootRef INTEGER,let TEXT,lang TEXT, DateTime TEXT,IsUpdate INTEGER,JobId INTEGER)');
  });

  print(database);
}

deleteDB() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'iTeaGereenD.db');

// Delete the database
  await deleteDatabase(path);
}
