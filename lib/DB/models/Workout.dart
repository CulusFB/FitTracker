import 'dart:convert';

import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';

Workout WorkoutFromJson(String str) {
  final jsonData = json.decode(str);
  return Workout.fromJson(jsonData);
}

String WorkoutToJson(Workout data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Workout {
  int id;
  String? Date;
  int Pool_activity_id;
  List<RepetitionWeight>? List_approaches;
  Workout(
      {this.id = 0,
      this.Date = '',
      this.Pool_activity_id = 0,
      List<RepetitionWeight>? List_approaches})
      : List_approaches = List_approaches ?? [];
  factory Workout.fromJson(Map<String, dynamic> _json) {
    String list_approaches = _json['List_approaches'];
    List<RepetitionWeight> repetitionList = [];
    for (var item in jsonDecode(list_approaches)) {
      repetitionList.add(RepetitionWeight(
          id: item['id'],
          weight: item['weight'],
          repetition: item['repetition']));
    }
    ;
    return new Workout(
      id: _json['id'],
      Date: _json['Date'],
      Pool_activity_id: _json['Pool_activity_id'],
      List_approaches: repetitionList,
    );
  }
  Map<String, dynamic> toJson() {
    List<dynamic> js_list = [];
    List_approaches!.forEach((approches) {
      js_list.add(json.encode(approches.toJson()));
    });
    return {
      "Date": Date,
      "Pool_activity_id": Pool_activity_id,
      "List_approaches": js_list.toString()
    };
  }
}
