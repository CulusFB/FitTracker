import 'dart:convert';

import 'package:fit_tracker/DB/models/repetition_weigth.dart';

Workout workoutFromJson(String str) {
  final jsonData = json.decode(str);
  return Workout.fromJson(jsonData);
}

String workoutToJson(Workout data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Workout {
  int id;
  String? date;
  int poolActivityId;
  List<RepetitionWeight>? approachesList;
  int position;
  Workout(
      {this.id = 0,
      this.date = '',
      this.poolActivityId = 0,
      this.position = -1,
      List<RepetitionWeight>? approaches})
      : approachesList = approaches ?? [];
      
  factory Workout.fromJson(Map<String, dynamic> json) {
    String approaches = json['List_approaches'];
    List<RepetitionWeight> repetitionList = [];
    for (var item in jsonDecode(approaches)) {
      repetitionList.add(RepetitionWeight(
          weight: item['weight'], repetition: item['repetition']));
    }
    return Workout(
        id: json['id'],
        date: json['Date'],
        poolActivityId: json['Pool_activity_id'],
        approaches: repetitionList,
        position: json['Position']);
  }

  void copy(Workout other) {
    id = other.id;
    date = other.date;
    poolActivityId = other.poolActivityId;
    approachesList = other.approachesList;
    position = other.position;
  }

  Map<String, dynamic> toJson() {
    List<dynamic> jsList = [];
    for (var approches in approachesList!) {
      jsList.add(json.encode(approches.toJson()));
    }
    return {
      "Date": date,
      "Pool_activity_id": poolActivityId,
      "List_approaches": jsList.toString(),
      "Position": position
    };
  }
}
