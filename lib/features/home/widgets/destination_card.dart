import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:tourist_app/features/home/models/place_model.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.place,
    this.compact = false,
  });

  final PlaceModel place;
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

    DetailType detailType = DetailType.place;
    switch (place.category.toLowerCase()) {
      case 'hotel':
        detailType = DetailType.hotel;
        break;
      case 'guide':
        detailType = DetailType.guide;
        break;
      case 'transport':
      case 'transportation':
        detailType = DetailType.transport;
        break;
      case 'program':
        detailType = DetailType.program;
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: place.id,
            type: detailType,
            title: place.name,
            location: place.locationName,
            rating: place.rating,
            reviewsCount: place.reviewCount,
            networkImage: place.imageUrl.isNotEmpty ? place.imageUrl : null,
            about: place.description,
            price: place.priceFrom > 0 ? "${place.priceFrom.toStringAsFixed(0)} EGP" : "Free",
            hours: place.openingHours,
            distance: "${place.distanceKm.toStringAsFixed(1)} km",
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
                child: _DestinationImage(place: place),
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
                    place: place,
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
  const _DestinationImage({required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    if (place.imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        color: const Color(0xFFF4F1EA),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.lightGrayColor,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: place.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: double.infinity,
        color: const Color(0xFFF4F1EA),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: double.infinity,
        color: const Color(0xFFF4F1EA),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.lightGrayColor,
        ),
      ),
    );
  }
}

class _DestinationMeta extends StatelessWidget {
  const _DestinationMeta({required this.place, required this.compact});

  final PlaceModel place;
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
          place.name,
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
                place.locationName,
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
              place.rating.toStringAsFixed(1),
              style: AppStyles.primary16Medium.copyWith(
                color: isDark ? AppColors.begiColor : AppColors.primaryColor,
                fontSize: compact ? 14 : 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '(${place.reviewCount})',
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
