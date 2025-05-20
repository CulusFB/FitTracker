import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/crud/Workout_crud.dart';
import 'package:fit_tracker/DB/crud/muscleGroup_crud.dart';
import 'package:fit_tracker/DB/crud/poolActivity_crud.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';

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

  //load data method-> load all data in db
  //getters method for get data
  //methods for add, edit, remove data
}
