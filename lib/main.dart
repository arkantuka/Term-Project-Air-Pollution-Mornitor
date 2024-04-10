import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Pollution Monitor',
      home: HomePage(),
    );
  }
}
