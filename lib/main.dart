import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workout_tracker/class/CupertinoLocalizationKrDelegate.dart';
import 'package:workout_tracker/class/MaterialLocalizationKrDelegate.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/HomeWidget.dart';
import 'package:workout_tracker/widgets/InstructionWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  runApp(MaterialApp(home:MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if(state != null)
      state.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale.fromSubtags(languageCode: "en");

  @override
  void initState(){
    super.initState();
    String? locale = objectbox.getPref('locale');
    _locale = locale != null ? Locale.fromSubtags(languageCode: locale) : Locale.fromSubtags(languageCode: "en");
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workout Tracker',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
        ),
        localizationsDelegates: [AppLocalizations.delegate, MaterialLocalizationKrDelegate(), CupertinoLocalizationKrDelegate()],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        home: MainApp(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomeWidget(parentCtx: context, objectbox: objectbox),
          '/splash': (BuildContext context) => new InstructionWidget(parentCtx: context, objectbox: objectbox),
        }
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State createState() => _MainState();

  static _MainState of(BuildContext context) => context.findAncestorStateOfType<_MainState>()!;
}

class _MainState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  Future checkFirstSeen() async {
    bool firstTime = (objectbox.getPref('show_instruction')) ?? true;

    if (!firstTime) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/splash', (Route<dynamic> route) => false);
    }
  }

  Widget build(BuildContext context){
    new Timer(new Duration(milliseconds: 10), () {
      checkFirstSeen();
    });
    return Scaffold(
      body: Center(
        child: Container(
            child:Text(AppLocalizations.of(context)!.helloWorld)
        )
      )
    );
  }
}

class FallbackLocalizationDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<MaterialLocalizations> load(Locale locale) async => DefaultMaterialLocalizations();
  @override
  bool shouldReload(_) => false;
}