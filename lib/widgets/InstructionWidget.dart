import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashWidget extends StatefulWidget {
  final Map<String, double> data;
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  SplashWidget({Key key, this.data}) : super(key: key);

  @override
  State createState() => _SplashState();
}

class _SplashState extends State<SplashWidget>{
  final pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  finishSplash() async {
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

  Widget introScreen(BuildContext context) {
    return Column(
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
                  "Welcome to Money Tracker!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
            )
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Center(
                child: Text(
//                  "1. Choose your monthly reset date\n"
                  "1. Set your Daily Limits\n"
                      "2. Keep recording your spendings\n"
                      "3. See how much you've saved",
                  style: TextStyle(
                      fontSize: 17,
                      height: 1.4
                  ),
                )
            )
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
            color: Color.fromRGBO(149, 213, 178, 1),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                      onTap:(){
                        nextPage();
                      },
                      title: Text("Next",
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
    );
  }

  Widget dailyLimit(BuildContext context){
    return Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Icon(
                  Icons.attach_money,
                  size: 190,
                  color: Color.fromRGBO(149, 213, 178, 1),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Center(
                    child: Text(
                      "How much would you like to \nspend daily on average?",
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
                                controller: widget.amountController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Daily Limit',
                                ),
                                keyboardType: TextInputType.number,
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
                color: Color.fromRGBO(149, 213, 178, 1),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                          onTap:(){
                            finishSplash();
                          },
                          title: Text("Start",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = <Widget>[
      introScreen(context),
      dailyLimit(context),
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
}