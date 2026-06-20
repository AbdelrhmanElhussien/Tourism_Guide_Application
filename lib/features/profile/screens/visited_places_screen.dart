import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/home/models/place_model.dart';
import 'package:tourist_app/features/home/widgets/destination_card.dart';
import 'package:tourist_app/features/profile/cubit/profile_cubit.dart';
import 'package:tourist_app/features/profile/cubit/profile_states.dart';

class VisitedPlacesScreen extends StatelessWidget {
  const VisitedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..fetchProfileData(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBlueColor : const Color(0xffF8FAFC),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMsg,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().fetchProfileData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileSuccess) {
              final visitedList = state.visitedPlaces;
              final placesCount = visitedList.length;

              return LayoutBuilder(
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
                        Container(
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
                                    'visited_places'.tr() == 'visited_places' ? 'Visited Places' : 'visited_places'.tr(),
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
                                '${'visited_places'.tr() == 'visited_places' ? 'Visited Places' : 'visited_places'.tr()}: $placesCount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: visitedList.isEmpty
                              ? Center(
                                  child: Text(
                                    'no_destinations_found'.tr() == 'no_destinations_found'
                                        ? 'No destinations found'
                                        : 'no_destinations_found'.tr(),
                                    style: TextStyle(
                                      color: isDark ? Colors.white60 : Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () => context.read<ProfileCubit>().fetchProfileData(),
                                  child: CustomScrollView(
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
                                              final destination = visitedList[index];
                                              final placeModel = PlaceModel(
                                                id: destination.id ?? '',
                                                name: destination.title,
                                                category: destination.category,
                                                locationName: destination.location,
                                                city: '',
                                                country: '',
                                                description: '',
                                                imageUrl: destination.networkImage ?? destination.assetImage ?? '',
                                                openingHours: '',
                                                rating: destination.rating,
                                                reviewCount: destination.reviews,
                                                priceFrom: 0.0,
                                                distanceKm: 0.0,
                                                latitude: 0.0,
                                                longitude: 0.0,
                                                isRecommended: false,
                                                isPopular: false,
                                              );
                                              return DestinationCard(
                                                place: placeModel,
                                                compact: true,
                                              );
                                            },
                                            childCount: visitedList.length,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
