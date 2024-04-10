import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:snake_tail/utils/hospial.dart';
import 'package:snake_tail/widgets/appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late double lat, lang;
  late GoogleMapController controler;
  LatLng _center = const LatLng(7.8731, 80.7718);
  late bool loading;
  double zoom = 7;
  final Map<String, Marker> markers = {};

  void _onMapCreated(GoogleMapController _controller) {
    controler = _controller;
  }

  void getNearHospitals() async {
    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lang&type=hospital&radius=50000&key=AIzaSyAhUqrQ-WpkIXqSoeQOEDRw1hCTpbg9ps8";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<Hospital> l = List.empty(growable: true);
        for (var res in data?['results']) {
          l.add(Hospital.fromJson(res));
        }
        setState(() {
          if (l.isNotEmpty) {
            for (final hospital in l) {
              final marker = Marker(
                markerId: MarkerId(hospital.name),
                position: LatLng(hospital.lat, hospital.lang),
                infoWindow: InfoWindow(
                  title: hospital.name,
                ),
              );
              markers[hospital.name] = marker;
            }
          }
        });
      }
    } catch (error) {}
  }

  void getCurrent() async {
    bool isavailable = false;
    LocationPermission permision;

    isavailable = await Geolocator.isLocationServiceEnabled();
    if (!isavailable) {
      return Future.error('Location services are disabled.');
    }

    permision = await Geolocator.checkPermission();

    if (permision == LocationPermission.denied) {
      permision = await Geolocator.requestPermission();
      if (permision == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permision == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    setState(() {
      lat = p.latitude;
      lang = p.longitude;
      _center = LatLng(lat, lang);
      zoom = 11.0;
      getNearHospitals();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    markers.clear();
    loading = true;
    getCurrent();

    // getNearHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: "Near by hospitals"),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: zoom,
              ),
              markers: markers.isNotEmpty ? markers.values.toSet() : {},
            ),
    );
  }
}
