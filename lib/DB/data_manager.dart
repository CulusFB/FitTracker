import 'package:fit_tracker/DB/data_search.dart';
import 'package:fit_tracker/DB/database_manager.dart';
import 'package:fit_tracker/DB/models/repetition_weigth.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:intl/intl.dart';

class DataManager {
  static final DataManager _instance = DataManager._();
  static DataManager get instance => _instance;

  AdvancedCalendarController calendarController = AdvancedCalendarController.today();
  late DatabaseManager dbProvider;
  late List<MuscleGroup> muscleGroups;
  late List<PoolActivity> poolActivities;
  late List<Workout> workouts = []; //TODO: Fix it when bloc
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  DataManager._() {
    initDbProvider();
    initDataManager();
  }

  dynamic initDbProvider() async {
    dbProvider = DatabaseManager();
  }

  Future<bool> initDataManager() async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    workouts = await dbProvider.workoutAtDay(date);
    muscleGroups = await dbProvider.muscleGroups();
    poolActivities = await dbProvider.poolActivities();
    return true;
  }

  dynamic getPoolActivityMuscleGroup(int id) {
    return poolActivities.where((poolActivity) => poolActivity.muscleGroupId == id).toList();
  }

  dynamic addActivity(PoolActivity poolActivity) async {
    // var id = await newPoolActivity(poolActivity, dbProvider);
    var id = await dbProvider.addPoolActivity(poolActivity);
    poolActivity.id = id;
    poolActivities.add(poolActivity);
  }

  // Тут что-то происходит странное
  dynamic editActivity(PoolActivity poolActivity) async {
    var activity = await dbProvider.editPoolActivity(poolActivity);
    // PoolActivity activity = await updatePoolActivity(poolActivity, dbProvider);
    poolActivities.removeWhere((poolActivity) => poolActivity.id == activity.id);
    poolActivities.add(activity);
    return activity;
  }

  String getPoolActivityName(int id) {
    return poolActivities.firstWhere((el) => el.id == id).nameRu as String;
  }

  dynamic removeActivity(int id) async {
    await dbProvider.removePoolActivity(id);
    // await deletePoolActivity(id, dbProvider);
    poolActivities.removeWhere((poolActivity) => poolActivity.id == id);
  }

  dynamic getWorkoutDay(DateTime date) async {
    // workouts = await getWorkoutAtDay(dbProvider, date);
    workouts = await dbProvider.workoutAtDay(date);
    return workouts;
  }

  dynamic swapWorkoutPosition(List<Workout> workoutList) async {
    var worList = workoutList;
    await dbProvider.swapWorkout(worList);
  }

  dynamic newWorkout(List<Workout> workoutList) async {
    DateTime now = calendarController.value;
    DateTime date = DateTime(now.year, now.month, now.day);
    var lastPosition = await dbProvider.lastPosition(date);
    lastPosition = lastPosition == null ? 0 : lastPosition + 1;
    for (var workout in workoutList) {
      workout.position = lastPosition;
      dbProvider.addWorkout(workout);
      // newWorkoutDb(workout, dbProvider);
      lastPosition += 1;
    }
    return null;
  }

  dynamic delWorkout(int workoutId) async {
    await dbProvider.removeWorkout(workoutId);
    workouts.removeWhere((el) => el.id == workoutId);
  }

  dynamic getWorkoutId(int workoutId) async {
    return await dbProvider.workout(workoutId);
  }

  dynamic getWorkoutLast(int poolActivityId) async {
    return await dbProvider.lastWorkout(poolActivityId, calendarController.value);
  }

  dynamic changeIdWorkout(int oldId, int newId) async {}

  dynamic addRepetitionWeight(RepetitionWeight repetitionWeight, int workoutId) async {
    var workout = await dbProvider.workout(workoutId);
    workout.approachesList?.add(repetitionWeight);
    await dbProvider.editRepetitionWeight(workout);
  }

  dynamic updAllRepetitionWeight(List<RepetitionWeight> repetitionWeight, int workoutId) async {
    var workout = await dbProvider.workout(workoutId);
    workout.approachesList = repetitionWeight;
    await dbProvider.editRepetitionWeight(workout);
  }

  Future<List<DateTime>> dateWorkouts() async {
    return await dbProvider.dateWorkouts();
  }

  dynamic delReptitioonWeight(int id, Workout workout) async {
    workout.approachesList!.removeAt(id);
    await dbProvider.editRepetitionWeight(workout);
  }

  Future<List<Workout>> getPoolActivityAll(int poolActivityId) async {
    List<Workout> workouts = await dbProvider.allActivity(poolActivityId);
    workouts
        .sort((a, b) => format.parse(a.date as String).compareTo(format.parse(b.date as String)));
    return workouts;
  }

  Future<List<Workout>> getPoolActivityWeek(int poolActivityId) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    List<Workout> workouts = await dbProvider.activityBetweenDate(
        poolActivityId, findNearestMonday(date), findNearestSunday(date));
    workouts
        .sort((a, b) => format.parse(a.date as String).compareTo(format.parse(b.date as String)));
    return workouts;
  }

  Future<List<Workout>> getPoolActivityMonth(int poolActivityId) async {
    DateTime now = DateTime.now();
    List<Workout> workouts = await dbProvider.activityBetweenDate(
        poolActivityId, DateTime(now.year, now.month - 1, now.day), now);
    workouts
        .sort((a, b) => format.parse(a.date as String).compareTo(format.parse(b.date as String)));
    return workouts;
  }

  dynamic getPoolActivityYear(int poolActivityId) async {
    DateTime now = DateTime.now();
    List<Workout> workouts = await dbProvider.activityBetweenDate(
        poolActivityId, DateTime(now.year, 1, 1), DateTime(now.year, 12, 31));
    workouts
        .sort((a, b) => format.parse(a.date as String).compareTo(format.parse(b.date as String)));
    return workouts;
  }

  //load data method-> load all data in db
  //getters method for get data
  //methods for add, edit, remove data
}
