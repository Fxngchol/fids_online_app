// ignore_for_file: file_names

class CaseFireArea {
  String? id;
  String? areaDetail;
  String? front1;
  String? left1;
  String? right1;
  String? back1;
  String? floor1;
  String? roof1;
  String? other1;
  String? front2;
  String? left2;
  String? right2;
  String? back2;
  String? center2;
  String? roof2;
  String? other2;
  CaseFireArea({
    this.id,
    this.areaDetail,
    this.front1,
    this.left1,
    this.right1,
    this.back1,
    this.floor1,
    this.roof1,
    this.other1,
    this.front2,
    this.left2,
    this.right2,
    this.back2,
    this.center2,
    this.roof2,
    this.other2,
  });

  Map<String?, dynamic> toJson() {
    return <String?, dynamic>{
      'id': id == '-2' || id == null ? '' : '$id',
      'area_detail': areaDetail,
      'front1': front1,
      'left1': left1,
      'right1': right1,
      'back1': back1,
      'floor1': floor1,
      'roof1': roof1,
      'other1': other1,
      'front2': front2,
      'left2': left2,
      'right2': right2,
      'back2': back2,
      'center2': center2,
      'roof2': roof2,
      'other2': other2,
    };
  }

  factory CaseFireArea.fromJson(Map<String?, dynamic> map) {
    return CaseFireArea(
      id: '${map['ID']}',
      areaDetail: map['AreaDetail'] as String?,
      front1: map['Front1'] as String?,
      left1: map['Left1'] as String?,
      right1: map['Right1'] as String?,
      back1: map['Back1'] as String?,
      floor1: map['Floor1'] as String?,
      roof1: map['Roof1'] as String?,
      other1: map['Other1'] as String?,
      front2: map['Front2'] as String?,
      left2: map['Left2'] as String?,
      right2: map['Right2'] as String?,
      back2: map['Back2'] as String?,
      center2: map['Center2'] as String?,
      roof2: map['Roof2'] as String?,
      other2: map['Other2'] as String?,
    );
  }

  @override
  String toString() {
    return 'CaseFireArea(id: $id, areaDetail: $areaDetail, front1: $front1, left1: $left1, right1: $right1, back1: $back1, floor1: $floor1, roof1: $roof1, other1: $other1, front2: $front2, left2: $left2, right2: $right2, back2: $back2, center2: $center2, roof2: $roof2, other2: $other2)';
  }
}
