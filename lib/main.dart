import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_Flutter/clock_screen.dart';
import 'package:hello_Flutter/constants/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  var currentIndex = 0;

  final List<Widget> tabPages = [
    ClockPage(),
    ClockPage(),
    ClockPage(),
  ];
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: tabPages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(silver),
        body: TabBarView(
          controller: controller,
          children: tabPages,
        ),
        bottomNavigationBar: SizedBox(
          height: 65,
          child: Material(
            color: Colors.black,
            textStyle: TextStyle(color: Colors.white),
            child: TabBar(
              controller: controller,
              tabs: <Tab>[
                new Tab(text: "时钟", icon: Icon(Icons.home)),
                new Tab(text: "闹钟", icon: Icon(Icons.list)),
                new Tab(text: "天气", icon: Icon(Icons.message)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
