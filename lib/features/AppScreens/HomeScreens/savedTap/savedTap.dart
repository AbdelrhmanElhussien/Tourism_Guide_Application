import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/widgets/destination_card.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/widgets/tourism_destination.dart';

class SavedTap extends StatelessWidget {
  const SavedTap({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = (width * 0.045).clamp(18.0, 32.0).toDouble();
        final topPadding = (width * 0.12).clamp(34.0, 52.0).toDouble();
        final crossAxisCount = width >= 700 ? 3 : 2;
        final spacing = (width * 0.035).clamp(12.0, 18.0).toDouble();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _SavedHeader(savedCount: tourismDestinations.length),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  (width * 0.1).clamp(34.0, 48.0).toDouble(),
                  horizontalPadding,
                  22,
                ),
                sliver: SliverGrid.builder(
                  itemCount: tourismDestinations.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: width >= 700 ? 0.82 : 0.66,
                  ),
                  itemBuilder: (context, index) {
                    return DestinationCard(
                      destination: tourismDestinations[index],
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
}

class _SavedHeader extends StatelessWidget {
  const _SavedHeader({required this.savedCount});

  final int savedCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Places',
          style: AppStyles.primary24semiBold.copyWith(
            color: isDark ? AppColors.begiColor : AppColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$savedCount destinations saved',
          style: AppStyles.lightGray14Regular.copyWith(
            fontSize: 15,
            color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
          ),
        ),
      ],
    );
  }
}
