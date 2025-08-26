import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';

dynamic newPoolActivity(PoolActivity poolActivity, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  return await db.insert('PoolActivity', poolActivity.toJson());
}

dynamic updatePoolActivity(PoolActivity poolActivity, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  await db.update('PoolActivity', poolActivity.toJson(), where: 'id = ?', whereArgs: [poolActivity.id]);
  return poolActivity;
}

dynamic deletePoolActivity(int id, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  await db.delete('PoolActivity', where: 'id = ?', whereArgs: [id]); 
}
// getPoolActivityId(int id) async {
//   final db = await DBProvider.db.database;
//   var res = await db.query("PoolActivity", where: 'id = ?', whereArgs: [id]);
//   return res.isNotEmpty ? PoolActivity.fromJson(res.first) : Null;
// }

dynamic getAllPoolActivity(DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.query("PoolActivity");
  var list = res.isNotEmpty ? res.map((c) => PoolActivity.fromJson(c)).toList() : [];
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
