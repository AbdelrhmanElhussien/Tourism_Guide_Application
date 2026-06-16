import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    this.compact = false,
  });

  final TourismDestination destination;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final cardColor = isDark
        ? AppColors.bottomNavigationColor
        : AppColors.whiteColor;
    final borderColor = isDark
        ? AppColors.blueColor.withOpacity(0.12)
        : AppColors.socialBorder;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.12)
        : Colors.black.withOpacity(0.05);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: destination.id,
            type: DetailType.place,
            title: destination.title,
            location: destination.location,
            rating: destination.rating,
            reviewsCount: destination.reviews,
            assetImage: destination.assetImage,
            networkImage: destination.networkImage,
            about:
                "Experience the beauty and history of ${destination.title}. A perfect destination for your next trip.",
            price: "150 EGP",
            hours: "9:00 AM - 5:00 PM",
            distance: "Nearby",
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: compact ? 5 : 7,
                child: _DestinationImage(destination: destination),
              ),
              Expanded(
                flex: compact ? 3 : 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 12 : 16,
                    compact ? 10 : 14,
                    compact ? 10 : 16,
                    compact ? 10 : 14,
                  ),
                  child: _DestinationMeta(
                    destination: destination,
                    compact: compact,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationImage extends StatelessWidget {
  const _DestinationImage({required this.destination});

  final TourismDestination destination;

  @override
  Widget build(BuildContext context) {
    if (destination.assetImage != null) {
      return Image.asset(
        destination.assetImage!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      destination.networkImage!,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          color: const Color(0xFFF4F1EA),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.lightGrayColor,
          ),
        );
      },
    );
  }
}

class _DestinationMeta extends StatelessWidget {
  const _DestinationMeta({required this.destination, required this.compact});

  final TourismDestination destination;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final titleStyle = AppStyles.primary18Medium.copyWith(
      color: isDark ? Colors.white : AppColors.primaryColor,
      fontSize: compact ? 16 : 18,
      fontWeight: FontWeight.w700,
    );
    final secondaryColor = isDark
        ? AppColors.blueColor
        : AppColors.lightGrayColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          destination.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: compact ? 15 : 16,
              color: secondaryColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                destination.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.lightGray14Regular.copyWith(
                  color: secondaryColor,
                  fontSize: compact ? 12 : 13,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              size: compact ? 17 : 18,
              color: AppColors.yellowColor,
            ),
            const SizedBox(width: 4),
            Text(
              destination.rating.toStringAsFixed(1),
              style: AppStyles.primary16Medium.copyWith(
                color: isDark ? AppColors.begiColor : AppColors.primaryColor,
                fontSize: compact ? 14 : 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '(${destination.reviews})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.lightGray12Regular.copyWith(
                  color: secondaryColor,
                  fontSize: compact ? 12 : 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
