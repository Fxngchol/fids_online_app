// ignore_for_file: file_names
import 'FidsCrimeSceneAPI.dart';

class CrimesceneApi {
  String? fidsNo;
  String? action;
  String? userId;
  List<FidsCrimeSceneAPI>? fidsCrimeScene;

  CrimesceneApi({this.fidsNo, this.action, this.userId, this.fidsCrimeScene});

  Map<String, dynamic> toJson() {
    return {
      'fidsno': '$fidsNo',
      'action': action,
      'user_id': userId,
      'fids_crime_scene': fidsCrimeScene,
    };
  }
}
