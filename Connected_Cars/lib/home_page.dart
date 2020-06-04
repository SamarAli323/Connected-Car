import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic _currentSpeed;
  dynamic _time30KMTo10;
  dynamic _time10KmTo30;
  dynamic _time30;
  dynamic _time10;

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => _getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Car"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _currentSpeed != null
                ? Text("Current Speed $_currentSpeed Km/h")
                : Text("Current Speed 0 Km/h"),
            if (_time30KMTo10 != null)
              Text("from 30 to 10 $_time30KMTo10 seconds"),
            if (_time10KmTo30 != null)
              Text("from 10 to 30 $_time10KmTo30 seconds"),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    var geolocator = Geolocator();
    var options =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    await geolocator.getPositionStream(options).listen((position) {
      var _diff30Km;
      var _diff10Km;
      var _speed = position.speed * 3.6;
      setState(() {
        _currentSpeed = _speed;
      });
      if (_currentSpeed == 30) {
        _getTime30KM(position);
      } else if (_currentSpeed == 10) {
        _getTime10KM(position);
      }
      _diff10Km = _time30.difference(_time10);
      _diff30Km = _time10.difference(_time30);
      if (_diff10Km.inSeconds >= 0) {
        setState(() {
          _time10KmTo30 = _diff10Km.inSeconds;
        });
      } else if (_diff30Km.inSeconds >= 0) {
        setState(() {
          _time30KMTo10 = _diff30Km.inSeconds;
        });
      } else {
        setState(() {
          _time10KmTo30 = 0;
          _time30KMTo10 = 0;
        });
      }
    });
  }

  _getTime30KM(position) {
    var time = new DateTime.now();
    setState(() {
      _time30 = time;
    });
  }

  _getTime10KM(position) {
    var time = new DateTime.now();
    setState(() {
      _time10 = time;
    });
  }
}
