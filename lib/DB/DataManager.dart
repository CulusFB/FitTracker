import 'package:fit_tracker/DB/Database.dart';
import 'package:fit_tracker/DB/crud/muscleGroup_crud.dart';
import 'package:fit_tracker/DB/crud/poolActivity_crud.dart';
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
  initDataManager() async {
    muscleGroup = await getAllMuscleGroup(dbProvider);
    poolActivity = await getAllPoolActivity(dbProvider);
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

  //load data method-> load all data in db
  //getters method for get data
  //methods for add, edit, remove data
}
