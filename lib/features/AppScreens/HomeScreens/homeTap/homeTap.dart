import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/CulturalFestivalBanner.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/categoriesSection.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/pobularWidget.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/recommendedWidget.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/searcheWidget.dart';

class hometap extends StatefulWidget {
  const hometap({super.key});

  @override
  State<hometap> createState() => _hometapState();
}

class _hometapState extends State<hometap> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.005),
            Text(
              'welcome,'.tr(),
              style: AppStyles.mediume24White.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text('Explorer'.tr(), style: AppStyles.mediume24White),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset(AppAssets.arrowIcon),
          ),
          SizedBox(width: size.width * 0.05),
        ],
      ),
      body: Column(
        children: [
          // ── Search header (fixed) ──────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.03,
              horizontal: size.width * 0.04,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: const Searchewidget(),
          ),
          Expanded(
            child: ListView(

              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              children: [
                // Categories
                SizedBox(height: size.height * 0.015),

                const CategoriesSection(),

                // Recommended header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('recommended'.tr(), style: AppStyles.primary24semiBold),
                    Text('see_all'.tr(), style: AppStyles.yellow14mediume),
                  ],
                ),
                SizedBox(height: size.height * 0.015),

                SizedBox(
                  height: size.height * 0.28,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: size.width * 0.05),
                    itemBuilder: (_, __) => const RecommendedWidget(),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Popular places header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('popular_places'.tr(),
                        style: AppStyles.primary24semiBold),
                    Text('see_all'.tr(), style: AppStyles.yellow14mediume),
                  ],
                ),

                SizedBox(height: size.height * 0.015),
                // TODO: add popular places list here
                SizedBox(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(), // Disables scrolling
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 8,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: size.width * 0.05),
                    itemBuilder: (_, __) => const pobularWidget()
                  ),
                ),
                SizedBox(height: size.height * 0.015),

                CulturalFestivalBanner(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}