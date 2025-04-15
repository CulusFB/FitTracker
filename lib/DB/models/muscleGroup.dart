import 'dart:convert';

MuscleGroup muscleGroupFromJson(String str) {
  final jsonData = json.decode(str);
  return MuscleGroup.fromJson(jsonData);
}

String muscleGroupToJson(MuscleGroup data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class MuscleGroup {
  int id;
  String? Name_ru;
  String? Name_en;
  MuscleGroup({this.id = 0, this.Name_ru = '', this.Name_en = ''});
  factory MuscleGroup.fromJson(Map<String, dynamic> json) => new MuscleGroup(
      id: json['id'], Name_ru: json['Name_ru'], Name_en: json['Name_en']);
  Map<String, dynamic> toJson() => {"Name_ru": Name_ru, 'Name_en': Name_en};
}
