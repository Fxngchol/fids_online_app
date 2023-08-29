import 'index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('th', 'TH'), // Thai
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        unselectedWidgetColor: Colors.white, // <-- your color
      ),
      home: const Login(),
      routes: <String, WidgetBuilder>{
        '/uploadcase': (BuildContext context) => const UploadCase(),
        '/login': (BuildContext context) => const Login(),
        '/home': (BuildContext context) => const Home(),
        '/lifecase': (BuildContext context) => const LifeCase(),
        '/locationcase': (BuildContext context) => const LocationCase(),
        '/editlocationcase': (BuildContext context) => const EditLocationCase(),
        '/inspectorcase': (BuildContext context) => const InspectorCase(),
        '/addinspectorcase': (BuildContext context) => const AddInspectorCase(),
        '/datetimeinspectcase': (BuildContext context) =>
            const DateTimeInspectCase(),
        '/adddatetimeinspectcase': (BuildContext context) =>
            const AddDateTimeInspectCase(),
        '/requestcase': (BuildContext context) => const RequestCasePage(),
        '/requestcasedetail': (BuildContext context) =>
            const RequestCaseDetail(),
        '/casedatetime': (BuildContext context) => const CaseDatetime(),
        '/addcasedatetime': (BuildContext context) => const AddCaseDateTime(),
        '/resultcase': (BuildContext context) => const ResultCase(),
        '/addresultcase': (BuildContext context) => const AddResultCase(),
        '/deceased': (BuildContext context) => const DeceasedDetail(),
        '/adddeceased': (BuildContext context) => const AddDeceased(),
        '/addbodyreferenceposition': (BuildContext context) =>
            AddBodyReferencePosition(),
        '/referencepoint': (BuildContext context) => const ReferencePoint(),
        '/addreferencepoint': (BuildContext context) =>
            const AddReferencePoint(),
        '/drawreferencepostion': (BuildContext context) =>
            const DrawReferencePosition(),
        '/dress': (BuildContext context) => const Dress(),
        '/addlesion': (BuildContext context) => const AddLesion(
              indexEdit: -1,
            ),
        '/editdetail': (BuildContext context) => const EditDecease(),
        '/addrelateperson': (BuildContext context) => const AddRelatePerson(),
        '/relateperson': (BuildContext context) => const RelatePerson(),
        '/selectlocation': (BuildContext context) => const SelectLocation(),
        '/outsidebuilding': (BuildContext context) => const OutsideBuilding(),
        '/scenelocationcondition': (BuildContext context) =>
            const SceneLocation(),
        '/scenelocationdetail': (BuildContext context) =>
            const SceneLocationDetail(),
        '/insidebuilding': (BuildContext context) => const InsideBuilding(),
        '/addinsidebuilding': (BuildContext context) =>
            const AddInsideBuilding(),
        '/addscenelocation': (BuildContext context) => const AddSceneLocation(),
        '/locationscenedetail': (BuildContext context) =>
            const LocationSceneDetail(),
        '/addoutsidebuilding': (BuildContext context) =>
            const AddOutsideBuilding(),
        '/addstructure': (BuildContext context) => const AddStructure(),
        '/editoutsidebuilding': (BuildContext context) =>
            const EditOutsideBuilding(),
        '/releasescene': (BuildContext context) => const ReleaseScene(),
        '/addreleasescene': (BuildContext context) => AddReleaseScene(),
        '/evidentfound': (BuildContext context) => const EvidentFound(),
        '/addevidentfound': (BuildContext context) => const AddEvidentFound(),
        '/evidentfounddetail': (BuildContext context) =>
            const EvidentFoundDetail(),
        '/evidentkept': (BuildContext context) => const EvidentKept(),
        '/addevidentkept': (BuildContext context) => const AddEvidentKept(),
        '/drawtemplate': (BuildContext context) => const DrawTemplate(),
        '/plancase': (BuildContext context) => const PlanCase(),
        '/showplancase': (BuildContext context) => const ShowPlancase(),
        '/witness': (BuildContext context) => const Witness(),
        '/addwitness': (BuildContext context) => const AddWitnessCase(),
        '/showwitness': (BuildContext context) => const ShowWitnessCase(),
        // '/imagecase': (BuildContext context) => Imagecase(),
        '/detailimagecase': (BuildContext context) => const DetailImageCase(),
        '/addimagecase': (BuildContext context) => const AddImageCase(),
      },
    );
  }
}
