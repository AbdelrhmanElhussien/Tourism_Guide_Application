import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

class PopularWidget extends StatelessWidget {
  final TourismDestination destination;

  const PopularWidget({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final contentPadding = (size.width * 0.035).clamp(12.0, 16.0);
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 5),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
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
              child: destination.assetImage != null
                  ? Image.asset(
                      destination.assetImage!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : destination.networkImage != null
                      ? Image.network(
                          destination.networkImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
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
                  destination.title,
                  style: isDark ? AppStyles.lightYellow18Medium : AppStyles.primary18Medium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.lightGrayColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        destination.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isDark ? AppStyles.blue14mediume : AppStyles.black14mediume,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.yellowColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${destination.rating} (${destination.reviews})',
                      style: isDark ? AppStyles.blue14mediume : AppStyles.black14mediume,
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
