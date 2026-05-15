import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/provider/map_provider.dart';

class MapTap extends StatelessWidget {
  const MapTap({super.key});

  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: mapProvider.cameraPosition,
              mapType: MapType.normal,
              markers: mapProvider.markers,
              onMapCreated: (controller) {
                mapProvider.mapController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapProvider.getUserLocation();
        },
        backgroundColor: AppColors.whiteColor,
        foregroundColor: AppColors.lightGrayColor,
        child: Icon(Icons.location_searching_outlined),
      ),
    );
  }
}
