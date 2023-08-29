// ignore_for_file: file_names
import 'FidsCrimeSceneBombAPI.dart';

class CrimesceneBombApi {
  String? fidsNo;
  String? action;
  String? userId;
  List<FidsCrimeSceneBombAPI>? fidsCrimeScene;

  CrimesceneBombApi(
      {this.fidsNo, this.action, this.userId, this.fidsCrimeScene});

  Map<String, dynamic> toJson() {
    return {
      'fidsno': '$fidsNo',
      'action': action,
      'user_id': userId,
      'fids_crime_scene': fidsCrimeScene,
    };
  }
}
