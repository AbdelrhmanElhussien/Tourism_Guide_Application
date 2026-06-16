import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/home/widgets/destination_card.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';
import 'package:tourist_app/features/profile/cubit/profile_cubit.dart';
import 'package:tourist_app/features/profile/cubit/profile_states.dart';

class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({super.key});

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
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'something_went_wrong'.tr() == 'something_went_wrong'
                          ? 'Something went wrong'
                          : 'something_went_wrong'.tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().fetchProfileData();
                      },
                      child: Text(
                        'retry'.tr() == 'retry' ? 'Retry' : 'retry'.tr(),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileSuccess) {
              final savedPlaces = state.savedPlaces;

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
                                'destinations_saved'.tr(args: [savedPlaces.length.toString()]),
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
                          child: savedPlaces.isEmpty
                              ? Center(
                                  child: Text(
                                    'no_saved_places'.tr() == 'no_saved_places'
                                        ? 'No saved places yet'
                                        : 'no_saved_places'.tr(),
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                                  itemCount: savedPlaces.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: spacing,
                                    crossAxisSpacing: spacing,
                                    childAspectRatio: width >= 700 ? 0.82 : 0.66,
                                  ),
                                  itemBuilder: (context, index) {
                                    return DestinationCard(
                                      destination: savedPlaces[index],
                                      compact: true,
                                    );
                                  },
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
