import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSection extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoriesSection({super.key, required this.onCategoryTap});

  static const List<_CategoryItemData> _categories = [
    _CategoryItemData(
      icon: Icons.directions_car_outlined,
      labelKey: 'transport',
      categoryName: 'transport',
    ),
    _CategoryItemData(
      icon: Icons.apartment_outlined,
      labelKey: 'hotels',
      categoryName: 'hotels',
    ),
    _CategoryItemData(
      icon: Icons.people_outline_rounded,
      labelKey: 'guide',
      categoryName: 'guide',
    ),
    _CategoryItemData(
      icon: Icons.route_outlined,
      labelKey: 'programs',
      categoryName: 'programs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final itemGap = 8.w;
    final verticalPadding = 12.h;
    final horizontalPadding = 4.w;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: List.generate(_categories.length, (index) {
          final item = _categories[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == _categories.length - 1 ? 0 : itemGap,
              ),
              child: GestureDetector(
                onTap: () => onCategoryTap(item.categoryName),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryColor.withOpacity(0.2)
                        : AppColors.primaryColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      width: 1.5.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: AppColors.yellowColor,
                        size: 24.r,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.labelKey.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryItemData {
  final IconData icon;
  final String labelKey;
  final String categoryName;

  const _CategoryItemData({
    required this.icon,
    required this.labelKey,
    required this.categoryName,
  });
}
