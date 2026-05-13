import 'dart:io';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  final String _muscleGroupTable = "MuscleGroup";
  final String _poolActivityTable = "PoolActivity";
  final String _workoutTable = "Workout";

  static Database? _database;

  Future<Database> get _initConnection async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> get reinitConnection async {
    _database = await initDB();
    return _database!;
  }

  void printMessage(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }

  dynamic initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "TestDB.fittracker");
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      printMessage("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets/database", "TestDB.fittracker"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      printMessage("Opening existing database");
    }
    return await openDatabase(path, readOnly: false);
  }

  dynamic addMuscleGroup(MuscleGroup muscleGroup) async {
    final db = await _initConnection;
    return db.insert(_muscleGroupTable, muscleGroup.toJson());
  }

  dynamic muscleGroup(int id) async {
    var db = await _initConnection;
    var result = await db.query(_muscleGroupTable, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? MuscleGroup.fromJson(result.first) : Null;
  }

  dynamic muscleGroups() async {
    var db = await _initConnection;
    var result = await db.query(_muscleGroupTable);
    return result.isNotEmpty ? result.map((item) => MuscleGroup.fromJson(item)).toList() : {};
  }

  dynamic addPoolActivity(PoolActivity activity) async {
    var db = await _initConnection;
    return await db.insert(_poolActivityTable, activity.toJson());
  }

  dynamic editPoolActivity(PoolActivity activity) async {
    var db = await _initConnection;
    return await db.update(
        _poolActivityTable, where: 'id = ?', whereArgs: [activity.id], activity.toJson());
  }

  dynamic removePoolActivity(int id) async {
    var db = await _initConnection;
    return await db.delete(_poolActivityTable, where: 'id = ?', whereArgs: [id]);
  }

  dynamic poolActivity(int id) async {
    var db = await _initConnection;
    var result = await db.query(_poolActivityTable, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? PoolActivity.fromJson(result.first) : Null;
  }

  dynamic poolActivities() async {
    var db = await _initConnection;
    var result = await db.query(_poolActivityTable);
    List<PoolActivity> list = [];
    return result.isNotEmpty ? result.map((item) => PoolActivity.fromJson(item)).toList() : list;
  }

  dynamic addWorkout(Workout workout) async {
    var db = await _initConnection;
    return await db.insert(_workoutTable, workout.toJson());
  }

  dynamic editWorkout(Workout workout) async {
    var db = await _initConnection;
    return await db.update(_workoutTable, workout.toJson());
  }

  dynamic removeWorkout(int id) async {
    var db = await _initConnection;
    return await db.delete(_workoutTable, where: 'id = ?', whereArgs: [id]);
  }

  Future workout(int id) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Workout.fromJson(result.first) : Null;
  }

  dynamic workouts(DateTime date) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'date like ?', whereArgs: [date.toString()], orderBy: 'Position');
    return result.isNotEmpty ? result.map((item) => Workout.fromJson(item)).toList() : {};
  }

  dynamic editRepetitionWeight(Workout workout) async {
    var db = await _initConnection;
    return await db
        .update(_workoutTable, workout.toJson(), where: 'id = ?', whereArgs: [workout.id]);
  }

  dynamic lastWorkout(int activityId, DateTime date) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'Pool_activity_id = ? and Date < ?',
        whereArgs: [activityId, date.toString()],
        limit: 2,
        orderBy: 'Date DESC');

    //TODO Отрефакторить этот блок нормально
    try {
      var workouts = result.isNotEmpty ? result.map((item) => Workout.fromJson(item)).toList() : [];
      return workouts[1];
    } catch (e) {
      return 0;
    }
  }

  dynamic allActivity(int activityId) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'Pool_activity_id = ?', whereArgs: [activityId], orderBy: 'Date DESC');
    return result.isNotEmpty ? result.map((item) => Workout.fromJson(item)).toList() : [];
  }

  dynamic activityBetweenDate(int activityId, DateTime monday, DateTime sunday) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'Pool_activity_id = ? and Date between ? and ?',
        whereArgs: [activityId, monday.toString(), sunday.toString()],
        orderBy: 'Date DESC');
    return result.isNotEmpty ? result.map((item) => Workout.fromJson(item)).toList() : <Workout>[];
  }

  Future<List<DateTime>> dateWorkouts() async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable, columns: ["Date"], distinct: true);
    DateFormat format = DateFormat("yyyy-MM-dd");
    return result.isNotEmpty
        ? result.map((item) => format.parse(item['Date'].toString())).toList()
        : [];
  }

  dynamic workoutAtDay(DateTime date) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'date like ?', whereArgs: [date.toString()], orderBy: 'Position');
    List<Workout> list = [];
    return result.isNotEmpty ? result.map((item) => Workout.fromJson(item)).toList() : list;
  }

  dynamic swapWorkout(List<Workout> workouts) async {
    var db = await _initConnection;
    return await db.transaction((action) async {
      for (var workout in workouts) {
        action.update(_workoutTable, workout.toJson(), where: 'id = ?', whereArgs: [workout.id]);
      }
    });
  }

  dynamic lastPosition(DateTime date) async {
    var db = await _initConnection;
    var result = await db.query(_workoutTable,
        where: 'date == ?', whereArgs: [date.toString()], orderBy: 'Position DESC');
    //TODO переписать эту фигню
    try {
      return result.first['Position'];
    } catch (e) {
      return null;
    }
  }
}
