class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度
  String wind;//风速
  String pic; //图片

  WeatherData({this.cond, this.tmp, this.hum,this.wind,this.pic});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    if (json['code']!="200")
      return WeatherData.empty();
    return WeatherData(
      cond: json['now']['text'],
      tmp: json['now']['temp']+"°",
      hum: json['now']['humidity']+"%",
      wind:json['now']['windSpeed']+"m/s",
      pic: json['now']['icon']+".png",
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "-",
      tmp: "-",
      hum: "-",
      wind:"-",
      pic:"999.png",
    );
  }
}