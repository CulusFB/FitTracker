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
  int muscleGroupId;
  String? nameRu;
  String? nameEn;
  String? label;
  PoolActivity(
      {this.id = 0,
      this.nameRu = '',
      this.nameEn = '',
      this.muscleGroupId = 0,
      this.label = ''});
  factory PoolActivity.fromJson(Map<String, dynamic> json) => PoolActivity(
      id: json['id'],
      muscleGroupId: json['MuscleGroupId'],
      nameRu: json['Name_ru'],
      nameEn: json['Name_en'],
      label: json['label']);
  Map<String, dynamic> toJson() => {
        "Name_ru": nameRu,
        'Name_en': nameEn,
        "MuscleGroupId": muscleGroupId,
        "label": label
      };
}
