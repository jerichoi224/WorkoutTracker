import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key? key}) : super(key: key);

  @override
  State createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWidget>{

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
                  title: Text('Calendar'),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text("HI")
                  ]
//                    routineList()
                ),
              ),
            ],
          ),
        )
    );
  }
}