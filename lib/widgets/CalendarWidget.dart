import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/widgets/Session/AddSessionEntryWidget.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_tracker/widgets/Session/ViewSessionEntryWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarWidget extends StatefulWidget {
  late ObjectBox objectbox;
  CalendarWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _CalendarState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _CalendarState extends State<CalendarWidget>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<SessionEntry> sessionsToday = [];

  void initState() {
    super.initState();
    sessionsToday = _getEventsForDay(DateTime.now());
  }

  List<SessionEntry> _getEventsForDay(DateTime day) {
    List<SessionEntry> s = widget.objectbox.sessionList.where((i)=>(isSameDay(day, DateTime.fromMillisecondsSinceEpoch(i.startTime)))).toList();
    return s;
  }

  void _openEditWidget(BuildContext context, int id) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSessionEntryWidget(objectbox: widget.objectbox, fromRoutine:false, edit: true, id:id),
        ));

    if(result.runtimeType == bool && result)
    {
      setState(() {});
    }
  }

  void _deleteSession(SessionEntry entry)
  {
    // update list and previous session id for workout entries
    for(SessionItem item in entry.sets)
    {
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      widget.objectbox.sessionItemBox.remove(item.id);
      widget.objectbox.itemList.remove(item);

      if(workoutEntry.prevSessionId == item.id)
      {
        List<SessionItem> itemsForWorkout = widget.objectbox.itemList.where((element) => element.workoutId == workoutEntry.id).toList();
        if(itemsForWorkout.length == 0)
          workoutEntry.prevSessionId = -1;
        else
        {
          itemsForWorkout.sort((a, b) => a.time.compareTo(b.time));
          workoutEntry.prevSessionId = itemsForWorkout[0].id;
        }

        widget.objectbox.workoutBox.put(workoutEntry);
      }
    }

    widget.objectbox.sessionList.remove(entry);
    widget.objectbox.sessionBox.remove(entry.id);
    sessionsToday = _getEventsForDay(DateTime.now());
    setState(() {});
  }

  Widget _popUpMenuButton(SessionEntry i) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Edit"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: 1,
        ),
      ],

      onSelected: (selectedIndex) {
        // Edit
        if(selectedIndex == 0){
          _openEditWidget(context, i.id);
        }
        // Delete
        else if(selectedIndex == 1){
          _deleteSession(i);
        }
      },
    );
  }

  String sessionToString(SessionEntry sessionEntry)
  {
    List<String> workoutList = [];
    int i = sessionEntry.sets.length - 1;
    WorkoutEntry? workoutEntry = widget.objectbox.workoutBox.get(sessionEntry.sets[0].workoutId);
    String text = "\t\t" + workoutEntry!.caption;
    if(i > 0)
      text = text + " +" + i.toString() + " workouts";
    return text;
  }

  void _openViewWidget(SessionEntry sessionEntry) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewSessionEntryWidget(objectbox: widget.objectbox, id:sessionEntry.id),
        ));
    if(result.runtimeType == bool && result)
    {
      sessionsToday = _getEventsForDay(DateTime.now());
      setState(() {});
    }
  }

  Widget buildSessionCards(BuildContext context, int index) {
    SessionEntry sessionEntry = sessionsToday[index];
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        color: Colors.white,
        child: new InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {_openViewWidget(sessionEntry);},
            child: SizedBox(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child:RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: sessionEntry.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    height: 1.4
                                )
                            ),
                            // Workout Parts
                            TextSpan(
                                text: sessionEntry.parts.length == 0 ? " " : " ("  + sessionEntry.parts.join(", ") + ")",
                                style: TextStyle(color: Colors.black54)),
                            TextSpan(
                                text: "\n",
                                style: TextStyle(
                                    color: Colors.black54,
                                    height: 1.4
                                )),
                            // Workout Entries
                            TextSpan(
                                text: sessionEntry.sets.length == 0 ? "(No Workout Found)" : sessionToString(sessionEntry),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    height: 1.4
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(child: Container()),
                    _popUpMenuButton(sessionEntry)
                  ],
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          /*
          appBar: AppBar(
            toolbarHeight: 100,
            elevation: 0,
            backgroundColor: Colors.amberAccent,
            title: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 56, top: 36),
              title: Text('Calendar',
                   style: TextStyle(
                       fontSize: 30
                   ),
                 )
            ),
          ),*/
          body: CustomScrollView(
            slivers: <Widget>[

              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                backgroundColor: Colors.amberAccent,
                expandedHeight: 100.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(AppLocalizations.of(context)!.workout_history),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TableCalendar(
                      availableGestures: AvailableGestures.none,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      rowHeight: 45,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            sessionsToday = _getEventsForDay(selectedDay);
                          });
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          // Call `setState()` when updating calendar format
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },
                    ),
                    MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                      itemCount: sessionsToday.length,
                      itemBuilder: buildSessionCards,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        )
    );
  }
}