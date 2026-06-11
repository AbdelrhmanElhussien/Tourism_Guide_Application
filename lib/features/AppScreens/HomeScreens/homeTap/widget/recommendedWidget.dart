import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = (size.width * 0.58).clamp(210.0, 255.0);
    final horizontalPadding = (size.width * 0.025).clamp(10.0, 14.0);
    var themeProvider = Provider.of<Themeprovider>(context);
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: themeProvider.apptheme == ThemeMode.light
            ? AppColors.whiteColor
            : AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(2, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.blackColor.withValues(alpha: 0.05),
          width: 1.5,
        ),
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
                    'pyramids of Giza',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeProvider.apptheme == ThemeMode.light
                        ? AppStyles.primary18Medium
                        : AppStyles.lightYellow18Medium,
                  ),

                  Row(
                    children: [
                      Icon(
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
                          style: themeProvider.apptheme == ThemeMode.light
                              ? AppStyles.black14mediume
                              : AppStyles.blue14mediume,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.yellowColor, size: 16),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '4.9 (1253)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: themeProvider.apptheme == ThemeMode.light
                              ? AppStyles.black14mediume
                              : AppStyles.blue14mediume,
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
    );
  }
}
