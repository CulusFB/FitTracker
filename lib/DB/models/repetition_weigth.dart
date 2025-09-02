import 'dart:convert';

RepetitionWeight repetitionWeightFromJson(String str) {
  final jsonData = json.decode(str);
  return RepetitionWeight.fromJson(jsonData);
}

String repetitionWeightToJson(RepetitionWeight data) {
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
      RepetitionWeight(
        weight: json['weight'],
        repetition: json['repetition'],
      );
  Map<String, dynamic> toJson() => {"weight": weight, "repetition": repetition};
}
