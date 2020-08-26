import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hello_Flutter/constants/constants.dart';
import 'package:hello_Flutter/weather/hourly_weather.dart';
import 'package:hello_Flutter/weather/location.dart';
import 'package:hello_Flutter/weather/weather_data.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class WeatherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherState();
  }
}

class WeatherState extends State<WeatherWidget> {
  WeatherData weather=WeatherData.empty();

  WeatherState() {
    _getWeather();
  }

  void _getWeather() async {
    WeatherData data = await _fetchWeather();
    setState(() {
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async {
    final position = await Location.fetchLocation();
    final response = await http.get(
        'https://devapi.heweather.net/v7/weather/now?location=${position.longitude},${position.latitude}&key=9a610fe5bae14bcb9f9ae41fbad6f0b3');
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      return WeatherData.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(silver),
        appBar: AppBar(
          backgroundColor: Color(silver),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                style: TextStyle(color: Color(purple)),
              )
            ],
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(weather.cond,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    letterSpacing: 5,
                    fontSize: 40,
                    color: Color(purple),
                  )),
                  SizedBox(
                height: 20,
              ),
                  Image.asset("weather-icon/color-256/" + weather.pic,width: 200,height: 200),
                SizedBox(
                height: 20,
              ),
              Text(" "+weather.tmp,
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    letterSpacing: 5,
                    fontSize: 80,
                    color: Color(purple),
                  )),
              Padding(
                child: Divider(
                  color: Color(purple).withAlpha(50),
                ),
                padding: EdgeInsets.all(10),
              ),
              HourlyWeatherWidget(),
              Padding(
                child: Divider(
                  color: Color(purple).withAlpha(50),
                ),
                padding: EdgeInsets.all(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      "风速",
                      style: TextStyle(color: Color(purple)),
                    ),
                    Text(
                      "${weather.wind}",
                      style: TextStyle(color: Color(purple)),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                        child: Container(
                      width: 1,
                      height: 30,
                      color: Color(purple),
                    )),
                  ),
                  Column(children: [
                    Text(
                      "湿度",
                      style: TextStyle(color: Color(purple)),
                    ),
                    Text(
                      "${weather.hum}",
                      style: TextStyle(color: Color(purple)),
                    )
                  ]),
                ],
              ),
            ])));
  }
}
