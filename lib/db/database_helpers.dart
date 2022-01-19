import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_tracker/dbModels/RoutineEntry.dart';

import 'package:workout_tracker/dbModels/WorkoutEntry.dart';
import 'package:workout_tracker/dbModels/ColumnNames.dart';

// database table and column names
final String tableWorkout = 'WorkoutList';
final String tableRoutine = 'RoutineList';

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
                $columnWorkoutType TEXT NOT NULL,
                $columnMetric TEXT NOT NULL,
                $columnDescription TEXT,
                $columnPreviousSessionJson TEXT
              )
              ''');

    await db.execute('''
              CREATE TABLE $tableRoutine (
                $columnId INTEGER PRIMARY KEY,
                $columnCaption TEXT NOT NULL,
                $columnRoutineJson TEXT NOT NULL
              )
              ''');
  }

  // Database Workout Entry methods:
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
    if(entry == null)
      return 0;

    Database db = await database;
    return await db.update(tableWorkout, entry.toMap(),
        where: '$columnId = ?', whereArgs: [entry.id]);
  }
  Future<int> clearWorkoutTable() async{
    Database db = await database;
    return await db.delete(tableWorkout);
  }

  // Database Routine Entry methods:
  Future<int> insertRoutineEntry(RoutineEntry entry) async {
    Database db = await database;
    int id = await db.insert(tableRoutine, entry.toMap());
    return id;
  }
  Future<List<RoutineEntry>> queryAllRoutine() async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableRoutine');
    List<RoutineEntry> result = [];
    if (maps.length > 0) {
      for(Map i in maps){
        result.add(RoutineEntry.fromMap(i));
      }
    }
    return result;
  }
  Future<int> deleteRoutine(int id) async {
    Database db = await database;
    return await db.delete(tableRoutine, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> updateRoutine(RoutineEntry entry) async {
    Database db = await database;
    return await db.update(tableRoutine, entry.toMap(),
        where: '$columnId = ?', whereArgs: [entry.id]);
  }
  Future<int> clearRoutineTable() async{
    Database db = await database;
    return await db.delete(tableRoutine);
  }
}