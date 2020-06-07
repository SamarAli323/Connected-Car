import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initialize variables of speed,time for 10 and 30 km etc
  dynamic _currentSpeed;
  dynamic _time30KMTo10;
  dynamic _time10KmTo30;
  dynamic _time30;
  dynamic _time10;
  var _counter10 = 0;
  var _counter30 = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    //define a timer to call the getCurrenSpeed function every 0.05 seconds
    timer = Timer.periodic(
        Duration(milliseconds: 5), (Timer t) => _getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    // style of the app
    return Scaffold(
      appBar: AppBar(
        //give the title font family RobotoMono-Regula just to change the font
        title: Text(
          'Connected Car',
          style: TextStyle(fontFamily: 'RobotoMono-Regular'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Speed',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            //make space between a widget and another
            SizedBox(height: 15),
            _currentSpeed != null
                ? Text(
                    '$_currentSpeed',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 80),
                  )
                : Text(
                    '0',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 80),
                  ),
            SizedBox(height: 8),
            Text(
              'Km/h',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            SizedBox(height: 25),
            Text(
              'From 10 to 30',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            SizedBox(height: 4),
            _time10KmTo30 != null
                ? Text(
                    '$_time10KmTo30',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 40),
                  )
                : Text(
                    '0',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 40),
                  ),
            SizedBox(height: 4),
            Text(
              'Seconds',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            SizedBox(height: 25),
            Text(
              'From 30 to 10',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            SizedBox(height: 4),
            _time30KMTo10 != null
                ? Text(
                    '$_time30KMTo10',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 40),
                  )
                : Text(
                    '0',
                    style: TextStyle(
                        fontFamily: 'digital-7',
                        color: Colors.green,
                        fontSize: 40),
                  ),
            SizedBox(height: 4),
            Text(
              'Seconds',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'RobotoMono-Regular'),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    var _diff30Km;
    var _diff10Km;
    var geolocator = Geolocator();
    //set the options of the eolocator function to make the accuracy high and make the function changes every 1 m
    var options = LocationOptions(accuracy: LocationAccuracy.high);

    geolocator.getPositionStream(options).listen((position) {
      //assugn the speed of the car and multiplicate ut by 3.6 to make it in km/h
      setState(() {
        _currentSpeed = position.speed * 3.6;
      });
    });

    //check the speed and call the function that calculate the start time of each speed
    if (_currentSpeed == 30) {
      _getTime30KM();
    } else if (_currentSpeed == 10) {
      _getTime10KM();
    }

    //checnk if the cunter is eqaule to one then both speeds has start time
    if (_counter10 == 1 && _counter30 == 1) {
      //compute the difference from 10 km/h to 30 km/h
      _diff10Km = _time30.difference(_time10);
      //compute the difference from 30 km/h to 10 km/h
      _diff30Km = _time10.difference(_time30);

      //if the difference from 10 km/h to 30 km/h positive then the car speed was 10 km/ and then 30 km/h
      if (_diff10Km.inSeconds >= 0) {
        //set the state with difference to reflect in the app
        setState(() {
          _time10KmTo30 = _diff10Km.inSeconds.toString();
        });
        //set both timers to 2 to leave the function once the state was set
        _counter10 = _counter30 = 2;
        //if the difference from 30 km/h to 10 km/h is positive then the car sped was 30 km/ first and then 10 km/h
      } else if (_diff30Km.inSeconds >= 0) {
        //set the state with difference to reflect in the app
        setState(() {
          _time30KMTo10 = _diff30Km.inSeconds.toString();
        });
        //set both timers to 2 to leave the function once the state is set
        _counter10 = _counter30 = 2;
      }
    }
  }

  //compute the time when the car speed was 30 km/h
  _getTime30KM() {
    //increse timer of 30 by 1
    _counter30++;
    if (_counter30 > 1) {
      _counter30 = 1;
    }
    //compute the time now and assign the time to the state
    setState(() {
      _time30 = new DateTime.now();
    });
  }

  //compute the time when the car speed was 10 km/h
  _getTime10KM() {
    //increse timer of 10 by 1
    _counter10++;
    if (_counter10 > 1) {
      _counter10 = 1;
    }
    //compute the time now and assign the time to the state
    setState(() {
      _time10 = new DateTime.now();
    });
  }
}
