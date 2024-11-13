// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class ShowMapUI extends StatefulWidget {
  const ShowMapUI({super.key});

  @override
  State<ShowMapUI> createState() => _ShowMapUIState();
}

class _ShowMapUIState extends State<ShowMapUI> {

  Future<void> _animateMapMove(LatLng destLocation, double destZoom) async {
    final startLat = 13.7076197;
    final startLng = 100.3569401;
    final startZoom = 15.0;

    final latDelta = (destLocation.latitude - startLat) / 50;
    final lngDelta = (destLocation.longitude - startLng) / 50;
    final zoomDelta = (destZoom - startZoom) / 50;

    for(int i = 1; i <= 50; i++) {
      final nextLat  = startLat + latDelta * i;
      final nextLng  = startLng + lngDelta * i;
      final nextZoom = startZoom + zoomDelta * i;

      mapController.move(LatLng(nextLat, nextLng), nextZoom);
      await Future.delayed(Duration(milliseconds: 20));
    }
  }

  LatLng? newPosition, initPosition = LatLng(13.7076197,100.3569401);

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        initPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  //ตัวแปรเก็บ Marker
  //Marker? marker;

  // changeMarker(LatLng position) {
  //   setState(() {
  //     marker = Marker(
  //       width: 80.0,
  //       height: 80.0,
  //       point: position,
  //       child: Icon(
  //         Icons.location_on,
  //         color: Colors.red,
  //       ),
  //     );
  //   });
  // }

  MapController mapController = new MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'Show Map UI',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter:
                          newPosition == null ? initPosition! : newPosition!,
                      initialZoom: 15.0,
                      onLongPress: (tapPosition, point) {
                        // changeMarker(point);
                        setState(() {
                          newPosition = point;
                          _animateMapMove(point, 15.0);
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                             //'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                            'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: newPosition == null
                                ? initPosition!
                                : newPosition!,
                            radius: 500,
                            useRadiusInMeter: true,
                            color: Colors.purple.withOpacity(0.5),
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: newPosition == null
                                ? initPosition!
                                : newPosition!,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
