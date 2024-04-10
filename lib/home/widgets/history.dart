import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/api/api_caller.dart';
import 'package:pm2_5_term_project/helpers/alert_dialog.dart';
import 'package:pm2_5_term_project/model/forecast_details.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String defaultCity = 'bangkok';
  List<ForecastDetails>? _forecastDetails;

  Future<void> _loadForecastItems(String path) async {
    try {
      final response = await ApiCaller().get(defaultCity);
      final data = jsonDecode(response);

      setState(() {
        List list = data['data']['forecast']['daily']['$path'];
        print(list);
        _forecastDetails =
            list.map((e) => ForecastDetails.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('pm25');
                },
                child: Text("PM 2.5"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('pm10');
                },
                child: Text("PM 10"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _loadForecastItems('o3');
                },
                child: Text("O Zone"),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: _forecastDetails == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: _forecastDetails?.length,
                    itemBuilder: (context, index) {
                      var item = _forecastDetails?[index];
                      return ListTile(
                        title: Text('Date: ${item?.day}'),
                        subtitle:
                            Text('Min: ${item?.min}\nMax: ${item?.max}\n'),
                        leading: Text(
                          'AVG: ${item!.average}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
