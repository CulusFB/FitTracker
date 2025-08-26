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
  dynamic initDbProvider() async {
    dbProvider = DBProvider();
    await dbProvider.initDB();
  }

  static final DataManager _instance = DataManager._();
  static DataManager get instance => _instance;

  AdvancedCalendarController get calendarController => AdvancedCalendarController.today();
  late DBProvider dbProvider;
  late List<MuscleGroup> muscleGroups;
  late List<PoolActivity> poolActivities;
  late List<Workout> workouts = []; //TODO: Fix it when bloc
  
  Future<bool> initDataManager() async {
    DateTime now =  DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    workouts = await getWorkoutAtDay(dbProvider, date);
    muscleGroups = await getAllMuscleGroup(dbProvider);
    poolActivities = await getAllPoolActivity(dbProvider);
    return true;
  }

  dynamic getPoolActivityMuscleGroup(int id) {
    return poolActivities
        .where((poolActivity) => poolActivity.muscleGroupId == id)
        .toList();
  }

  dynamic addActivity(PoolActivity poolActivity) async {
    var id = await newPoolActivity(poolActivity, dbProvider);
    poolActivity.id = id;
    poolActivities.add(poolActivity);
  }

  dynamic editActivity(PoolActivity poolActivity) async {
    PoolActivity activity = await updatePoolActivity(poolActivity, dbProvider);
    poolActivities.removeWhere((poolActivity) => poolActivity.id == activity.id);
    poolActivities.add(activity);
    return activity;
  }
  //FIXME функция хуета подумать бы еще =)
  String getPoolActivityName(int id) {
    return poolActivities.firstWhere((el) => el.id == id).nameRu
        as String;
  }

  dynamic removeActivity(int id) async {
    await deletePoolActivity(id, dbProvider);
    poolActivities.removeWhere((poolActivity) => poolActivity.id == id);
  }

  dynamic getWorkoutDay(DateTime date) async {
    workouts = await getWorkoutAtDay(dbProvider, date);
    return workouts;
  }

  dynamic swapWorkoutPosition(List<Workout> workoutList) async {
    await swapWorkoutDb(dbProvider, workoutList);
  }

  dynamic newWorkout(List<Workout> workoutList) async {
    DateTime now = calendarController.value;
    DateTime date = DateTime(now.year, now.month, now.day);
    var lastPosition = await getLastPosition(dbProvider, date.toString());
    lastPosition = lastPosition == null ? 0 : lastPosition + 1;
    for (var workout in workoutList) {
      workout.position = lastPosition;
      newWorkoutDb(workout, dbProvider);
      lastPosition += 1;
    }
    return null;
  }

  dynamic delWorkout(int workoutId) async {
    await delWorkoutId(dbProvider, workoutId);
    workouts.removeWhere((el) => el.id == workoutId);
  }

  dynamic getWorkoutId(int workoutId) async {
    return await getWorkoutIdDb(dbProvider, workoutId);
  }

  dynamic getWorkoutLast(int poolActivityId) async {
    return await getLastWorkout(
        dbProvider, poolActivityId, calendarController.value.toString());
  }

  dynamic changeIdWorkout(int oldId, int newId) async {}

  dynamic addRepetitionWeight(RepetitionWeight repetitionWeight, int workoutId) async {
    Workout workout = await getWorkoutIdDb(dbProvider, workoutId);
    workout.approachesList?.add(repetitionWeight);
    await updateRepetitionWeight(dbProvider, workout);
  }

  dynamic updAllRepetitionWeight(
      List<RepetitionWeight> repetitionWeight, int workoutId) async {
    Workout workout = await getWorkoutIdDb(dbProvider, workoutId);
    workout.approachesList = repetitionWeight;
    await updateRepetitionWeight(dbProvider, workout);
  }

  dynamic dateWorkouts() async {
    List<DateTime> date = await getDateWorkouts(dbProvider);
    return date;
  }

  dynamic delReptitioonWeight(int id, Workout workout) async {
    workout.approachesList!.removeAt(id);
    await updateRepetitionWeight(dbProvider, workout);
  }

  dynamic getPoolActivityWeek(int poolActivityId) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        findNearestMonday(date), findNearestSunday(date));
  }

  dynamic getPoolActivityMonth(int poolActivityId) async {
    DateTime now = DateTime.now();
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 0));
  }

  dynamic getPoolActivityYear(int poolActivityId) async {
    DateTime now = DateTime.now();
    return await getPoolActivityBetweenDate(dbProvider, poolActivityId,
        DateTime(now.year, 1, 1), DateTime(now.year, 12, 31));
  }

  //load data method-> load all data in db
  //getters method for get data
  //methods for add, edit, remove data
}
