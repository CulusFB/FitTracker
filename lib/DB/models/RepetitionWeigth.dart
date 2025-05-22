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
  double? weight;
  int? repetition;
  RepetitionWeight({
    this.weight = 0,
    this.repetition = 0,
  });
  factory RepetitionWeight.fromJson(Map<String, dynamic> json) =>
      new RepetitionWeight(
        weight: json['weight'],
        repetition: json['repetition'],
      );
  Map<String, dynamic> toJson() => {"weight": weight, "repetition": repetition};
}
