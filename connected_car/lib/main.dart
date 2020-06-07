import 'package:flutter/material.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connected Car App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //call home page (connected car page)
      home: HomePage(),
    );
  }
}