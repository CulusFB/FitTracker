import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';

// newMuscleGroup(MuscleGroup newMuscleGroup) async {
//   final db = await DBProvider.db.database;
//   var res = await db.insert('MuscleGroup', newMuscleGroup.toJson());
//   return res;
// }

// getMuscleGroupId(int id,) async {
//   final db = await DBProvider.db.database;
//   var res = await db.query("MuscleGroup", where: 'id = ?', whereArgs: [id]);
//   return res.isNotEmpty ? MuscleGroup.fromJson(res.first) : Null;
// }

dynamic getAllMuscleGroup(DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.query("MuscleGroup");
  Object list =
      res.isNotEmpty ? res.map((c) => MuscleGroup.fromJson(c)).toList() : {};
  return list;
}
