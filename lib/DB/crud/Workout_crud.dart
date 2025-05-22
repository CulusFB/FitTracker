import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:intl/intl.dart';

newWorkoutDb(Workout workout, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.insert('Workout', workout.toJson());
  workout.id = res;
  return workout;
}

// updatePoolActivity(PoolActivity poolActivity, DBProvider dbProvider) async {
//   final db = await dbProvider.database;
//   await db.update('PoolActivity', poolActivity.toJson(),
//       where: 'id = ?', whereArgs: [poolActivity.id]);
//   return poolActivity;
// }

// deletePoolActivity(int id, DBProvider dbProvider) async {
//   final db = await dbProvider.database;
//   await db.delete('PoolActivity', where: 'id = ?', whereArgs: [id]);
// }
// getPoolActivityId(int id) async {
//   final db = await DBProvider.db.database;
//   var res = await db.query("PoolActivity", where: 'id = ?', whereArgs: [id]);
//   return res.isNotEmpty ? PoolActivity.fromJson(res.first) : Null;
// }

getWorkoutAtDay(DBProvider dbProvider, DateTime date) async {
  final db = await dbProvider.database;
  var res = await db
      .query("Workout", where: 'date like ?', whereArgs: [date.toString()]);
  List<Workout> workouts =
      res.isNotEmpty ? res.map((c) => Workout.fromJson(c)).toList() : [];
  return workouts;
}

getDateWorkouts(DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.query('Workout', columns: ["Date"], distinct: true);
  DateFormat format = DateFormat("yyyy-MM-dd");
  List<DateTime> date = res.isNotEmpty
      ? res.map((el) => format.parse(el['Date'].toString())).toList()
      : [];
  return date;
}

getWorkoutId(DBProvider dbProvider, int id) async {
  final db = await dbProvider.database;
  var res = await db.query('Workout', where: 'id = ?', whereArgs: [id]);
  Workout workout = res.isNotEmpty ? Workout.fromJson(res.first) : Workout();
  return workout;
}

updateRepetitionWeight(DBProvider dbProvider, Workout workout) async {
  final db = await dbProvider.database;
  await db.update('Workout', workout.toJson(),
      where: 'id = ?', whereArgs: [workout.id]);
}
