import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int _selectedIndex = 0;

  // Store paths as Strings — Image.asset() is called inside build()
  final List<_CategoryItem> _categories = [
    _CategoryItem(imgPath: AppAssets.historicallIcon, labelKey: 'historical'),
    _CategoryItem(imgPath: AppAssets.cruisesIcon, labelKey: 'cruises'),
    _CategoryItem(imgPath: AppAssets.beacheIcon, labelKey: 'beaches'),
    _CategoryItem(imgPath: AppAssets.EventIcon, labelKey: 'events'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemGap = (size.width * 0.025).clamp(8.0, 12.0);
    final verticalPadding = (size.height * 0.018).clamp(12.0, 16.0);
    final horizontalPadding = (size.width * 0.018).clamp(6.0, 10.0);
    var themeProvider = Provider.of<Themeprovider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: (size.height * 0.012).clamp(8.0, 14.0),
      ),
      child: Row(
        children: List.generate(_categories.length, (index) {
          final item = _categories[index];
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == _categories.length - 1 ? 0 : itemGap,
              ),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: themeProvider.apptheme == ThemeMode.dark
                        ? isSelected
                              ? AppTheme.darkTheme.cardColor
                              : AppColors.primaryColor.withValues(alpha: 0.09)
                        : isSelected
                        ? AppTheme.lightTheme.cardColor
                        : AppColors.primaryColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.blackColor.withValues(alpha: 0.05)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(2, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.imgPath,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: (size.height * 0.008).clamp(5.0, 8.0)),
                      Text(
                        item.labelKey.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.lightGray12Regular.copyWith(
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? isSelected
                                    ? Colors.white
                                    : AppColors.whiteColor
                              : isSelected
                              ? AppColors.blackColor
                              : AppColors.blackColor,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 12,
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

class _CategoryItem {
  final String imgPath;
  final String labelKey;

  const _CategoryItem({required this.imgPath, required this.labelKey});
}
