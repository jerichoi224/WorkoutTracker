import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/util/initialWorkouts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InstructionWidget extends StatefulWidget {
  final BuildContext parentCtx;
  late final objectbox;
  InstructionWidget({Key? key, required this.parentCtx, required this.objectbox});

  @override
  State createState() => _InstructionState();
}

class _InstructionState extends State<InstructionWidget>{
  final pageController = PageController(initialPage: 0);
  TextEditingController userName = new TextEditingController();
  Map<String, String> languages = {'English': 'en', '한국어': 'kr'};

  int _currentIndex = 0;
  String locale = "";

  @override
  void initState(){
    super.initState();
    String? temp = objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
  }

  void setLanguage(String language)
  {
    Locale newLocale = Locale(language, '');
    widget.objectbox.setPref("locale", language);
    MyApp.setLocale(context, newLocale);
    setState(() {});
  }

  finishSplash() async {
      nextPage();
      objectbox.setPref('show_instruction', false);
      objectbox.setPref('user_name', userName.text);
      addInitialWorkouts();
      await Future.delayed(const Duration(seconds: 2), (){});
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }


  nextPage() {
    setState(() {
      _currentIndex += 1;
      pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  showSnackBar(BuildContext context, String s){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: Duration(seconds: 3),
    ));
  }


  Widget languageScreen(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/languages.png'),
                      width: 150,
                    )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.instruction_select_language,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Center(
                  child:DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      items: languages.keys.toList()
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                          .toList(),
                      value: languages.keys.firstWhere((element) => languages[element] == locale),
                      onChanged: (value) {
                        setState(() {
                          String? newLocale = languages[value];
                          locale = newLocale!;
                          setLanguage(locale);
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.grey,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 200,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                      buttonElevation: 1,
                      itemHeight: 50,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, 0),
                    ),
                  ),
                ),
                Container(
                    width: 200,
                    child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 10),
                    color: Colors.amber,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                nextPage();
                              },
                              title: Text(AppLocalizations.of(context)!.next,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ]
                    )
                  )
                )
              ],
            )
        )
    );
  }


  Widget introScreen(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          },
        child: new Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Image(
                      image: AssetImage('assets/my_icon.png'),
                      width: 150,
                    )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.instruction_ask_name_msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Center(
                      child: ListTile(
                          title: new Row(
                            children: <Widget>[
                              Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!.enter_name,
                                    ),
                                    controller: userName,
                                    textAlign: TextAlign.center,
                                  )
                              )
                            ],
                          )
                      ),
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.amber,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                if(userName.text.isEmpty) {
                                  final snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!.instruction_name_msg),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }
                                finishSplash();
                              },
                              title: Text(AppLocalizations.of(context)!.start,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ]
                    )
                )
              ],
            )
        )
    );
  }


  Widget loadingScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(AppLocalizations.of(context)!.instruction_creating_db,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16
                  )
              )
          ),
        ),
        SpinKitPouringHourGlassRefined(color: Colors.amberAccent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = <Widget>[
      languageScreen(context),
      introScreen(context),
      loadingScreen(context)
    ];
    return Scaffold(
      body:
      Builder(
          builder: (context) => PageView(
              physics:new NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                _currentIndex = index;
              },
              controller: pageController,
              children: introPages
          )
      ),
    );
  }

  void addInitialWorkouts() async{
    for(WorkoutEntry entry in initList)
      {
        widget.objectbox.workoutBox.put(entry);
      }

    widget.objectbox.workoutList = widget.objectbox.workoutBox.getAll();
    setState(() {
    });
  }
}