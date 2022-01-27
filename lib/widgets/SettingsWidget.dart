import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key? key}) : super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
   bool bToggle = false;

  @override
  void initState() {
    super.initState();
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
                   // System Values
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                       child: Text("System Values",
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
                           ListTile(
                               title: new Row(
                                 children: <Widget>[
                                   new Text("User Profile"),
                                 ],
                               )
                           ),
                         ],
                       )
                   ),
                   Card(
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                       margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                       color: Theme.of(context).colorScheme.primary,
                       child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             ListTile(
                                 onTap:(){
                                   Navigator.pop(context, false);
                                   setState(() {});
                                 },
                                 title: Text("Save Setting",
                                   style: TextStyle(
                                     fontSize: 18,
                                   ),
                                   textAlign: TextAlign.center,
                                 )
                             )
                           ]
                       )
                   ),// Save Button
                 ]),
               ),
             ],
           ),
         )
     );
   }
}