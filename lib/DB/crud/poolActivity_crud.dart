import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';

newPoolActivity(PoolActivity poolActivity, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.insert('PoolActivity', poolActivity.toJson());
  poolActivity.id = res;
  return poolActivity;
}

// getPoolActivityId(int id) async {
//   final db = await DBProvider.db.database;
//   var res = await db.query("PoolActivity", where: 'id = ?', whereArgs: [id]);
//   return res.isNotEmpty ? PoolActivity.fromJson(res.first) : Null;
// }

getAllPoolActivity(DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.query("PoolActivity");
  List<PoolActivity> list =
      res.isNotEmpty ? res.map((c) => PoolActivity.fromJson(c)).toList() : [];
  return list;
}

// getPoolActivityMuscleGroupID(int muscleGroupId) async {
//   final db = await DBProvider.db.database;
//   var res = await db.query("PoolActivity",
//       where: 'MuscleGroupId = ?', whereArgs: [muscleGroupId]);
//   List<PoolActivity> list =
//       res.isNotEmpty ? res.map((c) => PoolActivity.fromJson(c)).toList() : [];
//   return list;
// }
