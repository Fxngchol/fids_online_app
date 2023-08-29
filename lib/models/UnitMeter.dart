// ignore_for_file: file_names

import 'dart:convert';

class UnitMeter {
  int? id;
  String? unitLabel;
  UnitMeter({
    this.id,
    this.unitLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unitLabel': unitLabel,
    };
  }

  factory UnitMeter.fromMap(Map<String, dynamic> map) {
    return UnitMeter(
      id: map['id'],
      unitLabel: map['unitLabel'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitMeter.fromJson(String source) =>
      UnitMeter.fromMap(json.decode(source));

  @override
  String toString() => 'UnitMeter(id: $id, unitLabel: $unitLabel)';
}
