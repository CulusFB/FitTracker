import 'package:fit_tracker/DB/DataSearch.dart';
import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/crud/Workout_crud.dart';
import 'package:fit_tracker/DB/crud/muscleGroup_crud.dart';
import 'package:fit_tracker/DB/crud/poolActivity_crud.dart';
import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

class DataManager {
  DataManager._() {
    initDbProvider();
    initDataManager();
  }
  initDbProvider() async {
    dbProvider = DBProvider();
    await dbProvider.initDB();
  }

  static DataManager _instance = DataManager._();
  static DataManager get instance => _instance;
  late AdvancedCalendarController calendarController =
      AdvancedCalendarController.today();
  late DBProvider dbProvider;
  late List<MuscleGroup> muscleGroup;
  late List<PoolActivity> poolActivity;
  late List<Workout> workout = []; //TODO: Fix it when bloc
  Future<bool> initDataManager() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    workout = await getWorkoutAtDay(dbProvider, date);
    muscleGroup = await getAllMuscleGroup(dbProvider);
    poolActivity = await getAllPoolActivity(dbProvider);
    return true;
  }

  getPoolActivityMuscleGroup(int id) {
    return poolActivity
        .where((poolActivity) => poolActivity.MuscleGroupId == id)
        .toList();
  }

  newActivity(PoolActivity _poolActivity) async {
    PoolActivity activity = await newPoolActivity(_poolActivity, dbProvider);
    poolActivity.add(activity);
    return activity;
  }

  updateActivity(PoolActivity _poolActivity) async {
    PoolActivity activity = await updatePoolActivity(_poolActivity, dbProvider);
    poolActivity.removeWhere((poolActivity) => poolActivity.id == activity.id);
    poolActivity.add(activity);
    return activity;
  }

  String getPoolActivityName(int poolActivityId) {
    return poolActivity.firstWhere((el) => el.id == poolActivityId).Name_ru
        as String;
  }

  deleteActivity(int id) async {
    await deletePoolActivity(id, dbProvider);
    poolActivity.removeWhere((poolActivity) => poolActivity.id == id);
  }

  getWorkoutDay(DateTime date) async {
    List<Workout> _workouts = await getWorkoutAtDay(dbProvider, date);
    workout = _workouts;
    return _workouts;
  }

  newWorkout(List<Workout> _listWorkout) async {
    _listWorkout.forEach((_workout) async {
      await newWorkoutDb(_workout, dbProvider);
    });
    return null;
  }

  delWorkout(int workoutId) async {
    await delWorkoutId(dbProvider, workoutId);
    workout.removeWhere((el) => el.id == workoutId);
  }

  getWorkoutId(int workoutId) async {
    return await getWorkoutIdDb(dbProvider, workoutId);
  }

  getWorkoutLast(int poolActivityId) async {
    return await getLastWorkout(
        dbProvider, poolActivityId, calendarController.value.toString());
  }

  addRepetitionWeight(RepetitionWeight repetitionWeight, int workoutId) async {
    Workout workout = await getWorkoutIdDb(dbProvider, workoutId);
    workout.List_approaches?.add(repetitionWeight);
    await updateRepetitionWeight(dbProvider, workout);
  }

  updAllRepetitionWeight(
      List<RepetitionWeight> repetitionWeight, int workoutId) async {
    Workout workout = await getWorkoutIdDb(dbProvider, workoutId);
    workout.List_approaches = repetitionWeight;
    await updateRepetitionWeight(dbProvider, workout);
  }

  dateWorkouts() async {
    List<DateTime> date = await getDateWorkouts(dbProvider);
    return date;
  }

  delReptitioonWeight(int id, Workout _workout) async {
    _workout.List_approaches!.removeAt(id);
    await updateRepetitionWeight(dbProvider, _workout);
  }

  getPoolActivityWeek(int poolActivityId) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        findNearestMonday(date), findNearestSunday(date));
  }

  getPoolActivityMonth(int poolActivityId) async {
    DateTime now = new DateTime.now();
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 0));
  }

  getPoolActivityYear(int poolActivityId) async {
    DateTime now = new DateTime.now();
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        DateTime(now.year, 1, 1), DateTime(now.year, 12, 31));
  }

  //load data method-> load all data in db
  //getters method for get data
  //methods for add, edit, remove data
}
