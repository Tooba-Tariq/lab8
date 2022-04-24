import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(lab8());
}

class lab8 extends StatefulWidget {
  const lab8({Key? key}) : super(key: key);

  @override
  State<lab8> createState() => _lab8State();
}

class _lab8State extends State<lab8> {
  Position? position;

  @override
  initState() {
    Future.delayed(Duration(seconds: 2), () async {
      setState(() {
        _determinePosition();
      });
    });
    super.initState();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    setState(() async {
      position = await Geolocator.getCurrentPosition();
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Geo Location"),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(position != null ? position.toString() : 'Null',
                        style: TextStyle(fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(top: 400.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              getLocation();
                            });
                          },
                          child: Text(
                            'Get Current Location',
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  ]),
            )));
  }
}
