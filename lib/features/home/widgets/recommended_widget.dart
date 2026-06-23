import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:tourist_app/features/home/models/place_model.dart';

class RecommendedWidget extends StatelessWidget {
  final PlaceModel place;

  const RecommendedWidget({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final cardWidth = 230.w;
    final horizontalPadding = 12.w;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: place.id,
            type: DetailType.place,
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
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bottomNavigationColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12.r,
              offset: Offset(2.w, 5.h),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.05), width: 1.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r),
                ),
                child: place.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: place.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error_outline),
                        ),
                      )
                    : Image.asset(
                        AppAssets.pyramidsofGiza,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (isDark
                          ? AppStyles.lightYellow18Medium
                          : AppStyles.primary18Medium).copyWith(fontSize: 15.sp),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.lightGrayColor,
                          size: 14.r,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            place.locationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: (isDark
                                ? AppStyles.blue14mediume
                                : AppStyles.black14mediume).copyWith(fontSize: 11.sp),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.yellowColor,
                          size: 14.r,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            '${place.rating.toStringAsFixed(1)} (${place.reviewCount})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: (isDark
                                ? AppStyles.blue14mediume
                                : AppStyles.black14mediume).copyWith(fontSize: 11.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
