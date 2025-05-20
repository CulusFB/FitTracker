import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/Workout.dart';

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
