import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/home/widgets/categories_section.dart';
import 'package:tourist_app/features/home/widgets/popular_widget.dart';
import 'package:tourist_app/features/home/widgets/recommended_widget.dart';
import 'package:tourist_app/features/home/provider/place_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_state.dart';

class HomeTab extends StatefulWidget {
  final Function(String) onCategorySelected;

  const HomeTab({super.key, required this.onCategorySelected});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PlaceProvider>().fetchRecommendedPlaces();
        context.read<PlaceProvider>().fetchPlacesSummary();
      }
    });
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
          // Chat Icon Button with Unread Badge
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final totalUnread = state.chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.messagesListRouteName);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      if (totalUnread > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.yellowColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$totalUnread',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
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
            child: Consumer<PlaceProvider>(
              builder: (context, placeProvider, child) {
                if (placeProvider.isLoadingRecommended) {
                  return const Center(child: CircularProgressIndicator());
                } else if (placeProvider.errorMessageRecommended != null) {
                  return Center(
                    child: Text(
                      placeProvider.errorMessageRecommended!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (placeProvider.recommendedPlaces.isEmpty) {
                  return Center(child: Text('no_places_found'.tr()));
                } else {
                  final list = placeProvider.recommendedPlaces;
                  return ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: listGap),
                    itemBuilder: (context, index) {
                      return RecommendedWidget(place: list[index]);
                    },
                  );
                }
              },
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
            ],
          ),

          SizedBox(height: sectionSpacing),

          // Popular places list
          Consumer<PlaceProvider>(
            builder: (context, placeProvider, child) {
              if (placeProvider.isLoadingSummary) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (placeProvider.errorMessageSummary != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      placeProvider.errorMessageSummary!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (placeProvider.summaryPlaces.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('no_places_found'.tr()),
                  ),
                );
              } else {
                final list = placeProvider.summaryPlaces;
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: listGap),
                  itemBuilder: (context, index) {
                    return PopularWidget(place: list[index]);
                  },
                );
              }
            },
          ),
          SizedBox(height: sectionSpacing),
        ],
      ),
    );
  }
}
