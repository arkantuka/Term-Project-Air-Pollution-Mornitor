import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/api/api_caller.dart';
import 'package:pm2_5_term_project/helpers/alert_dialog.dart';
import 'package:pm2_5_term_project/model/details.dart';
import 'package:pm2_5_term_project/model/forecast_details.dart';

class DetailsShow extends StatefulWidget {
  const DetailsShow({
    super.key,
  });

  @override
  State<DetailsShow> createState() => _DetailsShowState();
}

class _DetailsShowState extends State<DetailsShow> {
  Details? _detailslog;
  ForecastDetails? _forecastDetails;
  String defaultCity = 'bangkok';

  Future<void> _loadItems() async {
    try {
      final response = await ApiCaller().get(defaultCity);
      final data = jsonDecode(response);

      setState(() {
        _detailslog = Details.fromJson(data['data']);
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _loadForecastItems(String path, int index) async {
    try {
      final response = await ApiCaller().get(defaultCity);
      final data = jsonDecode(response);

      setState(() {
        _forecastDetails = ForecastDetails.fromJson(
            data['data']['forecast']['daily']['$path'][index]);
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    List<String> images_aqi_level = [
      '1-green-aqi.png',
      '2-yellow-aqi.png',
      '3-orange-aqi.png',
      '4-red-aqi.png',
      '5-purple-aqi.png',
      '6-maroon-aqi.png',
    ];

    int aqi_level = 0;
    if (_detailslog != null) {
      if (_detailslog!.aqi! <= 50) {
        aqi_level = 0;
      } else if (_detailslog!.aqi! <= 100) {
        aqi_level = 1;
      } else if (_detailslog!.aqi! <= 150) {
        aqi_level = 2;
      } else if (_detailslog!.aqi! <= 200) {
        aqi_level = 3;
      } else if (_detailslog!.aqi! <= 250) {
        aqi_level = 4;
      } else if (_detailslog!.aqi! <= 300) {
        aqi_level = 5;
      } else {
        aqi_level = 6;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            images_aqi_level[aqi_level],
            width: 300,
            height: 95,
            fit: BoxFit.contain,
          ),
          Center(
            child: _detailslog == null
                ? CircularProgressIndicator()
                : Text(
                    "คุณภาพอากาศ : ${_detailslog?.aqi}",
                    style: TextStyle(fontSize: 35),
                  ),
          ),
          const SizedBox(height: 20.0),
          Center(child: Text("สถานที่ตรวจวัด :")),
          Center(
            child: Text("${_detailslog?.city_name}"),
          ),
          const SizedBox(height: 16.0),
          Center(child: Text("องค์กรตรวจวัด :")),
          Center(
            child: Text("${_detailslog?.attributions}"),
          ),
          const SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('pm25', 8);
                  showOkDialog(
                    context: context,
                    title: 'PM 2.5 Today',
                    message:
                        'Date: ${_forecastDetails?.day}\nAverage: ${_forecastDetails?.average}\nMin: ${_forecastDetails?.min}\nMax: ${_forecastDetails?.max}',
                  );
                },
                child: Text("PM 2.5"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('pm10', 8);
                  showOkDialog(
                      context: context,
                      title: 'PM 10 Today',
                      message:
                          'Date: ${_forecastDetails?.day}\nAverage: ${_forecastDetails?.average}\nMin: ${_forecastDetails?.min}\nMax: ${_forecastDetails?.max}');
                },
                child: Text("PM 10"),
              ),
            ],
          ),
          const SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('o3', 7);
                  showOkDialog(
                    context: context,
                    title: 'O3(Ozone) Today',
                    message:
                        'Date: ${_forecastDetails?.day}\nAverage: ${_forecastDetails?.average}\nMin: ${_forecastDetails?.min}\nMax: ${_forecastDetails?.max}',
                  );
                },
                child: Text("Ozone"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
