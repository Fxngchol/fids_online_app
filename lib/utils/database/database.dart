// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'fids.db'),
        onCreate: (db, version) async {
      // await db.execute("CREATE TABLE CaseRelatedPerson ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT, Iso_FirstName TEXT, Iso_lastName TEXT,"
      //     "Age INTEGER, Iso_Idcard TEXT, Iso_ConcernpeoplecareerID INTEGER,"
      //     "Iso_ConcernpeoplecareerOther TEXT, Iso_Concernpeopledetails TEXT,"
      //     "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER"

      //     "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (RelatedPersonTypeID) REFERENCES RelatedPersonType (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (Iso_RelatedPersonTitleID) REFERENCES Title (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE CaseInspection ("
      //     "ID INTEGER PRIMARY KEY,"
      //     "InspectDate DATETIME, InspectTime TIME"
      //     "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE CaseInspector ("
      //     "ID INTEGER PRIMARY KEY,InspectorPosition TEXT,"
      //     "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER"
      //     "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (PersonalID) REFERENCES Personal (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (PositionID) REFERENCES Position (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      await db.execute("CREATE TABLE CaseInternal ("
          "ID INTEGER PRIMARY KEY, FloorNo TEXT, FloorDetail TEXT,FidsID INTEGER,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseSceneLocation ("
          "ID INTEGER PRIMARY KEY, SceneLocation TEXT, SceneLocationSize TEXT,"
          "UnitId INTEGER, BuildingStructure TEXT, BuildingWallFront TEXT,"
          "BuildingWallLeft TEXT, BuildingWallRight TEXT, BuildingWallBack TEXT,"
          "FrontLeftToRight TEXT, LeftFrontToBack TEXT, RightFrontToBack TEXT,"
          "BackLeftToRight TEXT,"
          "RoomFloor TEXT, Roof TEXT, Placement TEXT, Ceiling TEXT, AreaOther TEXT, FidsID INTEGER,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseReferencePoint ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, ReferencePointNo TEXT, ReferencePointDetail TEXT,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseBody ("
          "ID INTEGER PRIMARY KEY, LabelNo TEXT, BodyFirstName TEXT, BodyLastName TEXT,"
          "BodyFoundLocation TEXT, BodyFoundCondition TEXT, IsClothing INTEGER,"
          "ClothingDetail TEXT, IsPants INTEGER, PantsDetail TEXT, PersonalID TEXT,"
          "IsShoes INTEGER, ShoesDetail TEXT, IsBelt INTEGER, BeltDetail TEXT,"
          "IsTattoo INTEGER, TattooDetail TEXT, DressOther TEXT, InvestigatorDoctor TEXT, IsWound INTEGER,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FidsID INTEGER, BodyTitleName TEXT, BodyDiagram TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsWounddsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseBodyReferencePoint ("
          "ID INTEGER PRIMARY KEY, ReferenceDetail TEXT, ReferenceDistance1 DOUBLE, ReferenceUnitID1 INTEGER,"
          "ReferenceDistance2 DOUBLE, ReferenceUnitID2 INTEGER, BodyPositionID TEXT,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FidsID INTEGER, BodyID INTEGER,ReferenceID1 INTEGER, ReferenceID2 INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (BodyID) REFERENCES CaseBody (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (ReferenceID1) REFERENCES CaseReferencePoint (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (ReferenceID2) REFERENCES CaseReferencePoint (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseBodyWound ("
          "ID INTEGER PRIMARY KEY, WoundDetail TEXT, WoundPosition TEXT,"
          "WoundSize TEXT, WoundUnitID TEXT, WoundAmount TEXT, FidsID INTEGER, BodyID INTEGER,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (BodyID) REFERENCES CaseBody (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseEvidentFound ("
          "ID INTEGER PRIMARY KEY, Iso_LabelNo TEXT, IsBlood INTEGER, EvidentDetails TEXT, Iso_EvidentPosition TEXT,"
          "EvidentAmount TEXT, Iso_ReferenceDistance1 DOUBLE, Iso_ReferenceUnitID1 INTEGER,"
          "Iso_ReferenceDistance2 DOUBLE, Iso_ReferenceUnitID2 INTEGER, Iso_IsTestStains INTEGER,"
          "Iso_IsHermastix INTEGER, Iso_IsHermastixChange INTEGER, Iso_IsPhenolphthaiein INTEGER, Iso_IsPhenolphthaieinChange INTEGER,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FidsID INTEGER, EvidentTypeID INTEGER,EvidenceUnit TEXT, Iso_ReferenceID1 INTEGER,Iso_ReferenceID2 INTEGER,Size TEXT,SizeUnit TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (EvidentTypeID) REFERENCES EvidentType (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (Iso_ReferenceID1) REFERENCES CaseReferencePoint (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (Iso_ReferenceID2) REFERENCES CaseReferencePoint (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseEvident ("
          "ID INTEGER PRIMARY KEY, EvidentNo TEXT, EvidentDetails TEXT, Iso_EvidentPosition TEXT,"
          "EvidentAmount TEXT, IsEvidentOperate INTEGER,PersonalID TEXT,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,EvidenceGroupID TEXT, EvidenceCheckID TEXT,"
          "FidsID INTEGER, EvidentTypeID INTEGER,EvidentUnit TEXT, PackageID INTEGER,PackageOther TEXT,DepartmentID INTEGER,WorkGroupID INTEGER,deliverWorkGroupID INTEGER,"
          "EvidenceDetail TEXT,VehiclePosition TEXT,EvidenceUnit TEXT,IsEvidenceOperate TEXT,EvidenceAmount TEXT,CaseVehicelID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (EvidentTypeID) REFERENCES EvidentType (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (PackageID) REFERENCES Package (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (DepartmentID) REFERENCES Department (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (WorkGroupID) REFERENCES WorkGroup (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseEvidentLocation ("
          "ID INTEGER PRIMARY KEY, EvidentLocationDetail TEXT, Area TEXT, LabelNo TEXT,"
          "FidsID INTEGER, EvidentID INTEGER, EvidentFoundID TEXT,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (EvidentID) REFERENCES CaseEvident (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (EvidentFoundID) REFERENCES CaseEvidentFound (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseImages ("
          "ID INTEGER PRIMARY KEY, FidsID INTEGER ,ImageDetail TEXT, ImageFile TEXT,"
          "CreateDate DATETIME, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseEvidentDeliver("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, EvidentID INTEGER,WorkGroupID INTEGER,EvidenceCheckID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (EvidentID) REFERENCES CaseEvident (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (WorkGroupID) REFERENCES WorkGroup (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseVehicle ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, VehicleTypeID TEXT,"
          "VehicleTypeOther TEXT, VehicleBrandID TEXT,VehicleBrandOther TEXT,"
          "VehicleModel TEXT, ColorID1 TEXT, ColorID2 TEXT,"
          "ColorOther TEXT, Detail TEXT, IsVehicleRegistrationPlate TEXT,"
          "VehicleRegistrationPlateNo1 TEXT, ProvinceID TEXT, VehicleRegistrationPlateNo2 TEXT,"
          "VehicleOther TEXT,VehicleMap TEXT,ChassisNumber TEXT,EngineNumber TEXT,ProvinceOtherID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseVehicleDamaged ("
          "ID INTEGER PRIMARY KEY, VehicleSideID TEXT, IsDamaged TEXT, DamagedDetail TEXT,"
          "Height TEXT, DamagedOther TEXT,"
          "FidsID INTEGER,CaseVehicelID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (CaseVehicelID) REFERENCES CaseVehicle (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseVehicleCompare ("
          "ID INTEGER PRIMARY KEY, CaseVehicleID1 TEXT, CaseVehicleID2 TEXT,FidsID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseVehicleCompareDetail ("
          "ID INTEGER PRIMARY KEY, CaseVehicleID TEXT, VehicleSideID TEXT,"
          "CaseVehicleDamagedID TEXT, LabelNo TEXT,FidsID INTEGER,CaseVehicleCompareID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (CaseVehicleCompareID) REFERENCES CaseVehicleCompare (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseVehicleOpinion ("
          "ID INTEGER PRIMARY KEY, Opinion TEXT,FidsID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseFireArea ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER,"
          "AreaDetail TEXT,"
          "Front1 TEXT, Left1 TEXT,Right1 TEXT,Back1 TEXT,"
          "Floor1 TEXT, Roof1 TEXT,Other1 TEXT,Front2 TEXT,"
          "Left2 TEXT, Right2 TEXT,Back2 TEXT,Center2 TEXT,"
          "Roof2 TEXT, Other2 TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseFireSideArea ("
          "ID INTEGER PRIMARY KEY, SideAreaDetail TEXT,CaseFireAreaID TEXT, FidsID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      // // =============== > Lookup < ===============

      // await db.execute("CREATE TABLE CaseCategory ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE SubCaseCategory ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT, CaseCategoryID INTEGER,"
      //     "FOREIGN KEY (CaseCategoryID) REFERENCES CaseCategory (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE Province ("
      //     "ID INTEGER PRIMARY KEY, Province TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Amphur ("
      //     "ID INTEGER PRIMARY KEY, Amphur TEXT, ProvinceID INTEGER,"
      //     "FOREIGN KEY (ProvinceID) REFERENCES CaseCategory (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE Tambol ("
      //     "ID INTEGER PRIMARY KEY, Tambol TEXT, ProvinceID INTEGER, AmphurID INTEGER,"
      //     "FOREIGN KEY (ProvinceID) REFERENCES Province (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (AmphurID) REFERENCES Amphur (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE PoliceStation ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT, ProvinceID INTEGER, AmphurID INTEGER, TambolID INTEGER,"
      //     "FOREIGN KEY (ProvinceID) REFERENCES Province (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (AmphurID) REFERENCES Amphur (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (TambolID) REFERENCES Tambol (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE Title ("
      //     "ID INTEGER PRIMARY KEY, ShortName TEXT, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Department ("
      //     "ID INTEGER PRIMARY KEY, ShortName TEXT, Name TEXT,"
      //     "DepartmentCode TEXT, RootID INTEGER, SeqNo INTEGER, DepartTypeID INTEGER,ProvinceID INTEGER,"
      //     "FOREIGN KEY (ProvinceID) REFERENCES Province (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE RelatedPersonType ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Career ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Personal ("
      //     "ID INTEGER PRIMARY KEY,Name TEXT, FirstName TEXT, LastName TEXT, IDCard TEXT,"
      //     "TitleID INTEGER, PositionID INTEGER, HeadID INTEGER, DepartmentID INTEGER,"
      //     "FOREIGN KEY (TitleID) REFERENCES Title (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (PositionID) REFERENCES Position (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (HeadID) REFERENCES Department (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
      //     "FOREIGN KEY (DepartmentID) REFERENCES Department (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
      //     ")");

      // await db.execute("CREATE TABLE Position ("
      //     "ID INTEGER PRIMARY KEY, ShortName TEXT, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE EvidentType ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Unit ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Building ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE WorkGroup ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // await db.execute("CREATE TABLE Package ("
      //     "ID INTEGER PRIMARY KEY, Name TEXT"
      //     ")");

      // // =============== > WEB TO MOBILE < ===============
      await db.execute("CREATE TABLE FidsCrimeScene ("
          "ID INTEGER PRIMARY KEY,IsMobileCreate INTEGER, FidsNo TEXT, CaseIssueDate DATETIME, CaseIssueTime TIME,"
          "IsCaseNotification INTEGER, CaseVictimDate TEXT, CaseVictimTime TEXT, CaseOfficerDate TEXT,"
          "CaseOfficerTime TEXT, IssueMedia INTEGER, IssueMediaDetail TEXT, Iso_OtherDepartment TEXT,"
          "InvestigatorName TEXT, Iso_CaseNo TEXT, Iso_InvestigatorTel TEXT, SceneDescription TEXT,"
          "DeliverBookNo TEXT, DeliverBookDate DATETIME,IsSceneProtection INTEGER,SceneProtectionDetails TEXT,"
          "LightCondition TEXT, LightConditionDetails TEXT,TemperatureCondition TEXT,TemperatureConditionDetails TEXT,"
          "IsSmell INTEGER, SmellDetails TEXT, isOutside INTEGER, SubCaseCategoryOther TEXT, ReportNo TEXT,"
          "SceneProvinceID INTEGER, SceneAmphurID INTEGER, PoliceDailyDate DATETIME,"
          "Iso_Longtitude TEXT, PoliceDaily TEXT, SceneTambolID INTEGER, Iso_Latitude TEXT,"
          "DepartmentID INTEGER, CaseCategoryID INTEGER, ISO_SubCaseCategoryID INTEGER, PoliceStationID INTEGER, InvestigatorTitleID INTEGER,"
          "CaseBehavior TEXT,Iso_Damage TEXT,Iso_BombLocation TEXT, CaseEntranceDetails TEXT, IsFightingClue INTEGER, FightingClueDetails TEXT, IsRansackClue INTEGER, RansackClueDetails TEXT,"
          "SceneType TEXT, SceneDetails TEXT, SceneFront TEXT, SceneLeft TEXT, SceneRight TEXT, SceneBack TEXT, SceneLocation TEXT,"
          "BuildingTypeid INTEGER, Iso_BuildingDetail TEXT, Floor TEXT, IsFence INTEGER,"
          "Iso_IsFinal INTEGER, Iso_IsComplete INTEGER, Iso_IsDeliver INTEGER, CloseDate TEXT, CloseTime TEXT,"
          "ReceiveSignature TEXT, ReceiveTitleID TEXT, ReceiveName TEXT, ReceivePosition TEXT,"
          "SendSignature TEXT,SendPersonID TEXT,SendPosition TEXT,Iso_IsClue TEXT, Iso_IsLock TEXT,Iso_IsCasualty Text,Iso_IsDeceased TEXT,IsoCasualtyDetail TEXT,"
          "CriminalAmount TEXT,Iso_IsWeapon TEXT,Iso_IsWeaponType1 TEXT,Iso_IsWeaponType2 TEXT,Iso_IsWeaponType3 TEXT, Iso_IsWeaponType4 TEXT,"
          "Iso_WeaponType4Detail TEXT,Iso_IsImprisonInRoom TEXT,Iso_IsImprison TEXT,Iso_Imprison TEXT, IsoImprisonDetail TEXT,BuildingTypeOther TEXT,Iso_BombSize TEXT,"
          "IsBodyFound TEXT,Objective TEXT,ExhibitLocation TEXT,ExhibitDate TEXT,ExhibitTime TEXT,"
          "TrafficObjective INTEGER,TrafficObjectiveOther TEXT,FireTypeID TEXT,FireAreaDetail TEXT,FireMainSwitch TEXT,"
          "FireSourceArea TEXT,FireFuel TEXT,FireHeatSource TEXT,FireOpinion TEXT,FireDamagedDetail TEXT,"
          "FOREIGN KEY (DepartmentID) REFERENCES Department (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (CaseCategoryID) REFERENCES CaseCategory (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (ISO_SubCaseCategoryID) REFERENCES SubCaseCategory (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (PoliceStationID) REFERENCES PoliceStation (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (InvestigatorTitleID) REFERENCES Title (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseRelatedPerson ("
          "ID INTEGER PRIMARY KEY, Name TEXT, Iso_FirstName TEXT,RelatedPersonOther TEXT, Iso_lastName TEXT, RelatedPersonImage TEXT,"
          "Age TEXT, Iso_Idcard TEXT, Iso_ConcernpeoplecareerID INTEGER, Iso_ConcernpeoplecareerOther TEXT, TypeCardID TEXT,"
          "Iso_Concernpeopledetails TEXT, CreateDate DATETIME, CreateBy INTEGER, UpdateDate DATETIME,Iso_Iso_TitleName TEXT,"
          "UpdateBy INTEGER, ActiveFlag INTEGER,FidsID INTEGER,RelatedPersonTypeID INTEGER,Iso_RelatedPersonTitleID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (RelatedPersonTypeID) REFERENCES RelatedPersonType (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (Iso_RelatedPersonTitleID) REFERENCES Title (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseInspection ("
          "ID INTEGER PRIMARY KEY, InspectDate DATETIME, InspectTime TIME,"
          "ActiveFlag INTEGER,FidsID INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseInspector ("
          "ID INTEGER PRIMARY KEY, FidsID INTEGER, TitleID TEXT, FirstName TEXT, LastName TEXT,"
          "PositionID TEXT, PositionOther TEXT, DepartmentID TEXT, SubDepartmentID TEXT,"
          "CreateDate DATETIME,OrderID TEXT, CreateBy INTEGER,UpdateDate DATETIME, UpdateBy INTEGER,ActiveFlag INTEGER,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (TitleID) REFERENCES Title (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          "FOREIGN KEY (PositionID) REFERENCES Position (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE DiagramLocation ("
          "ID INTEGER PRIMARY KEY, DiagramID INTEGER, FidsID INTEGER, Diagram TEXT, DiagramRemark TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseClue ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER,Iso_IsClue TEXT,LabelNo TEXT,"
          "ClueTypeID TEXT, ClueTypeDetail TEXT,"
          "IsDoor TEXT, DoorDetail TEXT, VillainEntrance TEXT, IsWindows TEXT, WindowsDetail TEXT,"
          "IsCelling TEXT, CellingDetail TEXT, IsRoof TEXT, RoofDetail TEXT,"
          "IsClueOther TEXT, ClueOtherDetail TEXT, IsTools1 TEXT, Tools1Detail TEXT, "
          "IsTools2 TEXT, Tools2Detail TEXT, IsTools3 TEXT, Tools3Detail TEXT, IsTools4 TEXT, Tools4Detail TEXT,"
          "Width TEXT, WidthUnitID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseBomb ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, IsBombPackage1 TEXT, IsBombPackage2 TEXT,"
          "IsBombPackage3 TEXT,IsBombPackage4 TEXT,IsBombPackage5 TEXT,IsBombPackage6 TEXT,"
          "IsBombPackage7 TEXT,IsBombPackage8 TEXT,BombPackage8Detail TEXT,IsIgnitionType1 TEXT,"
          "IgnitionType1Detail TEXT,IsIgnitionType2 TEXT,IgnitionType1Color TEXT,IgnitionType1Length TEXT,"
          "IsIgnitionType3 TEXT,IgnitionType3Brand TEXT,IgnitionType3Model TEXT,IgnitionType3Colour TEXT,"
          "IgnitionType3SN TEXT,IsIgnitionType4 TEXT,IgnitionType4Brand TEXT,IgnitionType4Model TEXT,"
          "IgnitionType4Colour TEXT,IgnitionType4SN TEXT,IsIgnitionType5 TEXT,IgnitionType5Detail TEXT,"
          "IsIgnitionType6 TEXT,IgnitionType6Detail TEXT,IsIgnitionType7 TEXT,IgnitionType7Detail TEXT,"
          "IsFlakType1 TEXT,FlakType1Size TEXT,FlakType1Length TEXT,IsFlakType2 TEXT,"
          "FlakType2Size TEXT,IsFlakType3 TEXT,FlakType3Detail TEXT,IsMaterial1 TEXT,"
          "Material1 TEXT,IsMaterial2 TEXT,Material2 TEXT,IsMaterial3 TEXT,Material3 TEXT,"
          "IsMaterial4 TEXT,Material4 TEXT,IsMaterial5 TEXT,Material5 TEXT,IsMaterial6 TEXT,Material6 TEXT,"
          "Material6V TEXT,IsMaterial7 TEXT,Material7 TEXT,IsMaterial8 TEXT,Material8 TEXT,IsMaterial9 TEXT,"
          "Material9 TEXT,IsMaterial10 TEXT,Material10 TEXT,IsMaterial11 TEXT,Material11 TEXT,IsMaterial12 TEXT,"
          "Material12 TEXT,IsMaterial13 TEXT,Material13 TEXT,IsMaterial14 TEXT,Material14 TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseAsset ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER,"
          "Asset TEXT, AssetAmount TEXT, AssetUnit TEXT,AreaID TEXT, CaseRansacked TEXT,AreaDetail TEXT, RansackedDeatil TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseAssetArea ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, Area TEXT, IsClue TEXT,IsLock TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseAreaClue ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, Area TEXT, IsClue TEXT,"
          "IsLock TEXT,ClueTypeID TEXT,VillainEntrance TEXT,ClueTypeDetail TEXT,IsDoor TEXT,DoorDetail TEXT,IsWindows TEXT,WindowsDetail TEXT,"
          "IsCelling TEXT,CellingDetail TEXT,IsRoof TEXT,RoofDetail TEXT,IsClueOther TEXT,ClueOtherDetail TEXT,IsTools1 TEXT,"
          "Tools1Detail TEXT,IsTools2 TEXT,Tools2Detail TEXT,IsTools3 TEXT,Tools3Detail TEXT,IsTools4 TEXT,Tools4Detail TEXT,"
          "Width TEXT,WidthUnitID TEXT,CaseAssetAreaID INTEGER,LabelNo TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseRansacked ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER,IsClue TEXT,AreaDetail TEXT,Detail TEXT,LabelNo TEXT,RansackedTypeID TEXT,CaseAssetAreaID TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      await db.execute("CREATE TABLE CaseExhibit ("
          "ID INTEGER PRIMARY KEY,FidsID INTEGER, ExhibitName TEXT, ExhibitDetail TEXT,ExhibitAmount TEXT,ExhibitUnit TEXT,"
          "FOREIGN KEY (FidsID) REFERENCES FidsCrimeScene (ID) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");

      //           "vehicle_type_id": 0,
      // "vehicle_type_other": "",
      // "vehicle_brand_id": 0,
      // "vehicle_brand_other": "",
      // "vehicle_model": "",
      // "vehicle_color_id1": 0,
      // "vehicle_color_id2": 0,
      // "vehicle_color_other": "",
      // "vehicle_detail": "",
      // "is_vehicle_registration_plate": "",
      // "is_vehicle_registration_plate_no1": "",
      // "province_id": 0,
      // "is_vehicle_registration_plate_no2": "",
      // "vehicle_other": "",
      // "vehicle_map": "",
    }, version: 1);
  }
}
