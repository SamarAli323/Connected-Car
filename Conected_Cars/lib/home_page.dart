import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Car"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentSpeed != null)
              Text("Current Speed ${_currentSpeed} Km/h"),
            if (_time30KMTo10 != null)
              Text("from 30 to 10 ${_time30KMTo10} seconds"),
            if (_time10KmTo30 != null)
              Text("from 10 to 30 ${_time10KmTo30} seconds"),
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
      var speed = position.speed * 3.6;
      setState(() {
        _currentSpeed = speed;
      });
      print("here is the position");
      print(position);
      print(speed);
      print(position.timestamp);
      if (_currentSpeed == 30) {
        _getTime30KM(position);
      } else if (_currentSpeed == 10) {
        _getTime10KM(position);
      }
      if ((_time30 - _time10) > 0) {
        setState(() {
          _time10KmTo30 = _time30 - _time10;
        });
      } else if ((_time10 - _time30) > 0) {
        setState(() {
          _time30KMTo10 = _time10 - _time30;
        });
      } else {
        setState(() {
          _time10KmTo30 = 0.0;
          _time30KMTo10 = 0.0;
        });
      }
    });
  }
  _getTime30KM(position) {
    setState(() {
      _time30 = position.timestamp;
    });
  }

  _getTime10KM(position) {
    setState(() {
      _time10 = position.timestamp;
    });
  }
}
