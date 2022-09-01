import 'package:gym_tracker/db/workout_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDb{
  static final WorkoutDb instance = WorkoutDb._init();

  static Database? _database;

  WorkoutDb._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('workout.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE $tableWorkout
    (${WorkoutFields.id} $idType, ${WorkoutFields.workoutCategory} $textType,
    ${WorkoutFields.workoutName} $textType,
    ${WorkoutFields.weightLifted} $integerType, ${WorkoutFields.reps} $integerType,
    ${WorkoutFields.sets} $integerType,
    ${WorkoutFields.workedOutOn} $textType)
    ''');
  }

  Future<WorkoutModel> create(WorkoutModel wm) async{
    final db = await instance.database;

    final id = await db.insert(tableWorkout, wm.toJson());

    return wm.copy(id: id);
  }

  Future<int> update(WorkoutModel wm) async{
    final db = await instance.database;

    return await db.update(
      tableWorkout,
      wm.toJson(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [wm.id],
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;

    return await db.delete(
      tableWorkout,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<WorkoutModel>> getWorkoutByCategory(String category) async{
    final db = await instance.database;
    final map = await db.query(
      tableWorkout,
      columns: WorkoutFields.values,
      where: '${WorkoutFields.workoutCategory} = ?',
      whereArgs: [category],
    );

    if(map.isNotEmpty){
      return map.map((json) => WorkoutModel.fromJson(json)).toList();
    }
    else{
      throw Exception('$category not found');
    }
  }

  Future<WorkoutModel> getWorkoutById(int id) async{
    final db = await instance.database;

    final map = await db.query(
      tableWorkout,
      columns: WorkoutFields.values,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
    if(map.isNotEmpty){
      return WorkoutModel.fromJson(map.first);
    }
    else{
      throw Exception("Workout not present");
    }
  }

  Future<List<WorkoutModel>> getAllWorkout() async{
    final db = await instance.database;

    final orderBy = '${WorkoutFields.workedOutOn} ASC';
    final result = await db.query(tableWorkout, orderBy: orderBy);

    return result.map((json) => WorkoutModel.fromJson(json)).toList();
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }
}