import 'dart:convert';

RepetitionWeight RepetitionWeightFromJson(String str) {
  final jsonData = json.decode(str);
  return RepetitionWeight.fromJson(jsonData);
}

String RepetitionWeightToJson(RepetitionWeight data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class RepetitionWeight {
  int id;
  double? weight;
  int? repetition;
  RepetitionWeight({
    this.id = 0,
    this.weight = 0,
    this.repetition = 0,
  });
  factory RepetitionWeight.fromJson(Map<String, dynamic> json) =>
      new RepetitionWeight(
        id: json['id'],
        weight: json['weight'],
        repetition: json['repetition'],
      );
  Map<String, dynamic> toJson() =>
      {"id": id, "weight": weight, "repetition": repetition};
}
