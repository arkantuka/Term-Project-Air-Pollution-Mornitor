import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PM25Page extends StatefulWidget {
  @override
  _PM25PageState createState() => _PM25PageState();
}

class _PM25PageState extends State<PM25Page> {
  String pm25Data = '';
  String city_name = '';
  String apiKey = '26bbfd01360f5d6e348f854015a276072216b1a5';
  String baseUrl = 'https://api.waqi.info/feed';
  String city = 'bangkok';
  static final _dio = Dio(BaseOptions(responseType: ResponseType.plain));

  Future<void> fetchPM25Data() async {
    final response = await _dio.get('$baseUrl/$city/?token=$apiKey');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.data);
      if (jsonData['status'] == 'error') {
        throw Exception(jsonData['message']);
      } else {
        setState(() {
          pm25Data = jsonData['data']['iaqi']['pm25']['v'].toString();
          city_name = jsonData['data']['city']['name'];
        });
      }
    } else {
      throw Exception('Failed to load PM2.5 data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPM25Data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PM2.5 Checker'),
      ),
      body: Center(
        child: pm25Data.isEmpty
            ? CircularProgressIndicator()
            : Text('PM2.5 Level in $city_name : $pm25Data'),
      ),
    );
  }
}
