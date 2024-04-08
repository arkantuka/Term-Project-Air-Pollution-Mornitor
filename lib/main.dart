import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/pages/test_page.dart';
import 'pages/pm25_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM2.5 Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(),
    );
  }
}
