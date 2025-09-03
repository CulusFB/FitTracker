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
  String? nameRu;
  String? nameEn;
  MuscleGroup({this.id = 0, this.nameRu = '', this.nameEn = ''});
  factory MuscleGroup.fromJson(Map<String, dynamic> json) => MuscleGroup(
      id: json['id'], nameRu: json['Name_ru'], nameEn: json['Name_en']);
  Map<String, dynamic> toJson() => {"Name_ru": nameRu, 'Name_en': nameEn};
}
