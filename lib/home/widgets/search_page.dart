import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/api/api_caller.dart';
import 'package:pm2_5_term_project/api/search_api.dart';
import 'package:pm2_5_term_project/helpers/alert_dialog.dart';
import 'package:pm2_5_term_project/model/daily_forecast.dart';
import 'package:pm2_5_term_project/model/details.dart';
import 'package:pm2_5_term_project/model/forecast_details.dart';
import 'package:pm2_5_term_project/model/search_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  String responseData = '';
  List<SearchDetails>? _searchdetailslog;
  String error_msg = '';
  String status = '';

  Color aqi_color(String? aqi) {
    if (aqi == '-') {
      return Colors.grey;
    } else {
      int num_aqi = int.parse(aqi!);
      if (num_aqi <= 50) {
        return Colors.green;
      } else if (num_aqi <= 100) {
        return Colors.yellow;
      } else if (num_aqi <= 150) {
        return Colors.orange;
      } else if (num_aqi <= 200) {
        return Colors.red;
      } else if (num_aqi <= 250) {
        return Colors.purple;
      } else if (num_aqi <= 300) {
        return Colors.deepPurpleAccent;
      } else {
        return Colors.green;
      }
    }
  }

  int aqi_level(int? api) {
    if (_detailslog != null) {
      if (_detailslog!.aqi! <= 50) {
        return 0;
      } else if (_detailslog!.aqi! <= 100) {
        return 1;
      } else if (_detailslog!.aqi! <= 150) {
        return 2;
      } else if (_detailslog!.aqi! <= 200) {
        return 3;
      } else if (_detailslog!.aqi! <= 250) {
        return 4;
      } else if (_detailslog!.aqi! <= 300) {
        return 5;
      } else {
        return 6;
      }
    } else {
      return 0;
    }
  }

  Future<void> _loadSearchDetails(String query) async {
    try {
      final response = await SearchApiCaller().get(query.toLowerCase());
      final data = jsonDecode(response);

      setState(() {
        status = data['status'];
        print(status);
        if (status == 'ok') {
          List list = data['data'];
          _searchdetailslog =
              list.map((item) => SearchDetails.fromJson(item)).toList();
        } else {
          error_msg = data['message'];
        }
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Details? _detailslog;
  DailyForecastDetails? _dailyForecastDetails;

  Future<void> _loadItems(String chosenCity) async {
    try {
      final response = await ApiCaller().get(chosenCity);
      final data = jsonDecode(response);

      setState(() {
        _detailslog = Details.fromJson(data['data']);
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _loadForecastItems(
      String chosenCity, String path, int index) async {
    try {
      final response = await ApiCaller().get(chosenCity);
      final data = jsonDecode(response);

      setState(() {
        _dailyForecastDetails =
            DailyForecastDetails.fromJson(data['data']['forecast']['daily']);
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    } catch (e) {
      rethrow;
    }
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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search by City Name',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              await _loadSearchDetails(searchQuery);
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: _searchdetailslog == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: _searchdetailslog?.length,
                    itemBuilder: (context, index) {
                      var item = _searchdetailslog?[index];
                      return ListTile(
                        tileColor: aqi_color(item!.aqi),
                        title: Text(item.station_name ?? ''),
                        subtitle: Text(
                            'Checking time: ${item.checking_time}\nTime zone: ${item.time_zone}'),
                        leading: Text(
                          item.aqi.toString(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          print('You clicked on: ${item.url}');
                          await _loadItems(item.url);
                          await _loadForecastItems(item.url, 'pm25', 8);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(item.station_name ?? ''),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      images_aqi_level[
                                          aqi_level(_detailslog?.aqi)],
                                      width: 300,
                                      height: 95,
                                      fit: BoxFit.contain,
                                    ),
                                    Text('AQI: ${_detailslog?.aqi}'),
                                    Text(
                                        'องค์กรตรวจวัด: ${_detailslog?.attributions}'),
                                    Text(
                                        'PM 2.5: ${_dailyForecastDetails?.daily_pm25}'),
                                    Text(
                                        'PM 10: ${_dailyForecastDetails?.daily_pm10}'),
                                    Text(
                                        'Ozone: ${_dailyForecastDetails?.daily_o3}'),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
