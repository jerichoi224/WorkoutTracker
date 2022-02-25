import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Setting/AboutSettingWidget.dart';
import 'package:workout_tracker/widgets/Setting/ProfileSettingWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
   bool ignoreInput = false;

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

   void openAboutPage(BuildContext context) async {
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

   void backupFile(BuildContext context) async {
     var status = await Permission.storage.status;
     if (!status.isGranted) {
       await Permission.storage.request();
     }
     status = await Permission.storage.status;
     if (!status.isGranted) {
       bool msg = await confirmPopup(context,
           AppLocalizations.of(context)!.help,
           AppLocalizations.of(context)!.settings_need_permission,
           AppLocalizations.of(context)!.ok,
           "");
       return null;
     }

     bool msg = await confirmPopup(context,
      AppLocalizations.of(context)!.help,
      AppLocalizations.of(context)!.settings_backup_instruction,
      AppLocalizations.of(context)!.ok,
        "");
      if(!msg)
        return;

      widget.objectbox.closeStore();

      // current db file
      String filePath = await widget.objectbox.objectBoxDataFilePath();
      File dbFile = File(filePath);
      Uint8List bytes = dbFile.readAsBytesSync();

      // new db file
      String filename = "workoutTracker_" + dateFormatterUnderscore.format(DateTime.now());
      int count = 0;
      String downloadPath = '/storage/emulated/0/Download/';
      if((await File(downloadPath + filename + ".mdb").exists()))
      {
          count = 1;
          while((await File(downloadPath + filename + "_" + count.toString() + ".mdb").exists()))
          {
            count += 1;
          }
      }

      if(count != 0)
        {
          filename = filename + "_" + count.toString();
        }

      File written = await File(downloadPath + filename+ ".mdb").writeAsBytes(bytes);

      msg = await confirmPopup(context,
           AppLocalizations.of(context)!.help,
           AppLocalizations.of(context)!.settings_saved_at + filename + ".mdb",
           AppLocalizations.of(context)!.ok,
           "");

      await widget.objectbox.restartDB();
   }

   Future<bool> restoreFile() async{
     bool msg = await confirmPopup(context,
         AppLocalizations.of(context)!.help,
         AppLocalizations.of(context)!.settings_restore_warning_msg,
         AppLocalizations.of(context)!.ok,
         "");

     FilePickerResult? result = await FilePicker.platform.pickFiles();

     ignoreInput = true;
     if (result != null) {
       if(result.files.single.path != null)
         {
           if(!result.files.single.path.toString().endsWith(".mdb"))
             {
               bool msg = await confirmPopup(context,
                   AppLocalizations.of(context)!.help,
                   AppLocalizations.of(context)!.settings_invalid_db_file,
                   AppLocalizations.of(context)!.ok,
                   "");
               return false;
             }
           widget.objectbox.closeStore();
           File newFile = File(result.files.single.path!);

           String filePath = await widget.objectbox.objectBoxDataFilePath();
           File originalFile = File(filePath);
           originalFile.rename(filePath + "_bak");
           try{
             newFile.copy(filePath);
           }catch(e)
           {
             if(await File(filePath).exists())
               {
                 File(filePath).delete();
                 originalFile.rename(filePath);
               }

             // Copy Failed
             bool msg = await confirmPopup(context,
                 AppLocalizations.of(context)!.help,
                 AppLocalizations.of(context)!.settings_restore_failed_msg + e.toString(),
                 AppLocalizations.of(context)!.ok,
                 "");
             await widget.objectbox.restartDB();
             return false;
           }
           await widget.objectbox.restartDB();
         }
     } else {
       return false;
     }
     return true;
   }

   String exportText()
   {
     String returnText = "";
     List<SessionEntry> allSessions = widget.objectbox.sessionBox.getAll();
     allSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
     for(SessionEntry sessionEntry in allSessions)
       {
         returnText += sessionEntry.name;
         returnText += "(" + dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(sessionEntry.startTime)) + "-" + dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(sessionEntry.endTime)) + ")\n";
         for(SessionItem item in sessionEntry.sets)
         {
           WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
           returnText += workoutEntry.caption + "(" + workoutEntry.metric + "/" + workoutEntry.type + ")\n";
           for(SetItem set in item.sets)
           {
             if(workoutEntry.metric != MetricType.duration.name)
             {
               returnText += set.metricValue.toStringRemoveTrailingZero();
               returnText += " " + workoutEntry.metric;

               // show num of reps
               if([MetricType.kg.name, MetricType.lb.name].contains(workoutEntry.metric))
                 returnText += " × " + set.countValue.toString();

               // show time
               if([MetricType.km.name, MetricType.miles.name, MetricType.floor.name].contains(workoutEntry.metric))
                 if(set.countValue != 0)
                 {
                   String time = numToTimeText(set.countValue);
                   if(time.substring(0, 1) == "0")
                     time = time.substring(2, time.length);
                   returnText += " (" + time + ")";
                 }
             }
             else
             {
               // Duration just shows Time
               String time = numToTimeText(set.countValue);
               if(time.substring(0, 1) == "0")
                 time = time.substring(2, time.length);
               returnText += time;
             }
             returnText += "\n";
           }
           returnText += "\n";
         }
       }
     return returnText;
   }

   void exportData() async{
     var status = await Permission.storage.status;
     if (!status.isGranted) {
       await Permission.storage.request();
     }
     status = await Permission.storage.status;
     if (!status.isGranted) {
       bool msg = await confirmPopup(context,
           AppLocalizations.of(context)!.help,
           AppLocalizations.of(context)!.settings_need_permission,
           AppLocalizations.of(context)!.ok,
           "");
       return null;
     }

     String filename = "WorkoutData_" + dateFormatterUnderscore.format(DateTime.now());
     int count = 0;
     String downloadPath = '/storage/emulated/0/Download/';
     if((await File(downloadPath + filename + ".txt").exists()))
     {
       count = 1;
       while((await File(downloadPath + filename + "_" + count.toString() + ".txt").exists()))
       {
         count += 1;
       }
     }

     if(count != 0)
     {
       filename = filename + "_" + count.toString();
     }

     File written = await File(downloadPath + filename+ ".txt").writeAsString(exportText());

     bool msg = await confirmPopup(context,
         AppLocalizations.of(context)!.help,
         AppLocalizations.of(context)!.settings_saved_at + filename + ".txt",
         AppLocalizations.of(context)!.ok,
         "");
   }

   @override
 Widget build(BuildContext context) {
   return IgnorePointer(
       ignoring: ignoreInput,
       child: GestureDetector(
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
                             child: Text(AppLocalizations.of(context)!.settings_backup_restore,
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
                                     backupFile(context);
                                   },
                                   child: ListTile(
                                       title: new Row(
                                         children: <Widget>[
                                           new Text(AppLocalizations.of(context)!.settings_backup_data),
                                         ],
                                       )
                                   ),
                                 ),
                                 InkWell(
                                   borderRadius: BorderRadius.circular(8.0),
                                   onTap: (){
                                     restoreFile();
                                     ignoreInput = false;
                                   },
                                   child: ListTile(
                                       title: new Row(
                                         children: <Widget>[
                                           new Text(AppLocalizations.of(context)!.settings_restore_data),
                                         ],
                                       )
                                   ),
                                 ),
                                 InkWell(
                                   borderRadius: BorderRadius.circular(8.0),
                                   onTap: (){
                                     exportData();
                                     ignoreInput = false;
                                   },
                                   child: ListTile(
                                       title: new Row(
                                         children: <Widget>[
                                           new Text(AppLocalizations.of(context)!.settings_export_data),
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
                                     openAboutPage(context);
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
       )
   );
 }
}
