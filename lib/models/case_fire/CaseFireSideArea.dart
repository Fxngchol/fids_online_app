// ignore_for_file: file_names

class CaseFireSideArea {
  String? id;
  String? sideAreaDetail;
  CaseFireSideArea({this.id, this.sideAreaDetail});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id == '-2' || id == null ? '' : '$id',
      'side_area_detail': sideAreaDetail,
    };
  }

  factory CaseFireSideArea.fromJson(Map<String, dynamic> map) {
    return CaseFireSideArea(
      id: '${map['ID']}',
      sideAreaDetail: map['SideAreaDetail'] as String,
    );
  }

  @override
  String toString() =>
      'CaseFireSideArea(id: $id, sideAreaDetail: $sideAreaDetail)';
}
