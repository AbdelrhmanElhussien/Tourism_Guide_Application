import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/home/widgets/categories_section.dart';
import 'package:tourist_app/features/home/widgets/popular_widget.dart';
import 'package:tourist_app/features/home/widgets/recommended_widget.dart';
import 'package:tourist_app/features/home/widgets/search_widget.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

class HomeTab extends StatefulWidget {
  final Function(String) onCategorySelected;

  const HomeTab({super.key, required this.onCategorySelected});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 24.0);
    final sectionSpacing = (size.height * 0.018).clamp(12.0, 18.0);
    final recommendedHeight = (size.width * 0.64).clamp(220.0, 270.0);
    final listGap = (size.width * 0.04).clamp(12.0, 18.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Welcome!}'.tr(),
              style: AppStyles.mediume24White.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 1),
            Text('Explorer'.tr(), style: AppStyles.mediume24White),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              themeProvider.apptheme == ThemeMode.dark
                  ? themeProvider.changeTheme(ThemeMode.light)
                  : themeProvider.changeTheme(ThemeMode.dark);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: themeProvider.apptheme == ThemeMode.dark
                  ? const Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 28,
                    )
                  : const Icon(
                      Icons.nightlight_outlined,
                      color: AppColors.yellowColor,
                      size: 28,
                    ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
        ],
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        children: [
          // Categories
          SizedBox(height: sectionSpacing),
          CategoriesSection(onCategoryTap: widget.onCategorySelected),

          // Recommended header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'recommended'.tr(),
                style: isDark
                    ? AppStyles.lightYellow24semiBold
                    : AppStyles.primary24semiBold,
              ),
              Text('see_all'.tr(), style: AppStyles.yellow14mediume),
            ],
          ),
          SizedBox(height: sectionSpacing),

          SizedBox(
            height: recommendedHeight,
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (context, index) => SizedBox(width: listGap),
              itemBuilder: (context, index) => const RecommendedWidget(),
            ),
          ),

          SizedBox(height: sectionSpacing + 4),

          // Popular places header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'popular_places'.tr(),
                style: isDark
                    ? AppStyles.lightYellow24semiBold
                    : AppStyles.primary24semiBold,
              ),
              Text('see_all'.tr(), style: AppStyles.yellow14mediume),
            ],
          ),

          SizedBox(height: sectionSpacing),

          // Popular places list
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: tourismDestinations.length,
            separatorBuilder: (context, index) => SizedBox(height: listGap),
            itemBuilder: (context, index) {
              return PopularWidget(destination: tourismDestinations[index]);
            },
          ),
          SizedBox(height: sectionSpacing),
        ],
      ),
    );
  }
}
