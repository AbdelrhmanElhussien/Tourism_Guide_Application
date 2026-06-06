import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/provider/map_provider.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/screens/place_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MapTap extends StatelessWidget {
  const MapTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // 1. The Map
              GoogleMap(
                initialCameraPosition: mapProvider.cameraPosition,
                mapType: MapType.normal,
                markers: mapProvider.markers,
                polylines: mapProvider.polylines,
                onMapCreated: (controller) {
                  mapProvider.mapController = controller;
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),

              // 2. Search Bar
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: mapProvider.searchController,
                    onChanged: (value) => mapProvider.searchPlaces(value),
                    decoration: InputDecoration(
                      hintText: 'Search for destinations...',
                      border: InputBorder.none,
                      icon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: mapProvider.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                mapProvider.searchController.clear();
                                mapProvider.searchPlaces('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),

              // 3. Search Autocomplete Overlay List
              if (mapProvider.searchPredictions.isNotEmpty)
                Positioned(
                  top: 110,
                  left: 20,
                  right: 20,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: mapProvider.searchPredictions.length,
                      itemBuilder: (context, index) {
                        final prediction = mapProvider.searchPredictions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: AppColors.primaryColor),
                          title: Text(
                            prediction.mainText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            prediction.secondaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            mapProvider.selectPrediction(prediction);
                          },
                        );
                      },
                    ),
                  ),
                ),

              // 4. Category Filters
              Positioned(
                top: 110, // Moved down below search bar
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mapProvider.categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      String category = mapProvider.categories[index];
                      bool isSelected = mapProvider.selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            mapProvider.filterByCategory(category);
                          },
                          backgroundColor: AppColors.whiteColor,
                          selectedColor: AppColors.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 5. Place Details Card (Floating at bottom if selected)
              if (mapProvider.selectedPlace != null)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: _buildPlaceDetailsCard(context, mapProvider),
                ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 170), // Below search and chips
            child: FloatingActionButton(
              onPressed: () {
                mapProvider.getUserLocation();
              },
              backgroundColor: AppColors.whiteColor,
              foregroundColor: AppColors.primaryColor,
              child: const Icon(Icons.location_searching_outlined),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceDetailsCard(BuildContext context, MapProvider mapProvider) {
    final place = mapProvider.selectedPlace!;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Image with Hero Animation
              Hero(
                tag: place.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    place.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                place.category,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            mapProvider.clearSelectedPlace();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          place.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.location_on, color: Colors.grey, size: 20),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            place.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    // Travel distance and duration info from Directions API
                    if (mapProvider.routeDistance != null && mapProvider.routeDuration != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: AppColors.primaryColor, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            mapProvider.routeDistance!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 15),
                          const Icon(Icons.access_time, color: Colors.grey, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            mapProvider.routeDuration!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaceDetailsScreen(place: place),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('View Details',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final String googleMapsUrl =
                        'https://www.google.com/maps/search/?api=1&query=${place.location.latitude},${place.location.longitude}';
                    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                      await launchUrl(Uri.parse(googleMapsUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Could not open Google Maps')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Open in Maps'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
