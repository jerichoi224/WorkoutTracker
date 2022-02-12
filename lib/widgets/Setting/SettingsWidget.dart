import 'package:flutter/material.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/HomeWidget.dart';
import 'package:workout_tracker/widgets/Setting/AboutSettingWidget.dart';
import 'package:workout_tracker/widgets/Setting/ProfileSettingWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsWidget extends StatefulWidget {
  late ObjectBox objectbox;
  SettingsWidget({Key? key, required this.objectbox,}) : super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
   bool bToggle = false;
   Map<String, String> languages = {'English': 'en', '한국어': 'kr'};
   String locale = "";
   String distMetric = "";
   String weightMetric = "";

  @override
  void initState() {
    super.initState();
    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
    temp = widget.objectbox.getPref("preferred_distance");
    distMetric = temp != null ? temp : 'km';
    temp = widget.objectbox.getPref("preferred_weight");
    weightMetric = temp != null ? temp : 'kg';
  }

   void openProfilePage(BuildContext context) async {
     final result = await Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => ProfileSettingsWidget(objectbox: widget.objectbox,),
         ));

     if(result.runtimeType == bool && result)
     {
       setState(() {});
     }
   }

   void openOtherPage(BuildContext context) async {
     final result = await Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => AboutSettingsWidget(),
         ));

     if(result.runtimeType == bool && result)
     {
       setState(() {});
     }
   }

   void setLanguage(String language)
   {
     Locale newLocale = Locale(language, '');
     widget.objectbox.setPref("locale", language);
     MyApp.setLocale(context, newLocale);
     setState(() {});
   }

 @override
 Widget build(BuildContext context) {
   return GestureDetector(
       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
       child: Scaffold(
         body: CustomScrollView(
           slivers: <Widget>[
             SliverAppBar(
               pinned: true,
               snap: false,
               floating: false,
               backgroundColor: Colors.amberAccent,
               expandedHeight: 100.0,
               flexibleSpace: FlexibleSpaceBar(
                 title: Text(AppLocalizations.of(context)!.settings),
               ),
             ),
             SliverList(
               delegate: SliverChildListDelegate(
               [
                 Container(
                   padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                     child: Text(AppLocalizations.of(context)!.settings_user_settings,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.grey
                       ),
                     )
                 ),
                 Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                     margin: EdgeInsets.all(8.0),
                     child: Column(
                       children: <Widget>[
                         InkWell(
                           borderRadius: BorderRadius.circular(8.0),
                           onTap: (){
                             openProfilePage(context);
                             },
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text(AppLocalizations.of(context)!.settings_profile),
                                 ],
                               )
                           ),
                         ),
                       ],
                     )
                 ),
                 Container(
                     padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                     child: Text(AppLocalizations.of(context)!.settings_system_settings,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.grey
                       ),
                     )
                 ),
                 Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                     margin: EdgeInsets.all(8.0),
                     child: Column(
                       children: <Widget>[
                         InkWell(
                           borderRadius: BorderRadius.circular(8.0),
                           onTap: (){},
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text(AppLocalizations.of(context)!.settings_change_language),
                                   Spacer(),
                                   DropdownButton<String>(
                                     value: languages.keys.firstWhere((element) => languages[element] == locale),
                                     iconSize: 24,
                                     elevation: 16,
                                     onChanged: (value){
                                       setState(() {
                                         locale = languages[value]!;
                                         setLanguage(locale);
                                       });
                                     },
                                     underline: Container(
                                       height: 2,
                                     ),
                                     selectedItemBuilder: (BuildContext context) {
                                       return languages.keys.map<Widget>((String value) {
                                         return Container(
                                             alignment: Alignment.centerRight,
                                             width: 100,
                                             child: Text(value, textAlign: TextAlign.end)
                                         );
                                       }).toList();
                                     },
                                     items: languages.keys.map<DropdownMenuItem<String>>((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Text(value),
                                       );
                                     }).toList(),
                                   )
                                 ],
                               )
                           ),
                         ),
                         InkWell(
                           borderRadius: BorderRadius.circular(8.0),
                           onTap: (){},
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text(AppLocalizations.of(context)!.settings_preferred_distance_metric),
                                   Spacer(),
                                   DropdownButton<String>(
                                     value: distMetric,
                                     iconSize: 24,
                                     elevation: 16,
                                     onChanged: (value){
                                       setState(() {
                                         distMetric = value!;
                                         widget.objectbox.setPref("preferred_distance", value);
                                       });
                                     },
                                     underline: Container(
                                       height: 2,
                                     ),
                                     selectedItemBuilder: (BuildContext context) {
                                       return [MetricType.km.name, MetricType.miles.name].map<Widget>((String value) {
                                         return Container(
                                             alignment: Alignment.centerRight,
                                             width: 100,
                                             child: Text(value, textAlign: TextAlign.end)
                                         );
                                       }).toList();
                                     },
                                     items: [MetricType.km.name, MetricType.miles.name].map<DropdownMenuItem<String>>((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Text(value),
                                       );
                                     }).toList(),
                                   )
                                 ],
                               )
                           ),
                         ),
                         InkWell(
                           borderRadius: BorderRadius.circular(8.0),
                           onTap: (){},
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text(AppLocalizations.of(context)!.settings_preferred_weight_metric),
                                   Spacer(),
                                   DropdownButton<String>(
                                     value: weightMetric,
                                     iconSize: 24,
                                     elevation: 16,
                                     onChanged: (value){
                                       setState(() {
                                         weightMetric = value!;
                                         widget.objectbox.setPref("preferred_weight", value);
                                       });
                                     },
                                     underline: Container(
                                       height: 2,
                                     ),
                                     selectedItemBuilder: (BuildContext context) {
                                       return [MetricType.kg.name, MetricType.lb.name].map<Widget>((String value) {
                                         return Container(
                                             alignment: Alignment.centerRight,
                                             width: 100,
                                             child: Text(value, textAlign: TextAlign.end)
                                         );
                                       }).toList();
                                     },
                                     items: [MetricType.kg.name, MetricType.lb.name].map<DropdownMenuItem<String>>((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Text(value),
                                       );
                                     }).toList(),
                                   )
                                 ],
                               )
                           ),
                         ),
                       ],
                     )
                 ),
                 Container(
                     padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                     child: Text(AppLocalizations.of(context)!.settings_other,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.grey
                       ),
                     )
                 ),
                 Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                     margin: EdgeInsets.all(8.0),
                     child: Column(
                       children: <Widget>[
                         InkWell(
                           borderRadius: BorderRadius.circular(8.0),
                           onTap: (){
                             openOtherPage(context);
                           },
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text(AppLocalizations.of(context)!.settings_about),
                                 ],
                               )
                           ),
                         ),
                       ],
                     )
                 ),
               ]),
             ),
           ],
         ),
       )
   );
 }
}
