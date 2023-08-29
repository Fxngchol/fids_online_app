// ignore_for_file: file_names

import 'CaseInspection.dart';
import 'CaseInspector.dart';
import 'CaseRelatedPerson.dart';
import 'FidsCrimeScene.dart';

class Upload {
  String? fidsId;
  String? action;
  FidsCrimeScene? fidsCrimeScene;
  CaseRelatedPerson? caseRelatedPerson;
  CaseInspection? caseInspection;
  CaseInspector? caseInspector;
}

var jsonData = {
  "fids_id": 0,
  "action": "update",
  "fids_crime_scene": {
    "fids_id": 0,
    "department_id": 0,
    "casecategory_id": 0,
    "iso_subcasecategory_id": 0,
    "case_issue_date": "dd/MM/yyyy",
    "case_issue_time": "hh:mm",
    "is_case_notification": false,
    "case_victim_date": "dd/MM/yyyy",
    "case_victim_time": "hh:mm",
    "case_officer_date": "dd/MM/yyyy",
    "case_officer_time": "hh:mm",
    "issue_media": 0,
    "issue_media_detail": "xxx",
    "police_station_id": 0,
    "iso_other_department": "xxx",
    "investigator_title_id": 0,
    "investigator_name": "xxx",
    "iso_case_no": "xxx",
    "iso_investigator_tel": "xxxxxxxxxx",
    "scence_description": "xxx",
    "scence_province_id": 0,
    "scence_amphur_id": 0,
    "scence_tambol_id": 0,
    "iso_latitude": "xxxxx",
    "iso_longtitude": "xxx",
    "police_daily": "xxxx",
    "police_daily_date": "dd/MM/yyyy",
    "is_scene_protection": true,
    "scene_protection_details": "",
    "light_condition": "",
    "light_condition_details": "",
    "temperature_condition": "",
    "temperature_condition_details": "",
    "is_smell": true,
    "smell_details": "",
    "is_internal_building": false,
    "scene_type": "",
    "scene_details": "",
    "scene_front": "",
    "scene_left": "",
    "scene_right": "",
    "scene_back": "",
    "scene_location": "",
    "building_type_id": "",
    "iso_building_detail": "",
    "floor": "",
    "is_frence": true,
    "case_internal": [
      {
        "id": 0,
        "floor_no": "",
        "floor_detail": "",
        "active_flag": true,
      },
    ],
    "case_scene_location ": [
      {
        "id": 0,
        "scene_location": "",
        "scene_location_size": "",
        "unit_id": 0,
        "building_structure": "",
        "building_wall_front": "",
        "building_wall_left": "",
        "building_wall_right": "",
        "building_wall_back ": "",
        "room_floor": "",
        "roof ": "",
        "placement ": "",
        "active_flag": true,
      },
    ],
    "case_behavior": "",
    "case_entrance_details": "",
    "is_fighting_clue": "",
    "fighting_clue_details": "",
    "is_ranksack_clue": "",
    "ranksack_clue_details": "",
    "iso_is_final": "",
    "iso_complete": "",
    "iso_is_deliver": "",
    "close_date": "dd/MM/yyyy",
    "close_time": "hh:mm"
  },
  "case_related_person": [
    {
      "id": 0,
      "name": "xxx",
      "iso_firstname": "xxx",
      "iso_lastname": "xxx",
      "age": 0,
      "iso_idcard": "xxx",
      "iso_concern_people_career_id": 0,
      "iso_concern_people_career_other": "xxx",
      "iso_concern_people_details": "xxx",
      "active_flag": true
    }
  ],
  "case_inspection": [
    {"id": 0, "inspect_date": "dd/MM/yyyy", "inspect_time": "hh:mm"}
  ],
  "case_inspector": [
    {
      "id": 0,
      "personal_id": 0,
      "position_id": 0,
      "inspector_position": "xxx",
      "active_flag": true
    }
  ]
};
