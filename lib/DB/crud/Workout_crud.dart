import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:intl/intl.dart';

newWorkoutDb(Workout workout, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.insert('Workout', workout.toJson());
  workout.id = res;
  return workout;
}

delWorkoutId(DBProvider dbProvider, int workoutId) async {
  final db = await dbProvider.database;
  await db.delete('Workout', where: 'id = ?', whereArgs: [workoutId]);
}

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

getWorkoutIdDb(DBProvider dbProvider, int id) async {
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

getLastWorkout(
    DBProvider dbProvider, int poolActivityId, String thisDate) async {
  final db = await dbProvider.database;
  var res = await db.query(
    'Workout',
    where: 'Pool_activity_id = ? and Date < ?',
    whereArgs: [poolActivityId, thisDate],
    limit: 2,
    orderBy: 'Date DESC',
  );
  try {
    List<Workout> workouts =
        res.isNotEmpty ? res.map((c) => Workout.fromJson(c)).toList() : [];
    return workouts[1];
  } catch (e) {
    return 0;
  }
}

getPoolActivityBetweenDate(DBProvider dbProvider, int poolActivityId,
    DateTime monday, DateTime sunday) async {
  final db = await dbProvider.database;
  var res = await db.query(
    'Workout',
    where: 'Pool_activity_id = ? and Date between ? and ?',
    whereArgs: [poolActivityId, monday.toString(), sunday.toString()],
    orderBy: 'Date DESC',
  );
  try {
    List<Workout> workouts =
        res.isNotEmpty ? res.map((c) => Workout.fromJson(c)).toList() : [];
    return workouts;
  } catch (e) {
    return 0;
  }
}
