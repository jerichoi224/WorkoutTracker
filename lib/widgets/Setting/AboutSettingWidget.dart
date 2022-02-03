import 'package:flutter/material.dart';

class AboutSettingsWidget extends StatefulWidget {
  AboutSettingsWidget({Key? key}) : super(key: key);

  @override
  State createState() => _AboutSettingsState();
}
class _AboutSettingsState extends State<AboutSettingsWidget> {

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
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.05),
                expandedHeight: 100.0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('About'),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [

                    ]),
              ),
            ],
          ),
        )
    );
  }
}