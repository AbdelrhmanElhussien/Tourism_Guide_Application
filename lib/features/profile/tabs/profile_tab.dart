import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/profile/cubit/profile_cubit.dart';
import 'package:tourist_app/features/profile/cubit/profile_states.dart';
import 'package:tourist_app/features/home/provider/place_provider.dart';
import 'package:tourist_app/features/guide/provider/guide_provider.dart';
import 'package:tourist_app/features/explore/provider/hotel_provider.dart';
import 'package:tourist_app/features/explore/provider/transport_provider.dart';
import 'package:tourist_app/features/explore/provider/program_provider.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..fetchProfileData(),
      child: Scaffold(
        backgroundColor: isLight
            ? const Color(0xffF8FAFC)
            : AppColors.darkBlueColor,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'something_went_wrong'.tr() == 'something_went_wrong'
                          ? 'Something went wrong'
                          : 'something_went_wrong'.tr(),
                      style: TextStyle(
                        color: isLight ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().fetchProfileData();
                      },
                      child: Text(
                        'retry'.tr() == 'retry' ? 'Retry' : 'retry'.tr(),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileSuccess) {
              final String role =
                  (CacheHelper.getData(key: 'role') as String? ?? '')
                      .trim()
                      .toLowerCase();
              final bool isAdmin = role.contains('admin');
              final bool showServiceProvider =
                  role == 'serviceprovider' ||
                  role == 'service provider' ||
                  role == 'provider' ||
                  isAdmin;

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ProfileCubit>().fetchProfileData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Header Section ──────────────────────────────────────────
                      _buildHeader(
                        context: context,
                        isLight: isLight,
                        size: size,
                        userName: state.userName,
                        email: state.email,
                        visitedCount: state.visitedPlaces.length,
                        savedCount: state.savedPlaces.length,
                        completedTripsCount: state.completedTripsCount,
                      ),

                      // ── Menu Options List ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
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
                                  title: 'my_bookings'.tr(),
                                  isLight: isLight,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.myBookingsRouteName,
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.favorite_border_outlined,
                                  iconColor: const Color(0xFF1ABC9C),
                                  iconBgColor: const Color(0xFFEBF7F5),
                                  title: 'saved'.tr(),
                                  isLight: isLight,
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      AppRoutes.savedPlacesRouteName,
                                    );
                                    if (context.mounted) {
                                      context
                                          .read<ProfileCubit>()
                                          .fetchProfileData();
                                    }
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.location_on_outlined,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.blueColor,
                                  iconBgColor: const Color(0xFFEEF4F8),
                                  title: 'visited_places'.tr(),
                                  isLight: isLight,
                                  onTap: () async {
                                    await Navigator.pushNamed(context, AppRoutes.visitedPlacesRouteName);
                                    if (context.mounted) {
                                      context.read<ProfileCubit>().fetchProfileData();
                                    }
                                  },
                                ),
                                if (isAdmin)
                                  _buildMenuItem(
                                    icon: Icons.admin_panel_settings_outlined,
                                    iconColor: const Color(0xFF1ABC9C),
                                    iconBgColor: const Color(0xFFEBF7F5),
                                    title: 'Admin Panel',
                                    isLight: isLight,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes
                                            .adminProviderRequestsRouteName,
                                      );
                                    },
                                  ),
                                if (showServiceProvider)
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
                                if (!showServiceProvider)
                                  _buildMenuItem(
                                    icon: Icons.business_center_outlined,
                                    iconColor: AppColors.yellowColor,
                                    iconBgColor: const Color(0xFFFEF9EC),
                                    title:
                                        'become_provider'.tr() ==
                                            'become_provider'
                                        ? 'Become a Provider'
                                        : 'become_provider'.tr(),
                                    isLight: isLight,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.becomeProviderRouteName,
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
                                  icon: isLight
                                      ? Icons.nightlight_outlined
                                      : Icons.wb_sunny_outlined,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.yellowColor,
                                  iconBgColor: isLight
                                      ? const Color(0xFFF1F3F6)
                                      : const Color(0xFFFEF9EC),
                                  title: isLight
                                      ? 'night_mode'.tr()
                                      : 'light_mode'.tr(),
                                  isLight: isLight,
                                  trailing: Switch(
                                    value: !isLight,
                                    activeColor: Colors.white,
                                    activeTrackColor: AppColors.yellowColor,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey[300],
                                    onChanged: (value) {
                                      themeProvider.changeTheme(
                                        value
                                            ? ThemeMode.dark
                                            : ThemeMode.light,
                                      );
                                    },
                                  ),
                                ),
                                _buildMenuItem(
                                  icon: Icons.language,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.blueColor,
                                  iconBgColor: const Color(0xFFF1F3F6),
                                  title: 'language'.tr(),
                                  isLight: isLight,
                                  trailing: Text(
                                    context.locale.languageCode.toUpperCase(),
                                    style: TextStyle(
                                      color: isLight
                                          ? AppColors.primaryColor
                                          : AppColors.blueColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    _showLanguageDialog(context, !isLight);
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.settings_outlined,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.blueColor,
                                  iconBgColor: const Color(0xFFF1F3F6),
                                  title: 'settings'.tr(),
                                  isLight: isLight,
                                  onTap: () {},
                                ),
                                _buildMenuItem(
                                  icon: Icons.lock_outline,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.blueColor,
                                  iconBgColor: const Color(0xFFF1F3F6),
                                  title: 'Change Password',
                                  isLight: isLight,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.changePasswordRouteName,
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.help_outline,
                                  iconColor: isLight
                                      ? AppColors.primaryColor
                                      : AppColors.blueColor,
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
                                    DialogeUtils.showMassage(
                                      context: context,
                                      title: 'sign_out'.tr(),
                                      masseage: 'are_you_sure_to_logout'.tr(),
                                      posActionName: 'yes_action'.tr(),
                                      posFun: () async {
                                        // 1. Clear caches of all providers
                                        try {
                                          Provider.of<PlaceProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}
                                        try {
                                          Provider.of<GuideProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}
                                        try {
                                          Provider.of<HotelProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}
                                        try {
                                          Provider.of<TransportProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}
                                        try {
                                          Provider.of<ProgramProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}
                                        try {
                                          Provider.of<BookingProvider>(
                                            context,
                                            listen: false,
                                          ).clearCache();
                                        } catch (_) {}

                                        // 2. Clear credentials from CacheHelper
                                        await CacheHelper.clearData();

                                        if (context.mounted) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.loginRouteName,
                                          );
                                        }
                                      },
                                      negActionName: 'cancel_action'.tr(),
                                      negFun: () {},
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _buildHeader({
    required BuildContext context,
    required bool isLight,
    required Size size,
    required String userName,
    required String email,
    required int visitedCount,
    required int savedCount,
    required int completedTripsCount,
  }) {
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
                  _getInitials(userName),
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
                      userName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
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
                _buildStatItem(visitedCount.toString(), 'visited_count'.tr()),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  completedTripsCount.toString(),
                  'trips_count'.tr(),
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(savedCount.toString(), 'saved_count'.tr()),
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
      child: Column(children: childrenWithDividers),
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
    Color activeTitleColor = isLight
        ? AppColors.primaryColor
        : AppColors.whiteColor;
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
      trailing:
          trailing ??
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
          backgroundColor: isDark
              ? AppColors.bottomNavigationColor
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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
