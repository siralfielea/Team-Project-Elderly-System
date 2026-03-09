import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:team_app/models/user_settings.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  final _tileProvider = FMTCTileProvider(stores: const {'mapCache': BrowseStoreStrategy.readUpdateCreate},);

  StreamSubscription<Position>? _positionStream;

    Future<bool> _requestLocationPermission() async {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        return true;
      } else if (status.isDenied) {
        // Request again
        status = await Permission.locationWhenInUse.request();
        return status.isGranted;
      } else if (status.isPermanentlyDenied) {
        // Open app settings
        openAppSettings();
        return false;
      }
      return false;
}
    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the 
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale 
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately. 
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      } 

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }

    String _currentTheme(AppThemeMode theme) {
        switch(theme) {
            case AppThemeMode.dark: return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
            case AppThemeMode.highContrast: return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
            default: return 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
            }
    }

    IconData _getIconFromName(String name) {
    switch (name) {
        case 'man': return Icons.boy_sharp;
        case 'woman': return Icons.girl_sharp;
        case 'wheelchair': return Icons.accessible;
        default: return Icons.location_on;
        }
    }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission().then((granted) {
        if (granted) {
    _determinePosition().then((position) {
        if (!mounted) return;
        setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
                });
                });
                }
    });
  _positionStream = Geolocator.getPositionStream().listen((position) {
    if (!mounted) return;
    setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
        });
    }

  @override 
  void dispose() {
  _positionStream?.cancel();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
  final settings = context.watch<UserSettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack( 
        children: [ 
          FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition ?? LatLng(53.8008, -1.5491), // Leeds
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: _currentTheme(settings.themeMode),
              userAgentPackageName: 'com.example.team_app',
              subdomains: ['a', 'b', 'c'],
              tileProvider: _tileProvider,
            ),
            MarkerLayer(
                markers: [
                    Marker(
                        point: _currentPosition ?? LatLng(53.8008, -1.5491), 
                        width:80, height: 80, 
                        child: Icon(_getIconFromName(settings.mapIcon)),
                        ),
                ],
            )
          ],
        ),
        Positioned(
            bottom: 16,
            right: 16,
                child: Column( 
                 children: [
                   IconButton.filled( 
                       icon: Icon(Icons.near_me),
                       onPressed: _currentPosition == null
                          ? null 
                          : () => _mapController.moveAndRotate(_currentPosition!, 16, 0),
                       ), 
                 ],
                 ),
            ),
        ],
        ),
    );
  }
}
