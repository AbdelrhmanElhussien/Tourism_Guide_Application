import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Section ──────────────────────────────────────────
            _buildHeader(context, isLight, size),

            // ── Menu Options List ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  // --- Group 1 ---
                  _buildMenuCard(
                    isLight: isLight,
                    cardColor: Theme.of(context).cardColor,
                    children: [
                      _buildMenuItem(
                        icon: Icons.calendar_month_outlined,
                        iconColor: AppColors.yellowColor,
                        iconBgColor: const Color(0xFFFEF9EC),
                        title: 'my_trips'.tr(),
                        isLight: isLight,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.myTripsRouteName);
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite_border_outlined,
                        iconColor: const Color(0xFF1ABC9C),
                        iconBgColor: const Color(0xFFEBF7F5),
                        title: 'saved_places'.tr(),
                        isLight: isLight,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.savedPlacesRouteName);
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        iconColor: isLight ? AppColors.primaryColor : AppColors.blueColor,
                        iconBgColor: const Color(0xFFEEF4F8),
                        title: 'visited_places'.tr(),
                        isLight: isLight,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.business_center_outlined,
                        iconColor: AppColors.yellowColor,
                        iconBgColor: const Color(0xFFFEF9EC),
                        title: 'service_provider'.tr(),
                        isLight: isLight,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.serviceProviderRouteName,
                          );
                        },
                      ),
                    ],
                  ),

                  // --- Group 2 ---
                  _buildMenuCard(
                    isLight: isLight,
                    cardColor: Theme.of(context).cardColor,
                    children: [
                      _buildMenuItem(
                        icon: isLight ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
                        iconColor: isLight ? AppColors.primaryColor : AppColors.yellowColor,
                        iconBgColor: isLight ? const Color(0xFFF1F3F6) : const Color(0xFFFEF9EC),
                        title: isLight ? 'night_mode'.tr() : 'light_mode'.tr(),
                        isLight: isLight,
                        trailing: Switch(
                          value: !isLight,
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.yellowColor,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (value) {
                            themeProvider.changeTheme(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.language,
                        iconColor: isLight ? AppColors.primaryColor : AppColors.blueColor,
                        iconBgColor: const Color(0xFFF1F3F6),
                        title: 'language'.tr(),
                        isLight: isLight,
                        trailing: Text(
                          context.locale.languageCode.toUpperCase(),
                          style: TextStyle(
                            color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          _showLanguageDialog(context, !isLight);
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        iconColor: isLight ? AppColors.primaryColor : AppColors.blueColor,
                        iconBgColor: const Color(0xFFF1F3F6),
                        title: 'settings'.tr(),
                        isLight: isLight,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        iconColor: isLight ? AppColors.primaryColor : AppColors.blueColor,
                        iconBgColor: const Color(0xFFF1F3F6),
                        title: 'help_support'.tr(),
                        isLight: isLight,
                        onTap: () {},
                      ),
                    ],
                  ),

                  // --- Group 3 (Sign Out) ---
                  _buildMenuCard(
                    isLight: isLight,
                    cardColor: Theme.of(context).cardColor,
                    children: [
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        iconColor: Colors.red,
                        iconBgColor: const Color(0xFFFCEBEB),
                        title: 'sign_out'.tr(),
                        isLight: isLight,
                        trailing: const SizedBox.shrink(),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginRouteName,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLight, Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, size.height * 0.07, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'JD',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('12', 'visited_count'.tr()),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem('5', 'trips_count'.tr()),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem('28', 'saved_count'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required List<Widget> children,
    required Color cardColor,
    required bool isLight,
  }) {
    List<Widget> childrenWithDividers = [];
    for (int i = 0; i < children.length; i++) {
      childrenWithDividers.add(children[i]);
      if (i < children.length - 1) {
        childrenWithDividers.add(
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 68,
            endIndent: 16,
            color: isLight ? const Color(0xFFEEEEEE) : Colors.white12,
          ),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: childrenWithDividers,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required bool isLight,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    Color activeTitleColor = isLight ? AppColors.primaryColor : AppColors.whiteColor;
    if (iconColor == Colors.red) {
      activeTitleColor = Colors.red;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isLight ? iconBgColor : iconColor.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isLight ? iconColor : iconColor.withOpacity(0.85),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: activeTitleColor,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
          ),
      onTap: onTap,
    );
  }

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
}
