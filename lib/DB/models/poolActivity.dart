import 'dart:convert';

PoolActivity poolActivityFromJson(String str) {
  final jsonData = json.decode(str);
  return PoolActivity.fromJson(jsonData);
}

String poolActivityToJson(PoolActivity data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class PoolActivity {
  int id;
  int MuscleGroupId;
  String? Name_ru;
  String? Name_en;
  String? label;
  PoolActivity(
      {this.id = 0,
      this.Name_ru = '',
      this.Name_en = '',
      this.MuscleGroupId = 0,
      this.label = ''});
  factory PoolActivity.fromJson(Map<String, dynamic> json) => new PoolActivity(
      id: json['id'],
      MuscleGroupId: json['MuscleGroupId'],
      Name_ru: json['Name_ru'],
      Name_en: json['Name_en'],
      label: json['label']);
  Map<String, dynamic> toJson() => {
        "Name_ru": Name_ru,
        'Name_en': Name_en,
        "MuscleGroupId": MuscleGroupId,
        "label": label
      };
}
