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
    var size = MediaQuery.of(context).size;
    var themeProvider = Provider.of<Themeprovider>(context);

    return Container(
      width: size.width * 0.8,
      height: size.height*0.29,
      decoration: BoxDecoration(
        color: themeProvider.apptheme == ThemeMode.light
            ? AppColors.whiteColor
            : AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(2, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.blackColor.withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            // Only round the top corners so the image fits the container perfectly
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(
              AppAssets.pyramidsofGiza,
              width: double.infinity, // Forces image to fill width
              height: 150, // Set a fixed height or use AspectRatio
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0), // Consistent padding for text
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
                    Text('Giza, Egypt' , style: themeProvider.apptheme == ThemeMode.light
                        ? AppStyles.black14mediume
                        : AppStyles.blue14mediume,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.yellowColor, size: 16),
                     Text('4.9 (1253)',
                      style: themeProvider.apptheme == ThemeMode.light
                          ? AppStyles.black14mediume
                          : AppStyles.blue14mediume,),
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
