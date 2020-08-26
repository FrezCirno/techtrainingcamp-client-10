import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hello_Flutter/constants/constants.dart';

class AlarmPage extends StatefulWidget {
  AlarmPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  Timer _timer;
  DateTime _alarmTime;
  int _seconds;
  AudioPlayer _audioPlayer;

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
                    onPressed: _setAlarmTime,
                    tooltip:'SetAlarmTime',
                    backgroundColor: Color(0xffffd03d),
                    foregroundColor: Color(purple),
                    icon: Icon(Icons.alarm),
                    label: Text('Set Alarm',
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
                    onPressed: _openAlarm,
                    tooltip: 'OpenAlarm',
                    backgroundColor: Color(0xffffd03d),
                    foregroundColor: Color(purple),
                    icon: Icon(Icons.alarm_on),
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
                    onPressed: _stopAlarm,
                    tooltip:'StopAlarm',
                    backgroundColor: Color(0xffffd03d),
                    foregroundColor: Color(purple),
                    icon: Icon(Icons.alarm_off),
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
            ]
        ),
      ),
    );
  }

  void _stopAlarm() {
    cancelTimer();
    // 停止播放
    _audioPlayer.release();
  }

  void _setAlarmTime() async{
    var selectedTime =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          child: child,
        );
      },
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      _alarmTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute);
    }
  }

  void _openAlarm() async{
    cancelTimer();
    DateTime nowTime = DateTime.now();
    // 设置到期时间
    if (_alarmTime.isBefore(nowTime)) {
      _alarmTime = _alarmTime.add(new Duration(days: 1));
    }
    _seconds = _alarmTime.difference(nowTime).inSeconds;
    startTimer();
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
    _alarmTime = DateTime.now();
    _seconds = 0;
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  void play() async {
    _audioPlayer.setVolume(0.9);
    int result = await _audioPlayer.play('assets/alarm-sound/demo.mp3', isLocal: true);
    if (result == 1) {
      // success
      print('play success');
    } else {
      print('play failed');
    }
  }

  void startTimer() {
    // 设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _seconds--;
      });
      if (_seconds == 0) {
        cancelTimer();
        // 放歌
        play();
      }
    });
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
