import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = (size.width * 0.58).clamp(210.0, 255.0);
    final horizontalPadding = (size.width * 0.025).clamp(10.0, 14.0);
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            type: DetailType.place,
            title: 'Pyramids of Giza',
            location: 'Giza, Egypt',
            rating: 4.9,
            reviewsCount: 12543,
            assetImage: AppAssets.pyramidsofGiza,
            about:
                "Experience the timeless wonder of the Pyramids of Giza, a monumental feat of ancient engineering.",
            price: "200 EGP",
            hours: "8:00 AM - 5:00 PM",
            distance: "Nearby",
          ),
        );
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bottomNavigationColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(2, 5),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.05), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
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
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pyramids of Giza',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isDark
                          ? AppStyles.lightYellow18Medium
                          : AppStyles.primary18Medium,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.lightGrayColor,
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            'Giza, Egypt',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isDark
                                ? AppStyles.blue14mediume
                                : AppStyles.black14mediume,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.yellowColor,
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '4.9 (12543)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isDark
                                ? AppStyles.blue14mediume
                                : AppStyles.black14mediume,
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
