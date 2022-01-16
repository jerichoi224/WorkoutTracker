import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:workout_tracker/util/typedef.dart';

// database table and column names
final String tableWorkout = 'WorkoutList';
final String tableRoutine = 'RoutineList';

final String tableSubscriptions = 'tableSubscriptions';

final String columnId = '_id';
final String columnCaption = 'caption';
final String columnPart = 'part';
final String columnType = 'type';
final String columnMetric = 'metric';
final String columnDescription = 'description';


// data model class
class WorkoutEntry {
  int id;
  MetricType metric;
  WorkoutType type;
  PartType part;
  String caption;
  String description;

  WorkoutEntry();

  // convenience constructor to create a Word object
  WorkoutEntry.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    caption = map[columnCaption];
    description = map[columnDescription];
    type = WorkoutType.values.firstWhere((e) => e.name == map[columnType]);
    part = PartType.values.firstWhere((e) => e.name == map[columnPart]);
    metric = MetricType.values.firstWhere((e) => e.name == map[columnMetric]);
  }

  // convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnType: type.name,
      columnPart: part.name,
      columnMetric: metric.name,
      columnCaption: caption,
      columnDescription: description,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "{id: $id, caption: $caption, type: ${type.name}, part: ${part.name}, metric: ${metric.name}, description: $description}";
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "WorkoutDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableWorkout (
                $columnId INTEGER PRIMARY KEY,
                $columnCaption TEXT NOT NULL,
                $columnPart TEXT NOT NULL,
                $columnType TEXT NOT NULL,
                $columnMetric TEXT NOT NULL,
                $columnDescription TEXT
              )
              ''');
  }

  // Database helper methods:
  Future<int> insertWorkoutEntry(WorkoutEntry entry) async {
    Database db = await database;
    int id = await db.insert(tableWorkout, entry.toMap());
    return id;
  }

  Future<List<WorkoutEntry>> queryAllWorkout() async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableWorkout');
    List<WorkoutEntry> result = [];
    if (maps.length > 0) {
      for(Map i in maps){
        result.add(WorkoutEntry.fromMap(i));
      }
    }
    return result;
  }

  Future<int> deleteWorkout(int id) async {
    Database db = await database;
    return await db.delete(tableWorkout, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateWorkout(WorkoutEntry entry) async {
    Database db = await database;
    return await db.update(tableWorkout, entry.toMap(),
        where: '$columnId = ?', whereArgs: [entry.id]);
  }

  Future<int> clearWorkoutTable() async{
    Database db = await database;
    return await db.delete(tableWorkout);
  }
}