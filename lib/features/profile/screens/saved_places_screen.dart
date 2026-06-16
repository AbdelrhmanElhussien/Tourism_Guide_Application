import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/home/widgets/destination_card.dart';
import 'package:tourist_app/features/home/provider/place_provider.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      if (mounted) {
        context.read<PlaceProvider>().fetchPlaces();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<PlaceProvider>().fetchMorePlaces();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBlueColor : const Color(0xffF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final horizontalPadding = (width * 0.045).clamp(18.0, 32.0);
          final crossAxisCount = width >= 700 ? 3 : 2;
          final spacing = (width * 0.035).clamp(12.0, 18.0);

          return SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Rounded Header ──
                Consumer<PlaceProvider>(
                  builder: (context, placeProvider, child) {
                    final placesCount = placeProvider.places.length;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        24,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.bottomNavigationColor : AppColors.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'saved_places'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'destinations_saved'.tr(args: [placesCount.toString()]),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<PlaceProvider>(
                    builder: (context, placeProvider, child) {
                      if (placeProvider.isLoadingPlaces && placeProvider.places.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (placeProvider.errorMessagePlaces != null && placeProvider.places.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                placeProvider.errorMessagePlaces!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => placeProvider.fetchPlaces(forceRefresh: true),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (placeProvider.places.isEmpty) {
                        return Center(child: Text('no_places_found'.tr()));
                      }

                      return CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                            sliver: SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                childAspectRatio: width >= 700 ? 0.82 : 0.66,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return DestinationCard(
                                    place: placeProvider.places[index],
                                    compact: true,
                                  );
                                },
                                childCount: placeProvider.places.length,
                              ),
                            ),
                          ),
                          if (placeProvider.isFetchingMorePlaces)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
