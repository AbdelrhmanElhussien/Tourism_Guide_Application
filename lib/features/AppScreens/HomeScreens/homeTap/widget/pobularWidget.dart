import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';

class pobularWidget extends StatelessWidget {
  const pobularWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final contentPadding = (size.width * 0.035).clamp(12.0, 16.0);
    var themeProvider = Provider.of<Themeprovider>(context);

    return Container(
      width: double.infinity,
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 8.5,
              child: Image.asset(
                AppAssets.pyramidsofGiza,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'pyramids of Giza',
                  style: themeProvider.apptheme == ThemeMode.light
                      ? AppStyles.primary18Medium
                      : AppStyles.lightYellow18Medium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.lightGrayColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.yellowColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '4.9 (1253)',
                      style: themeProvider.apptheme == ThemeMode.light
                          ? AppStyles.black14mediume
                          : AppStyles.blue14mediume,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
