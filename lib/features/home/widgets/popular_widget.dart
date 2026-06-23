import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:tourist_app/features/home/models/place_model.dart';

class PopularWidget extends StatelessWidget {
  final PlaceModel place;

  const PopularWidget({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final contentPadding = 12.w;
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
        width: double.infinity,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 8.5,
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
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: (isDark
                        ? AppStyles.lightYellow18Medium
                        : AppStyles.primary18Medium).copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.lightGrayColor,
                        size: 15.r,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          place.locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: (isDark
                              ? AppStyles.blue14mediume
                              : AppStyles.black14mediume).copyWith(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.yellowColor,
                        size: 15.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${place.rating.toStringAsFixed(1)} (${place.reviewCount})',
                        style: (isDark
                            ? AppStyles.blue14mediume
                            : AppStyles.black14mediume).copyWith(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
