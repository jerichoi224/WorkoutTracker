import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/objectbox.g.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';
import 'package:workout_tracker/widgets/Session/CustomKeyboardWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSessionEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late bool fromRoutine, edit;
  late int id;
  AddSessionEntryWidget({Key? key, required this.objectbox, required this.fromRoutine, required this.edit, required this.id}) : super(key: key);

  @override
  State createState() => _AddSessionEntryState();
}

class _AddSessionEntryState extends State<AddSessionEntryWidget> {
  List<WorkoutEntry> workoutEntryList = [];
  List<WorkoutCard> workoutCardList = [];
  final sessionNameController = TextEditingController();
  String locale = "";
  bool setTime = false;
  bool saveAsRoutine = false;
  late Timer _timer;
  bool showKeyboard = false;

  late SessionEntry? sessionEntry;
  late RoutineEntry? routineEntry;
  String defaultName = "";
  String startDate = "";
  String endDate = "";
  List<String> partList = [];
  int startTime = 0;
  int endTime = 0;
  int year = 0;
  int month = 0;

  TextEditingController? editingController;
  int textLimit = 0;

  @override
  void initState() {
    super.initState();
    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
    if(widget.edit)
      {
        setTime = true;
        sessionEntry = widget.objectbox.sessionList.firstWhere((element) => element.id == widget.id);
        sessionNameController.text = sessionEntry!.name;
        startTime = sessionEntry!.startTime;
        endTime = sessionEntry!.endTime;
        startDate = dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(startTime));
        endDate = dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(endTime));
        partList = sessionEntry!.parts;
        for(SessionItem item in sessionEntry!.sets)
          {
            addWorkoutToList(widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId), false);
            for(SetItem setItem in item.sets)
              {
                AddSet(workoutCardList.length - 1, setItem.metricValue, setItem.countValue);
              }
          }
      }
    else {
      sessionEntry = new SessionEntry();
      DateTime now = new DateTime.now();
      defaultName = dateFormatter.format(now);
      startDate = dateTimeFormatter.format(now);
      endDate = dateTimeFormatter.format(now);
      startTime = now.millisecondsSinceEpoch;
      endTime = 0;
      if (widget.fromRoutine) {
        routineEntry = widget.objectbox.routineList.firstWhere((
            element) => element.id == widget.id);
        partList = routineEntry!.parts;
        for (String strId in routineEntry!.workoutIds) {
          int id = int.parse(strId);
          addWorkoutToList(
              widget.objectbox.workoutList.firstWhere((element) => element.id ==
                  id), true);
        }
      }
      stateTimerStart();
    }
  }

  String timeString()
  {
    DateTime now = new DateTime.now();
    Duration timeElapsed = now.difference(DateTime.fromMillisecondsSinceEpoch(startTime));

    if(timeElapsed.inSeconds < 3600)
      return timeElapsed.toMinutesSeconds();

    return timeElapsed.toHoursMinutesSeconds();
  }

  void stateTimerStart(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(!setTime)
        {
          setState(() {
          });
        }
    });
  }

  List<Widget> selectPartList(setDialogState)
  {
    List<Widget> tagList = [];

    for(int i = 0; i < PartType.values.length; i++)
    {
      PartType p = PartType.values[i];
      tagList.add(
          tag(p.toLanguageString(locale),
              (){
                  if(partList.contains(p.name))
                    partList.remove(p.name);
                  else
                    partList.add(p.name);
                  setState(() {});
                  setDialogState((){});
                } ,
              partList.contains(p.name) ? Colors.amber : Colors.black12)
      );
    }
    return tagList;
  }

  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < partList.length; i++)
      tagList.add(tag(PartType.values.firstWhere((element) => element.name == partList[i]).toLanguageString(locale), (){_openTagPopup(context);}, Colors.amberAccent));
    if(partList.length == 0)
      tagList.add(tag(" + " + AppLocalizations.of(context)!.add_part + "  ", (){_openTagPopup(context);}, Color.fromRGBO(230, 230, 230, 0.8)));
    return tagList;
  }

  void _openTagPopup(BuildContext buildContext)
  {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: false,
                  title: Text(AppLocalizations.of(buildContext)!.choose_parts),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        children: selectPartList(setState)
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text(AppLocalizations.of(buildContext)!.close),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        }
                    )
                  ],
                );
              }
          );
        }
    );
  }

  Widget AddButton(String caption, Function method)
  {
    return ListTile(
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
        children: <Widget>[
          new Icon(
              Icons.add,
              color: Colors.black38
          ),
          new Flexible(
              child: new Text(caption,
                style: TextStyle(
                    color: Colors.black38
                ),
              )
          )
        ],
      ),
      onTap: () => {
        method()
      },
    );
  }

  void AddSet(int cardIndex, double metric, int count) {
    print(workoutCardList[cardIndex].numSets);
    if(workoutCardList[cardIndex].numSets > 0)
    {
      WorkoutCard workoutCard = workoutCardList[cardIndex];
      String prevMetric = workoutCard.metricController[workoutCard.numSets - 1].text;
      String prevCount = "";
      if(![MetricType.km.name, MetricType.miles.name, MetricType.duration.name, MetricType.floor.name].contains(workoutCard.entry.metric))
        prevCount = workoutCard.countController[workoutCard.numSets - 1].text;
      workoutCard.addSet(metric, count, prevMetric.isNotEmpty ? double.parse(prevMetric) : -1, prevCount.isNotEmpty ? int.parse(prevCount) : -1);
    }
    else
      workoutCardList[cardIndex].addSet(metric, count);
    setState(() {});
  }

  void removeWorkout(int ind){
    workoutCardList.removeAt(ind);
    workoutEntryList.removeAt(ind);
    setState(() {});
  }

  void AddWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutListWidget(objectbox: widget.objectbox, list: workoutEntryList,),
        ));

    if(result.runtimeType == WorkoutEntry)
    {
      addWorkoutToList(result as WorkoutEntry, true);
      setState(() {});
    }
  }

  void addWorkoutToList(WorkoutEntry workoutEntry, bool addSet)
  {
    WorkoutCard newCard = new WorkoutCard(workoutEntry, 0);
    workoutCardList.add(newCard);
    workoutEntryList.add(workoutEntry);
    for(String part in workoutEntry.partList)
      if(!partList.contains(part))
        partList.add(part);
    if(addSet)
      AddSet(workoutCardList.length - 1, -1, -1);
  }

  Widget _BuildWorkoutCards(BuildContext context, int index) {
    List<String> WorkoutNames = workoutCardList.map((item) => item.entry.caption).toList();

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(8.0),
//        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child:  ExpansionTile(
            initiallyExpanded: true,
            maintainState: true,
            iconColor: Colors.grey,
            title: ListTile(
              title: new Row(
                children: <Widget>[
                  new Flexible(
                      child: new Text(WorkoutNames.map((element) => element == workoutCardList[index].entry.caption ? 1 : 0).reduce((value, element) => value + element) == 1 ?
                      workoutCardList[index].entry.caption.capitalize(locale) : workoutCardList[index].entry.caption.capitalize(locale) + " (" + WorkoutType.values.firstWhere((element) => element.name == workoutCardList[index].entry.type).toLanguageString(locale) + ")",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ],
              ),
              trailing: new Container(
                child: new IconButton(
                    icon: new Icon(
                        Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed:(){
                      showKeyboard = false;
                      WorkoutCard card = workoutCardList[index];
                      bool ask = false;
                      for(int i = 0; i < card.numSets; i++)
                        {
                          if(card.metricController[i].text.isNotEmpty ||
                              (card.countController[i].text.isNotEmpty && card.countController[i].text != "0:00:00"))
                            {
                              ask = true;
                              break;
                            }
                        }
                      if(ask){
                        confirmPopup(context,
                          AppLocalizations.of(context)!.session_please_confirm,
                          AppLocalizations.of(context)!.session_delete_msg,
                          AppLocalizations.of(context)!.yes,
                          AppLocalizations.of(context)!.no,).then((value) {
                          if(value)
                            confirmDelete(index);
                        });
                      }
                      else{
                        workoutCardList.removeAt(index);
                        workoutEntryList.removeAt(index);
                        partList = [];
                        for(WorkoutEntry entry in workoutEntryList)
                          for(String part in entry.partList)
                            if(!partList.contains(part))
                              partList.add(part);

                        setState(() {
                        });
                      }
                    }
                )
                ,
              ),
            ),
            children: [
              ListView.builder(
              itemCount: workoutCardList[index].numSets,
              itemBuilder: (BuildContext context, int ind) {
                return _BuildSets(context, ind, index);
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            AddButton(AppLocalizations.of(context)!.session_add_set, (){AddSet(index, -1, -1);})
          ]
          )
        )
    );
  }

  int timeTextToTime(String value)
  {
    int time = 0;
    List<String> splitted = value.split(":");
    time += (3600 * int.parse(splitted[0]));
    time += (60 * int.parse(splitted[1]));
    time += int.parse(splitted[2]);
    return time;
  }

  String textToTimeText(String value)
  {
    switch(value.length)
    {
      case 1:
        {
          return "0:00:0" + value;
        }
      case 2:
        {
          return "0:00:" + value;
        }
      case 3:
        {
          return "0:0" + value.substring(0, 1) + ":" + value.substring(1, 3);
        }
      case 4:
        {
          return "0:" + value.substring(0,2) + ":" + value.substring(2, 4);
        }
      case 5:
        {
          return value.substring(0, 1) + ":" + value.substring(1,3) + ":" + value.substring(3, 5);
        }
    }
    return "0:00:00";
  }

  Widget _BuildSets(BuildContext context, int index, int cardInd) {
    WorkoutEntry workoutEntry = workoutCardList[cardInd].entry;
    String prev = " - " ;
    if(workoutEntry.prevSessionId != -1)
      {
        SessionItem? sessionItem = widget.objectbox.sessionItemBox.get(workoutEntry.prevSessionId);
        if(sessionItem != null)
          {
            if(sessionItem.sets.length > index)
            {
              if([MetricType.duration.name].contains(workoutCardList[cardInd].entry.metric))
                {
                  prev = numToTimeText(sessionItem.sets[index].countValue);
                  if(prev.substring(0, 1) == "0")
                    prev = prev.substring(2, prev.length);
                }
              else
                {
                  prev = sessionItem.sets[index].metricValue.toStringRemoveTrailingZero();
                  prev += " " + workoutCardList[cardInd].entry.metric;
                }
              if([MetricType.kg.name].contains(workoutCardList[cardInd].entry.metric))
                prev += " × " + sessionItem.sets[index].countValue.toString();
            }
          }
      }
    return ListTile(
      title: new Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: InkWell(
              onTap: () {
                if(workoutEntry.prevSessionId != -1)
                {
                  SessionItem? sessionItem = widget.objectbox.sessionItemBox.get(workoutEntry.prevSessionId);
                  if(sessionItem != null)
                  {
                    if(sessionItem.sets.length > index)
                    {
                      if([MetricType.duration.name].contains(workoutCardList[cardInd].entry.metric))
                      {
                        prev = numToTimeText(sessionItem.sets[index].countValue);
                        if(prev.substring(0, 1) == "0")
                          prev = prev.substring(2, prev.length);
                        workoutCardList[cardInd].countController[index].text = prev;
                      }
                      else
                      {
                        workoutCardList[cardInd].metricController[index].text = sessionItem.sets[index].metricValue.toStringRemoveTrailingZero();
                      }
                      if([MetricType.kg.name].contains(workoutCardList[cardInd].entry.metric))
                        workoutCardList[cardInd].countController[index].text = sessionItem.sets[index].countValue.toString();
                    }
                  }
                }
              },
              child: Text(prev,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 15
                ),
              ),
            )
          ),
          new Expanded(child: Container()),
          if(![MetricType.duration.name].contains(workoutCardList[cardInd].entry.metric))
            new Container(
              width: 72,
              height: 40,
              child: new TextField(
                onTap: (){
                  showKeyboard = true;
                  editingController = workoutCardList[cardInd].metricController[index];
                  textLimit = 5;
                  },
                cursorColor: Colors.black54,
                maxLength: 5,
                keyboardType: TextInputType.none,
                controller: workoutCardList[cardInd].metricController[index],
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide.none,
                      //borderSide: const BorderSide(),
                    ),
                    counterText: "",
                    fillColor: Color.fromRGBO(240, 240, 240, 1),
                    filled: true
                ),
              ),
            ),
          new Text(" " + workoutCardList[cardInd].entry.metric),
          if([MetricType.kg.name, MetricType.lb.name].contains(workoutCardList[cardInd].entry.metric))
              new Text(" × "),
          if([MetricType.km.name, MetricType.miles.name, MetricType.duration.name, MetricType.floor.name].contains(workoutCardList[cardInd].entry.metric))
            new Text("   "),
            if([MetricType.kg.name, MetricType.lb.name].contains(workoutCardList[cardInd].entry.metric))
              new Container(
                width: 54,
                height: 40,
                child: new TextField(
                  onTap: (){
                    showKeyboard = true;
                    editingController = workoutCardList[cardInd].countController[index];
                    textLimit = 3;
                  },
                  cursorColor: Colors.black54,
                  maxLength: 3,
                  keyboardType: TextInputType.none,
                  controller: workoutCardList[cardInd].countController[index],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide.none,
                        //borderSide: const BorderSide(),
                      ),
                      counterText: "",
                      fillColor: Color.fromRGBO(240, 240, 240, 1),
                      filled: true
                  ),
                ),
              ),
          // Time input
          if([MetricType.km.name, MetricType.miles.name, MetricType.duration.name, MetricType.floor.name].contains(workoutCardList[cardInd].entry.metric))
            new Container(
              width: 80,
              height: 40,
              child: new TextField(
                cursorColor: Colors.black54,
                // 0:00:00 (7) + input (1) = 8
                maxLength: 8,
                keyboardType: TextInputType.number,
                controller: workoutCardList[cardInd].countController[index],
                style: TextStyle(
                  fontSize: 16
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide.none,
                      //borderSide: const BorderSide(),
                    ),
                    counterText: "",
                    fillColor: Color.fromRGBO(240, 240, 240, 1),
                    filled: true
                ),
                onTap: (){
                  workoutCardList[cardInd].countController[index].selection = TextSelection.fromPosition(TextPosition(offset: workoutCardList[cardInd].countController[index].text.length));
                },
                onChanged: (String value){
                  value = value.replaceAll(":", "");
                  while(value.length > 0 && value.substring(0, 1) == "0"){
                    value = value.substring(1, value.length);
                  }
                  if(value.length > 5)
                    value = value.substring(value.length - 5, value.length);
                  if(timeTextToTime(textToTimeText(value)) > 35999)
                    value = "95959"; // 9:59:59 max time.
                  workoutCardList[cardInd].countController[index].text = textToTimeText(value);
                  workoutCardList[cardInd].countController[index].selection = TextSelection.fromPosition(TextPosition(offset: workoutCardList[cardInd].countController[index].text.length));
                },
              ),
            ),
        ],
      ),
      trailing: new Container(
        child: new IconButton(
            icon: new Icon(Icons.close),
            onPressed:(){
              showKeyboard = false;
              workoutCardList[cardInd].remove(index);
              setState(() {
              });
            }
        )
        ,
      ),
    );
  }

  // Save current session and pop screen.
  saveSession() async
  {
    if(!widget.edit)
      {
        await confirmPopup(context,
          AppLocalizations.of(context)!.session_please_confirm,
          AppLocalizations.of(context)!.session_confirm_finish_session,
          AppLocalizations.of(context)!.yes,
          AppLocalizations.of(context)!.no,).then((value)
        {
          if(!value)
            return;
        });
      }

      if(!setTime)
      endTime = DateTime.now().millisecondsSinceEpoch;

    if(endTime < startTime) {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.session_time_msg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if(saveAsRoutine && routineExists(workoutEntryList, widget.objectbox.routineList))
    {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.session_routine_exists),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if(sessionNameController.text.isEmpty)
      {
        if(widget.fromRoutine)
          sessionNameController.text = defaultName + " " + routineEntry!.name;
        else
          sessionNameController.text = defaultName + " " + AppLocalizations.of(context)!.workout;

      }
    sessionEntry!.name = sessionNameController.text;

    sessionEntry!.startTime = startTime;
    sessionEntry!.endTime = endTime;
    sessionEntry!.year = DateTime.fromMillisecondsSinceEpoch(startTime).year;
    sessionEntry!.month = DateTime.fromMillisecondsSinceEpoch(startTime).month;
    sessionEntry!.day = DateTime.fromMillisecondsSinceEpoch(startTime).day;

    List<String> tmpPartList = [];
    List<SessionItem> tempList = [];
    for(WorkoutCard cardItem in workoutCardList)
    {
      if(cardItem.numSets == 0)
        continue;

      // if there's an invalid WorkoutCard, skip it.
      bool skip = true;
      for(int i = 0; i < cardItem.numSets; i++) {
        if ((cardItem.metricController[i].text.isNotEmpty && cardItem.countController[i].text.isNotEmpty) ||
            ([MetricType.km.name, MetricType.miles.name, MetricType.floor.name, MetricType.reps.name].contains(cardItem.entry.metric) && cardItem.metricController[i].text.isNotEmpty) ||
            ([MetricType.duration.name, MetricType.lb.name, MetricType.kg.name].contains(cardItem.entry.metric)  && cardItem.countController[i].text.isNotEmpty)
        )
        {
          skip = false;
          break;
        }
      }
      if(skip)
        continue;

      // Create SessionItem from WorkoutCard
      SessionItem item = new SessionItem();
      item.workoutId = cardItem.entry.id;
      item.time = startTime;
      item.metric = cardItem.entry.metric;
      for(int j = 0; j < cardItem.numSets; j++)
      {
        /*
        required Field of each metric
          km        metric (distance)   (if count == 0, time will be ignored)
          miles     metric (distance)   (if count == 0, time will be ignored)
          floor     metric (num floors) (if count == 0, time will be ignored)
          reps      metric (num reps)   (count is not used)
          kg        count (num count)   (if metric == 0, weight will be 0)
          lb        count (num count)   (if metric == 0, weight will be 0)
          duration  count (time)        (metric is not used)
         */
        if ((cardItem.metricController[j].text.isNotEmpty && cardItem.countController[j].text.isNotEmpty) ||
            ([MetricType.km.name, MetricType.miles.name, MetricType.floor.name, MetricType.reps.name].contains(cardItem.entry.metric) && cardItem.metricController[j].text.isNotEmpty) ||
            ([MetricType.kg.name, MetricType.lb.name, MetricType.duration.name].contains(cardItem.entry.metric) && cardItem.countController[j].text.isNotEmpty)
        )
          if([MetricType.km.name, MetricType.miles.name, MetricType.duration.name, MetricType.floor.name].contains(cardItem.entry.metric))
            {
              item.sets.add(SetItem(
                  metricValue: cardItem.metricController[j].text.isNotEmpty ? double.parse(cardItem.metricController[j].text) : 0,
                  countValue: cardItem.countController[j].text.isNotEmpty ? timeTextToTime(cardItem.countController[j].text) : 0
              ));
            }
        else
          {
            item.sets.add(SetItem(
                metricValue: cardItem.metricController[j].text.isNotEmpty ? double.parse(cardItem.metricController[j].text) : 0,
                countValue: cardItem.countController[j].text.isNotEmpty ? int.parse(cardItem.countController[j].text) : 0
            ));
          }
      }

      for(String part in cardItem.entry.partList)
        if(!tmpPartList.contains(part))
          tmpPartList.add(part);

      tempList.add(item);
      widget.objectbox.sessionItemBox.put(item);

      // update workout Entry Previous Session Ids.
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      List<SessionItem> itemsForWorkout = widget.objectbox.sessionItemBox.query(
          SessionItem_.workoutId.equals(workoutEntry.id)
      ).build().find();

      if(itemsForWorkout.length == 0)
        workoutEntry.prevSessionId = -1;
      else
      {
        itemsForWorkout.sort((a, b) => b.time.compareTo(a.time));
        workoutEntry.prevSessionId = itemsForWorkout[0].id;
      }
      widget.objectbox.workoutBox.put(workoutEntry);
    }

    // if there's nothing to add return.
    if(tempList.length == 0)
    {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.session_add_workout_msg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // if editing, remove previous items.
    List<SessionItem> removeItems = [];
    if(widget.edit)
    {
      // remove and remap previous session for the workouts.
      // if the session being changed is the previous session for the workout
      // look for the previous again.
      for(SessionItem item in sessionEntry!.sets)
      {
        removeItems.add(item);
      }
    }
    sessionEntry!.sets.clear();
    partList = tmpPartList;

    // add the new session
    for(SessionItem item in tempList)
      sessionEntry!.sets.add(item);

    sessionEntry!.parts = partList;

    // Add Session to DB
    widget.objectbox.sessionBox.put(sessionEntry!);

    // update list and previous session id for workout entries
    for(SessionItem item in removeItems)
    {
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      widget.objectbox.sessionItemBox.remove(item.id);
      widget.objectbox.itemList.remove(item);
      if(workoutEntry.prevSessionId == item.id || workoutEntry.prevSessionId == -1)
      {
        List<SessionItem> itemsForWorkout = widget.objectbox.sessionItemBox.query(
            SessionItem_.workoutId.equals(workoutEntry.id)
        ).build().find();
        if(itemsForWorkout.length == 0)
          workoutEntry.prevSessionId = -1;
        else
          {
            itemsForWorkout.sort((a, b) => b.time.compareTo(a.time));
            workoutEntry.prevSessionId = itemsForWorkout[0].id;
          }
        widget.objectbox.workoutBox.put(workoutEntry);
      }
    }
    if(!widget.edit)
      _timer.cancel();

    if(saveAsRoutine && sessionEntry!.sets.length > 0)
      {
        createNewRoutine(sessionEntry!.name);
      }

    // update all lists that changed.
    if(!widget.edit)
      widget.objectbox.sessionList.add(sessionEntry!);

    DateTime now = new DateTime.now();

    widget.objectbox.updateSessionList(now.year, now.month);
    Navigator.pop(context, true);
  }

  void createNewRoutine(String name)
  {
    RoutineEntry routineEntry = new RoutineEntry();

    routineEntry.name = name + " " + AppLocalizations.of(context)!.routine;
    routineEntry.parts = partList;
    routineEntry.workoutIds = workoutEntryList.map((e) => e.id.toString()).toList();

    widget.objectbox.routineBox.put(routineEntry);
    widget.objectbox.routineList = widget.objectbox.routineBox.getAll();
  }

  bool routineExists(List<WorkoutEntry> workoutEntries, List<RoutineEntry> routines)
  {
    for(RoutineEntry routine in routines)
    {
      if(setEquals(routine.workoutIds.toSet(), workoutEntries.map((e) => e.id.toString()).toSet()))
        return true;
    }
    return false;
  }

  void confirmDelete(int index) {
    workoutCardList.removeAt(index);
    workoutEntryList.removeAt(index);
    partList = [];
    for(WorkoutEntry entry in workoutEntryList)
      for(String part in entry.partList)
        if(!partList.contains(part))
          partList.add(part);

    setState(() {
    });
  }

  Widget _popUpMenuButton() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          child: Text(setTime ? AppLocalizations.of(context)!
              .session_set_time_automatically : AppLocalizations.of(context)!
              .session_set_time_manually),
          value: 0,
        ),
      ],

      onSelected: (selectedIndex) {
        if (selectedIndex == 0) {
          setState(() {
            DateTime now = new DateTime.now();
            endDate = dateTimeFormatter.format(now);
            endTime = now.millisecondsSinceEpoch;
            setTime = !setTime;
          });
        }
      },
    );
  }

  Future<int> _selectDate(BuildContext context, int time) async {
    DateTime original = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: original,
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101)
    );
    if(pickedDate == null)
      return 0;

    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(original),
        );
    if(pickedTime == null)
      return 0;

    DateTime picked = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    return picked.millisecondsSinceEpoch;
  }



  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.save),
        onPressed: (){
          saveSession();
          },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child:WillPopScope(
        onWillPop: () async{
          if(showKeyboard)
            {
              showKeyboard = false;
              FocusScope.of(context).unfocus();
              return false;
            }
          if(widget.edit)
            {
              Navigator.of(context).pop();
              return true;
            }
          confirmPopup(context,
            AppLocalizations.of(context)!.session_please_confirm,
            AppLocalizations.of(context)!.session_quit_msg,
            AppLocalizations.of(context)!.yes,
            AppLocalizations.of(context)!.no,).then((value) {
            if(value)
              {
                if(!widget.edit)
                  _timer.cancel();
                Navigator.of(context).pop();
              }
          });
          return false;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              showKeyboard = false;
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text(widget.edit ? AppLocalizations.of(context)!.session_edit_session : AppLocalizations.of(context)!.session_add_session),
                  actions: _buildActions(),
                  backgroundColor: Colors.amberAccent,
                ),
                body: Builder(
                    builder: (context) =>
                    Column(
                      children:
                        [
                          Container(
                            child: Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Text(AppLocalizations.of(context)!.name,
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
                                                        new Flexible(
                                                            child: new TextField(
                                                              onTap: (){showKeyboard = false;},
                                                              controller: sessionNameController,
                                                              decoration: InputDecoration(
                                                                border:InputBorder.none,
                                                                hintText: widget.fromRoutine ?  defaultName + " " + routineEntry!.name : defaultName + " " + AppLocalizations.of(context)!.workout,
                                                                hintStyle: TextStyle(
                                                                    color: Colors.black26
                                                                ),
                                                              ),
                                                            )
                                                        ),
                                                        if(!widget.edit)
                                                          _popUpMenuButton()
                                                      ],
                                                    )
                                                ),
                                                if(setTime)
                                                  ListTile(
                                                      title: new Row(
                                                        children: <Widget>[
                                                          Text(AppLocalizations.of(context)!.session_start_time),
                                                          Expanded(child: Container()),
                                                          InkWell(
                                                            onTap: () async {
                                                              if(!setTime)
                                                                return;
                                                              int newTime = await _selectDate(context, startTime);
                                                              if(newTime != 0)
                                                                setState(() {
                                                                  startTime = newTime;
                                                                  startDate = dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(startTime));
                                                                });
                                                            },
                                                            child: Text(startDate),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ListTile(
                                                    title: new Row(
                                                      children: <Widget>[
                                                        Text(setTime ? AppLocalizations.of(context)!.session_end_time : AppLocalizations.of(context)!.session_workout_time),
                                                        Expanded(child: Container()),
                                                        setTime ?InkWell(
                                                          onTap: () async {
                                                            int newTime = await _selectDate(context, endTime);
                                                            if(newTime != 0)
                                                              setState(() {
                                                                endTime = newTime;
                                                                endDate = dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(endTime));
                                                              });
                                                          },
                                                          child: Text(endDate),
                                                        ) :
                                                        RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child: Icon(
                                                                    Icons.timer,
                                                                    color: Color.fromRGBO(0, 0, 0, 0.7),
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: "\t" + timeString(),
                                                                  style: TextStyle(
                                                                      color: Color.fromRGBO(0, 0, 0, 0.7),
                                                                      fontSize: 16
                                                                  ),
                                                                )
                                                              ]
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ]
                                          )
                                      ),
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                          child: Text(AppLocalizations.of(context)!.workout_part,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey
                                            ),
                                          )
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Wrap(
                                            alignment: WrapAlignment.start,
                                            children: selectedTagList()
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Text(AppLocalizations.of(context)!.routine_details,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey
                                            ),
                                          )
                                      ),

                                      ListView.builder(
                                        itemCount: workoutCardList.length,
                                        itemBuilder: _BuildWorkoutCards,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                      ),
                                      Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                          margin: EdgeInsets.all(8.0),
                                          child: Column(
                                              children: <Widget>[
                                                AddButton(AppLocalizations.of(context)!.workout_add_workout, AddWorkout)
                                              ]
                                          )
                                      ),
                                      if(!widget.edit && !widget.fromRoutine)
                                        Container(
                                          child: Row(
                                              children:[
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  fillColor: MaterialStateProperty.all<Color>(Colors.grey),
                                                  value: saveAsRoutine,
                                                  onChanged: (bool? value) {
                                                    if(value == true)
                                                    {
                                                      if(routineExists(workoutEntryList, widget.objectbox.routineList))
                                                      {
                                                        final snackBar = SnackBar(
                                                          content: Text(AppLocalizations.of(context)!.session_routine_exists),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        return;
                                                      }
                                                    }
                                                    setState(() {
                                                      saveAsRoutine = value!;
                                                    });
                                                  },
                                                ),
                                                Text(AppLocalizations.of(context)!.session_save_as_routine,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      /*
                                  CardButton(
                                      Theme.of(context).colorScheme.primary,
                                      widget.edit ? AppLocalizations.of(context)!.save_changes : AppLocalizations.of(context)!.session_finish_session,
                                          () {saveSession();}
                                  ),
                                  */
                                      Container(
                                        margin: EdgeInsets.all(10),
                                      )
                                    ],
                                  )
                              )
                            ),
                          ),
                          if(showKeyboard)
                            customKeyboard(editingController!, showKeyboard, textLimit, (){showKeyboard = false;})
                        ]
                    )
                )
            )
        )
      )
    );
  }
}