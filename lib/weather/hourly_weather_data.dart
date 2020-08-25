import 'dart:developer';

class HourlyWeatherData{
  String time; //时间
  String cond; //天气
  String tmp; //温度
  String pic; //图片

  HourlyWeatherData({this.time,this.cond, this.tmp,this.pic});
  
  static List<HourlyWeatherData> fromJson(Map<String, dynamic> json) {
    final hourlyWeathers = List<HourlyWeatherData>();
     if (json['code']!="200")
       return hourlyWeathers;
    for (final item in json['hourly']) {
      hourlyWeathers.add(HourlyWeatherData(
          time: item['fxTime'].toString().substring(11,13),
          cond: item['text'],
          tmp: item['temp']+"°",
          pic: item['icon']+".png",
      ));
    }
    return hourlyWeathers;
  }
}