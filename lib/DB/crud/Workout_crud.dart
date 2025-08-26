import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:intl/intl.dart';

dynamic newWorkoutDb(Workout workout, DBProvider dbProvider) async {
  final db = await dbProvider.database;
  workout.id = await db.insert("Workout", workout.toJson());
  // workout.id = await db.insert('Workout', workout.toJson());
  return workout;
}

dynamic getLastPosition(DBProvider dbProvider, String thisDate) async {
  final db = await dbProvider.database;
  var res = await db.query("Workout",
      where: 'date == ?', whereArgs: [thisDate], orderBy: 'Position DESC');
  try {
    return res.first['Position'];
  } on StateError catch (_) {
    return null;
  }
}

dynamic swapWorkoutDb(DBProvider dbProvider, List<Workout> workoutList) async {
  final db = await dbProvider.database;
  await db.transaction((txn) async {
    for (final workout in workoutList) {
      txn.update("Workout", workout.toJson(),
          where: 'id = ?', whereArgs: [workout.id]);
    }
  });
}

dynamic delWorkoutId(DBProvider dbProvider, int workoutId) async {
  final db = await dbProvider.database;
  await db.delete('Workout', where: 'id = ?', whereArgs: [workoutId]);
}

dynamic getWorkoutAtDay(DBProvider dbProvider, DateTime date) async {
  final db = await dbProvider.database;
  var res = await db.query("Workout",
      where: 'date like ?', whereArgs: [date.toString()], orderBy: 'Position');
  List<Workout> workouts =
      res.isNotEmpty ? res.map((c) => Workout.fromJson(c)).toList() : [];
  return workouts;
}

dynamic getDateWorkouts(DBProvider dbProvider) async {
  final db = await dbProvider.database;
  var res = await db.query('Workout', columns: ["Date"], distinct: true);
  DateFormat format = DateFormat("yyyy-MM-dd");
  List<DateTime> date = res.isNotEmpty
      ? res.map((el) => format.parse(el['Date'].toString())).toList()
      : [];
  return date;
}

dynamic getWorkoutIdDb(DBProvider dbProvider, int id) async {
  final db = await dbProvider.database;
  var res = await db.query('Workout', where: 'id = ?', whereArgs: [id]);
  Workout workout = res.isNotEmpty ? Workout.fromJson(res.first) : Workout();
  return workout;
}

dynamic updateRepetitionWeight(DBProvider dbProvider, Workout workout) async {
  final db = await dbProvider.database;
  await db.update('Workout', workout.toJson(),
      where: 'id = ?', whereArgs: [workout.id]);
}

dynamic getLastWorkout(
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

dynamic getPoolActivityBetweenDate(DBProvider dbProvider, int poolActivityId,
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
