import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
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
  void _showLanguageDialog(BuildContext context, bool isDark) {
    final Map<String, String> languages = {
      'en': 'English',
      'ar': 'العربية',
      'de': 'Deutsch',
      'fr': 'Français',
      'it': 'Italiano',
      'es': 'Español',
      'ru': 'Русский',
      'zh': '中文',
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.bottomNavigationColor : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'select_language'.tr(),
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: languages.entries.map((entry) {
                final isSelected = context.locale.languageCode == entry.key;
                return ListTile(
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.yellowColor)
                      : null,
                  onTap: () {
                    context.setLocale(Locale(entry.key));
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

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

    final userName = CacheHelper.getData(key: 'userName') as String? ?? 'Explorer';

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
              'welcome_back_with_spark'.tr(),
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userName,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          // Theme Toggle Moon Outline
          GestureDetector(
            onTap: () {
              themeProvider.apptheme == ThemeMode.dark
                  ? themeProvider.changeTheme(ThemeMode.light)
                  : themeProvider.changeTheme(ThemeMode.dark);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: themeProvider.apptheme == ThemeMode.dark
                  ? const Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 24,
                    )
                  : const Icon(
                      Icons.nightlight_round_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),
          const SizedBox(width: 4),
          // Language EN/AR Button
          GestureDetector(
            onTap: () {
              _showLanguageDialog(context, isDark);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.locale.languageCode.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
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
