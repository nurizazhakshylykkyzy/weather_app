import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/api.dart';
import 'package:weather_app/weather_util.dart';
import 'pages/city_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _cityName = '';
  String _celcius = '';
  String _description = '';
  String _icon = '';
  bool _isLoading = false;

  @override
  void initState() {
    showWeatherLocation();
    super.initState();
  }

  Future<void> showWeatherLocation() async {
    setState(() {
      _isLoading = true;
    });
    final position = await getLocation();
    await getCurrentWeather(position);
    // log('position latitude ===> ${position.latitude}');
    // log('position longitude ===> ${position.longitude}');
    setState(() {
      _isLoading = false;
    });
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentWeather(Position currentPosition) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${currentPosition.latitude}35&lon=${currentPosition.longitude}139&appid=$api');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        final _data = jsonDecode(body) as Map<String, dynamic>;
        _cityName = _data['name'];
        final kelvin = _data['main']['temp'] as num;

        _celcius = WeatherUtil.calculateWeather(kelvin);
        _description = WeatherUtil.getDescription(int.parse(_celcius));
        _icon = WeatherUtil.getWeatherIcon(kelvin);

        setState(() {});
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getCityWeather(String cityName) async {
    setState(() {
      _isLoading = true;
    });
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api');
      final joop = await client.get(uri);
      if (joop.statusCode == 200 || joop.statusCode == 201) {
        final _data = jsonDecode(joop.body) as Map<String, dynamic>;
        _cityName = _data['name'];
        final kelvin = _data['main']['temp'] as num;

        _celcius = WeatherUtil.calculateWeather(kelvin);
        _description = WeatherUtil.getDescription(int.parse(_celcius));
        _icon = WeatherUtil.getWeatherIcon(kelvin);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (katany) {
      setState(() {
        _isLoading = false;
      });

      throw Exception(katany);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: GestureDetector(
            onTap: () async {
              await showWeatherLocation();
              log('showWeatherLocation ==> ${showWeatherLocation()}');
            },
            child: Icon(
              Icons.navigation_rounded,
              size: 70.0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityPage(),
                  ),
                );
                getCityWeather(result);
                setState(() {});
              },
              icon: const Icon(
                Icons.location_city,
                size: 70.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pogoda.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? Center(
                child: const CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 150, right: 90),
                    child: Text(
                      "$_celcius\u00B0 $_icon",
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 60.0,
                    ),
                    child: Text(
                      _description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.1, left: 40),
                    child: Text(
                      _cityName,
                      style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
