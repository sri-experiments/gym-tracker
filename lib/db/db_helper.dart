
import 'dart:io';

import 'package:gym_tracker/db/workouts_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'workout.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          workoutCategory TEXT,
          workoutName TEXT,
          weightLifted INTEGER,
          reps INTEGER,
          sets INTEGER,
          workoutDate TEXT
      )
      ''');
  }

  Future<List<WorkoutModels>> getAllWorkout() async{
    Database db = await instance.database;
    var workoutDB = await db.query('workout');
    List<WorkoutModels> workoutList = workoutDB.isNotEmpty
        ? workoutDB.map((c) => WorkoutModels.fromMap(c)).toList()
        : [];
    return workoutList;
  }

  Future<List<WorkoutModels>> getWorkout(String workoutCategory) async {
    Database db = await instance.database;
    var workoutDB = await db.query('workout',
    where: "workoutCategory = ?", whereArgs: [workoutCategory]);
    List<WorkoutModels> workoutList = workoutDB.isNotEmpty
        ? workoutDB.map((c) => WorkoutModels.fromMap(c)).toList()
        : [];
    return workoutList;
  }

  Future<int> add(WorkoutModels wm) async {
    Database db = await instance.database;
    return await db.insert('workout', wm.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(WorkoutModels wm) async {
    Database db = await instance.database;
    return await db.update('workout', wm.toMap(),
        where: "id = ?", whereArgs: [wm.id]);
  }
}