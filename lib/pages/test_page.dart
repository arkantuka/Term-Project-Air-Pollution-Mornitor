import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TestPage extends StatefulWidget {
  @override
  _PM25PageState createState() => _PM25PageState();
}

class _PM25PageState extends State<TestPage> {
  String pm25Data = '';
  String apiKey = '26bbfd01360f5d6e348f854015a276072216b1a5';
  TextEditingController _searchController = TextEditingController();
  static final _dio = Dio(BaseOptions(responseType: ResponseType.plain));

  Future<void> fetchPM25Data(String city) async {
    final response =
        await _dio.get('https://api.waqi.info/feed/$city/?token=$apiKey');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.data);
      if (jsonData['status'] == 'error') {
        pm25Data = jsonData['message'];
      } else {
        setState(() {
          pm25Data = jsonData['data']['iaqi']['pm25']['v'].toString();
        });
      }
    } else {
      print('object');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPM25Data('thailand'); // Default city: Thailand
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PM2.5 Checker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchPM25Data(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                fetchPM25Data(value);
              },
            ),
          ),
          Center(
            child: pm25Data.isEmpty
                ? CircularProgressIndicator()
                : Text('PM2.5 Level: $pm25Data'),
          ),
        ],
      ),
    );
  }
}
