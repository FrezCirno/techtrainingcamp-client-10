import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_Flutter/weather/location.dart';
import 'package:http/http.dart' as http;
import 'hourly_weather_data.dart';

class HourlyWeatherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HourlyWeatherState();
  }
}

class HourlyWeatherState extends State<HourlyWeatherWidget> {
  List<HourlyWeatherData> weathers=List<HourlyWeatherData>();

  HourlyWeatherState(){
    _getWeather();
  }

  void _getWeather() async{
    List<HourlyWeatherData> data = await _fetchWeather();
    setState((){
      weathers = data;
    });
  }

  Future<List<HourlyWeatherData>> _fetchWeather() async{
    final position = await Location.fetchLocation();
    final response = await http.get(
      'https://devapi.heweather.net/v7/weather/24h?location=${position.longitude},${position.latitude}&key=9a610fe5bae14bcb9f9ae41fbad6f0b3');
    if(response.statusCode == 200){
      return HourlyWeatherData.fromJson(json.decode(response.body));
    }else{
      return List<HourlyWeatherData>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weathers.length,
        padding: EdgeInsets.only(left: 10, right: 10),
        itemBuilder: (context, index) {
          final item = this.weathers[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10,),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        item.time,
                        style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset("weather-icon/bw-256/"+ item.pic,width:30,height: 30,),
                    SizedBox(
                    height: 10,
                    ),
                    Text(
                      item.tmp,
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
            ),
          );
        }
      ),
    );   
  }       
}

