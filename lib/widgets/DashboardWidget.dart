import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<DashboardWidget>{

  void initState() {
    super.initState();
  }

  Widget profileCard()
  {
    return Container(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          color: Colors.white,
          child: new InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {},
              child: ListTile(
                leading: SizedBox(
                    height: 120,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.brown.shade800,
                      child: const Text('AH'),
                    ),
                ),
                dense: true,
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Name",
                          style: TextStyle(color: Colors.black)
                      ),
                    ],
                  ),
                ),
                subtitle: Text("Description"),
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
            appBar: AppBar(
              title: Text("Dashboard"),
              actions: null,
            ),
            body:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: 0
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                              ],
                            )
                        )
                    )
                )
              ],
            )
        )
    );
  }
}