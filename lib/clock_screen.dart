import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hello_Flutter/constants/constants.dart';
import 'package:hello_Flutter/modules/clock_container.dart';
import 'package:hello_Flutter/modules/fancy_button.dart';
import 'package:hello_Flutter/modules/top_row.dart';
import 'package:hello_Flutter/modules/clock_hands.dart';

import 'location_screen.dart';

final String api = "http://worldtimeapi.org/api/timezone/";
enum Choice { WorldTime, LocalTime }

class ClockPage extends StatefulWidget {
  @override
  ClockPageState createState() => ClockPageState();
}

class ClockPageState extends State<ClockPage> {
  String locationName = "";
  DateTime time = DateTime.now();
  Timer timer;
  Choice choice = Choice.LocalTime;

  @override
  void initState() {
    super.initState();
    setInitialLocation();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        if (choice == Choice.LocalTime) {
          _getLocalTime();
        } else {
          _getWorldTime();
        }
      },
    );
  }

  setInitialLocation() async {
    locationName = await getLocationFromSharedPref();
  }

  Future<String> getLocationFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUsedLocation = prefs.getString('Location');

    return lastUsedLocation ?? 'Asia/Shanghai';
  }

  Future<void> setLocationPref(String location) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('Location', location);
  }

  void _getLocalTime() {
    if (this.mounted) {
      setState(() {
        time = DateTime.now();
      });
    }
  }

  void _getWorldTime() async {
    Response res = await get(api + locationName);
    if (res.statusCode >= 400) return;
    Map worldData = jsonDecode(res.body);
    final datetime = worldData['datetime'];
    if (this.mounted) {
      setState(() {
        time = DateTime.parse(datetime);
      });
    }
  }

  dynamic checkConnection() async {
    bool check = await DataConnectionChecker().hasConnection;
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        TopRow(
          title: 'WORLD CLOCK',
          onPress: () async {
            locationName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LocationList(
                        selectedLocation: locationName,
                      );
                    },
                  ),
                ) ??
                locationName;
            setLocationPref(locationName);
          },
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            child: Text(
              DateFormat("hh:mm a").format(time),
              style: kTimeTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Center(
          child: ClockContainer(
            child: ClockHands(time),
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FancyButton(
              onPress: () {
                choice = Choice.WorldTime;
              },
              label: locationName?.split('/')?.last,
              gradient: choice == Choice.WorldTime
                  ? kActiveButtonGradient
                  : kInActiveButtonGradient,
            ),
            FancyButton(
              onPress: () {
                choice = Choice.LocalTime;
              },
              label: 'Local Time',
              gradient: choice == Choice.LocalTime
                  ? kActiveButtonGradient
                  : kInActiveButtonGradient,
            ),
          ],
        ),
      ],
    );
  }
}
