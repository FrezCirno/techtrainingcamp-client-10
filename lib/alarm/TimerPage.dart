
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer _timer;
  int _seconds;

  @override
  Widget build(BuildContext context) {
    return Center(
        widthFactor: 2,
        heightFactor: 2,
        child: Container(
          color: Color(0xffe7eefb),
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(constructTime(_seconds),
                  style: TextStyle(
                    color: Color(purple),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Varela',
                    fontSize: 50,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      onPressed: _startTimer,
                      tooltip:'StartTimer',
                      backgroundColor: Color(0xffffd03d),
                      foregroundColor: Color(purple),
                      icon: Icon(Icons.timer),
                      label: Text('Start',
                        style: TextStyle(
                          color: Color(purple),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Varela',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    FloatingActionButton.extended(
                      onPressed: _stopTimer,
                      tooltip: 'StopTimer',
                      backgroundColor: Color(0xffffd03d),
                      foregroundColor: Color(purple),
                      icon: Icon(Icons.timer_off),
                      label: Text('Stop',
                        style: TextStyle(
                          color: Color(purple),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Varela',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: _resetTimer,
                    tooltip: 'ResetTimer',
                    backgroundColor: Color(0xffffd03d),
                    foregroundColor: Color(purple),
                    icon: Icon(Icons.alarm),
                    label: Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(purple),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Varela',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
        ),
    );
  }

  void _startTimer() async{
    if (_timer != null)
      return;
    // 设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _resetTimer() async{
    setState(() {
      _seconds = 0;
    });
  }

  void _stopTimer() async{
    cancelTimer();
  }

  String constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  void initState() {
    _seconds = 0;
    super.initState();
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

}
