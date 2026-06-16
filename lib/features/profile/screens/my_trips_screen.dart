import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/profile/cubit/trips_cubit.dart';
import 'package:tourist_app/features/profile/cubit/trips_states.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;

    return BlocProvider(
      create: (context) => getIt<TripsCubit>()..fetchTrips(),
      child: Scaffold(
        backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isLight ? AppColors.primaryColor : Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<TripsCubit, TripsState>(
            builder: (context, state) {
              if (state is TripsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (state is TripsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMsg,
                        style: TextStyle(color: isLight ? Colors.black : Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TripsCubit>().fetchTrips();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is TripsSuccess) {
                final trips = state.trips;
                final selectedTrip = state.selectedTrip;

                if (trips.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_travel_outlined,
                            size: 80,
                            color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_trips_found'.tr() == 'no_trips_found' ? 'No trips found yet.' : 'no_trips_found'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isLight ? AppColors.primaryColor : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'plan_journey'.tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'my_trips_title'.tr(),
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'plan_journey'.tr(),
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Horizontal Trips Selector
                      SizedBox(
                        height: 75,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            final trip = trips[index];
                            final isSelected = selectedTrip?.id == trip.id;
                            return GestureDetector(
                              onTap: () {
                                context.read<TripsCubit>().selectTrip(trip.id);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12, bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : (isLight ? Colors.white : const Color(0xFF162535)),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : (isLight ? Colors.black.withOpacity(0.06) : Colors.white.withOpacity(0.06)),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.title,
                                      style: GoogleFonts.inter(
                                        color: isSelected ? Colors.white : (isLight ? AppColors.primaryColor : Colors.white),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${trip.startDate} - ${trip.endDate}',
                                      style: GoogleFonts.inter(
                                        color: isSelected ? Colors.white70 : Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Selected Trip Details
                      if (selectedTrip != null) ...[
                        // Trip Banner Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC5A352),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedTrip.title,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                                    onPressed: () {
                                      // Trigger Delete Trip Confirmation (Phase 2)
                                      _showDeleteConfirmation(context, selectedTrip.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${selectedTrip.startDate} - ${selectedTrip.endDate}',
                                    style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9)),
                                  ),
                                ],
                              ),
                              if (selectedTrip.notes.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  selectedTrip.notes,
                                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.85), fontSize: 13),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Render Days & Activities
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedTrip.days.length,
                          itemBuilder: (context, dayIndex) {
                            final day = selectedTrip.days[dayIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDayHeader('D${day.dayNumber}', '${"day".tr()} ${day.dayNumber}', day.date, isLight),
                                ...day.activities.map((activity) {
                                  return _buildTimelineCard(
                                    context,
                                    selectedTrip.id,
                                    activity.id,
                                    activity.title,
                                    activity.time,
                                    activity.imageUrl,
                                    isLight,
                                    notes: activity.notes,
                                  );
                                }),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        ),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(String label, String title, String date, bool isLight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, String tripId, String activityId, String title, String time, String? imageUrl, bool isLight, {String? notes}) {
    final bool isNetwork = imageUrl != null && (imageUrl.startsWith('http') || imageUrl.startsWith('https'));
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(left: 48, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF162535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: hasImage
                  ? (isNetwork
                      ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackImage())
                      : Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackImage()))
                  : _buildFallbackImage(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                if (notes != null && notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notes,
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (dialContext) {
        return BlocProvider.value(
          value: context.read<TripsCubit>(),
          child: Builder(
            builder: (blocContext) {
              return AlertDialog(
                title: const Text('Delete Trip'),
                content: const Text('Are you sure you want to delete this trip?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialContext),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      blocContext.read<TripsCubit>().deleteTrip(tripId);
                      Navigator.pop(dialContext);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              );
            }
          ),
        );
      },
    );
  }
}

