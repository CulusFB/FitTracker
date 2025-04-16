import 'package:fit_tracker/DB/crud/muscleGroup_crud.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';

class DataManager {
  late MuscleGroup muscleGroup;
  late PoolActivity poolActivity;
  initDataManager() async {
    muscleGroup = await getAllMuscleGroup();
  }
}
