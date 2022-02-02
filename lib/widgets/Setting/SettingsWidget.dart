import 'package:flutter/material.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Setting/ProfileSettingWidget.dart';

class SettingsWidget extends StatefulWidget {
  late ObjectBox objectbox;
  SettingsWidget({Key? key, required this.objectbox,}) : super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
   bool bToggle = false;

  @override
  void initState() {
    super.initState();
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
           builder: (context) => ProfileSettingsWidget(objectbox: widget.objectbox,),
         ));

     if(result.runtimeType == bool && result)
     {
       setState(() {});
     }
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
//                actions: _buildActions(),
               flexibleSpace: const FlexibleSpaceBar(
                 title: Text('Settings'),
               ),
             ),
             SliverList(
               delegate: SliverChildListDelegate(
               [
                 Container(
                   padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                     child: Text("User Settings",
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
                           onTap: (){
                             openProfilePage(context);
                             },
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text("Profile Setting"),
                                 ],
                               )
                           ),
                         ),
                       ],
                     )
                 ),
                 Container(
                     padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                     child: Text("Other",
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
                           onTap: (){
                             openOtherPage(context);
                           },
                           child: ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text("About"),
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