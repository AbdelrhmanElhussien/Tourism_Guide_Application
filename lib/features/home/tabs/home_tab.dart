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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final horizontalPadding = 18.w;
    final sectionSpacing = 14.h;
    final recommendedHeight = 270.h;
    final listGap = 14.w;

    final userName = CacheHelper.getData(key: 'userName') as String? ?? 'Explorer';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 90.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              'welcome_back_with_spark'.tr(),
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              userName,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
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
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              alignment: Alignment.center,
              child: themeProvider.apptheme == ThemeMode.dark
                  ? Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 24.r,
                    )
                  : Icon(
                      Icons.nightlight_round_outlined,
                      color: Colors.white,
                      size: 24.r,
                    ),
            ),
          ),
          SizedBox(width: 4.w),
          // Chat Icon Button with Unread Badge
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final totalUnread = state.chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.messagesListRouteName);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      if (totalUnread > 0)
                        Positioned(
                          right: -4.w,
                          top: -4.h,
                          child: Container(
                            padding: EdgeInsets.all(3.r),
                            decoration: const BoxDecoration(
                              color: AppColors.yellowColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16.r,
                              minHeight: 16.r,
                            ),
                            child: Center(
                              child: Text(
                                '$totalUnread',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
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
          SizedBox(width: 16.w),
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
                style: (isDark
                    ? AppStyles.lightYellow24semiBold
                    : AppStyles.primary24semiBold).copyWith(fontSize: 22.sp),
              ),
              Text('see_all'.tr(), style: AppStyles.yellow14mediume.copyWith(fontSize: 13.sp)),
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

          SizedBox(height: sectionSpacing + 4.h),

          // Popular places header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'popular_places'.tr(),
                style: (isDark
                    ? AppStyles.lightYellow24semiBold
                    : AppStyles.primary24semiBold).copyWith(fontSize: 22.sp),
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
