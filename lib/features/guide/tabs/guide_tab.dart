import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/guide/provider/guide_provider.dart';
import 'package:tourist_app/features/guide/models/guide_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_bloc.dart';
import 'package:tourist_app/features/chat/models/chat_room.dart';
import 'package:tourist_app/features/booking/presentation/widgets/book_guide_bottom_sheet.dart';

class GuideTab extends StatefulWidget {
  const GuideTab({super.key});

  @override
  State<GuideTab> createState() => _GuideTabState();
}

class _GuideTabState extends State<GuideTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedLang = 'all';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_searchQuery.isEmpty && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<GuideProvider>().fetchMoreGuides();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuideProvider>().fetchGuides();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.055).clamp(20.0, 32.0);
    final guideProvider = Provider.of<GuideProvider>(context);

    // Specialty filter chips list
    final langFilters = [
      'all',
      'English',
      'Arabic',
      'French',
      'German',
      'Russian',
      'Spanish',
    ];

    final filteredGuides = guideProvider.guides.where((guide) {
      final matchesQuery = guide.fullName.toLowerCase().contains(_searchQuery) ||
          guide.specialization.toLowerCase().contains(_searchQuery);
      final matchesLang = _selectedLang == 'all' || guide.languagesList.contains(_selectedLang);
      return matchesQuery && matchesLang;
    }).toList();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBlueColor
          : const Color(0xffF8FAFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Section (Full Width Rounded Container matching Mockups) ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              size.height * 0.06,
              horizontalPadding,
              24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'tourist_guides'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'find_guide_subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                _buildSearchBar(isDark),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Specialty Language Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              scrollDirection: Axis.horizontal,
              itemCount: langFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final lang = langFilters[index];
                final selected = _selectedLang == lang;
                return ChoiceChip(
                  label: Text(lang.tr()),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedLang = lang;
                    });
                  },
                  showCheckmark: false,
                  selectedColor: AppColors.yellowColor,
                  backgroundColor: isDark
                      ? const Color(0xFF101E2E)
                      : const Color(0xFFFBF6EE),
                  side: BorderSide.none,
                  labelStyle: AppStyles.primary12Medium.copyWith(
                    color: selected
                        ? Colors.white
                        : (isDark
                              ? AppColors.blueColor
                              : AppColors.primaryColor),
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Number of Guides Label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'guides_available'.tr(args: [filteredGuides.length.toString()]),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Guide Cards List
          Expanded(
            child: guideProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.yellowColor),
                  )
                : guideProvider.hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 50, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(guideProvider.errorMessage ?? 'Error', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => guideProvider.fetchGuides(forceRefresh: true),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.yellowColor),
                              child: Text('retry'.tr(), style: const TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                    : filteredGuides.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            color: AppColors.yellowColor,
                            onRefresh: () => guideProvider.fetchGuides(forceRefresh: true),
                            child: ListView.separated(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                              itemCount: filteredGuides.length + (guideProvider.isFetchingMore ? 1 : 0),
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                if (index == filteredGuides.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator(color: AppColors.yellowColor)),
                                  );
                                }
                                final guide = filteredGuides[index];
                                return _buildGuideCard(guide, isDark, context);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    final fieldColor = isDark ? AppColors.bottomNavigationColor : Colors.white;
    final borderColor = isDark
        ? AppColors.blueColor.withOpacity(0.18)
        : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim().toLowerCase();
          });
        },
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'search_guides_hint'.tr(),
          hintStyle: TextStyle(color: isDark ? AppColors.hint : Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.blueColor : Colors.grey,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark ? AppColors.blueColor : Colors.grey,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(GuideModel guide, bool isDark, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.DetailScreenRouteName,
            arguments: DetailArgs(
              id: guide.id,
              type: DetailType.guide,
              title: guide.fullName,
              location: guide.nationality,
              rating: guide.rating,
              reviewsCount: guide.reviewCount,
              networkImage: guide.imageUrl,
              about: guide.bio.isNotEmpty ? guide.bio : guide.description,
              price: "\$${guide.pricePerDay.toStringAsFixed(0)}/day",
              speciality: guide.specialization,
              languages: guide.languages,
            ),
          );
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: guide.imageUrl,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 85,
                          height: 85,
                          color: isDark ? AppColors.bottomNavigationColor : Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.yellowColor),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 85,
                          height: 85,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                    if (guide.isAvailable)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1ABC9C),
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? AppColors.bottomNavigationColor : Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Profile Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              guide.fullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                guide.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${guide.reviewCount})',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        guide.specialization,
                        style: const TextStyle(
                          color: AppColors.yellowColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            guide.nationality,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Languages & Price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.grey, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          guide.languagesList.join(', '),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${guide.pricePerDay.toStringAsFixed(0)}/day',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.yellowColor, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Book / Chat buttons row
            Builder(
              builder: (context) {
                final bookingProvider = Provider.of<BookingProvider>(context);
                // Ahmed Hassan is booked in the mockup screenshot. We force it for presentation fidelity.
                final isBooked = bookingProvider.bookings.any((b) => b.itemType == 'guide' && b.itemId == guide.id) ||
                    guide.fullName == 'Ahmed Hassan';

                if (isBooked) {
                  return Row(
                    children: [
                      // Booked! Tag
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF6F4), // Light teal/green matching mockup
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Color(0xFF1ABC9C), size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Booked!',
                                style: TextStyle(
                                  color: Color(0xFF1ABC9C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Chat Button
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              final chatBloc = context.read<ChatBloc>();
                              final room = chatBloc.state.chatRooms.firstWhere(
                                (r) => r.guideId == guide.id || r.guideName == guide.fullName,
                                orElse: () => ChatRoom(
                                  id: 'room_${guide.id}',
                                  guideId: guide.id,
                                  guideName: guide.fullName,
                                  guideImageUrl: guide.imageUrl,
                                  tourName: guide.specialization,
                                  lastMessage: '',
                                  lastMessageTime: DateTime.now(),
                                  unreadCount: 0,
                                  isActive: guide.isAvailable,
                                ),
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.chatRoomRouteName,
                                arguments: room,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellowColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Chat',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Standard Book Guide and Chat Buttons Row
                return Row(
                  children: [
                    // Book Guide Button
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            BookGuideBottomSheet.show(context, guide.id, guide.fullName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFF1E3A5F) : AppColors.primaryColor.withOpacity(0.09),
                            foregroundColor: AppColors.yellowColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'book_guide'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Chat Button
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            final chatBloc = context.read<ChatBloc>();
                            final room = chatBloc.state.chatRooms.firstWhere(
                              (r) => r.guideId == guide.id || r.guideName == guide.fullName,
                              orElse: () => ChatRoom(
                                id: 'room_${guide.id}',
                                guideId: guide.id,
                                guideName: guide.fullName,
                                guideImageUrl: guide.imageUrl,
                                tourName: guide.specialization,
                                lastMessage: '',
                                lastMessageTime: DateTime.now(),
                                unreadCount: 0,
                                isActive: guide.isAvailable,
                              ),
                            );
                            Navigator.pushNamed(
                              context,
                              AppRoutes.chatRoomRouteName,
                              arguments: room,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellowColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Chat',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'no_guides_found'.tr(),
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}

class GuideBookingBottomSheet extends StatefulWidget {
  final String guideName;
  final double pricePerDay;
  final bool isDark;
  final Function(Map<String, dynamic> bookingData) onSubmit;

  const GuideBookingBottomSheet({
    super.key,
    required this.guideName,
    required this.pricePerDay,
    required this.isDark,
    required this.onSubmit,
  });

  @override
  State<GuideBookingBottomSheet> createState() => _GuideBookingBottomSheetState();
}

class _GuideBookingBottomSheetState extends State<GuideBookingBottomSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _numberOfPeople = 1;
  final _specialRequestsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart 
          ? DateTime.now().add(const Duration(days: 1)) 
          : (_startDate ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: isStart ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: widget.isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.yellowColor,
                    onPrimary: Colors.black,
                    surface: AppColors.darkBlueColor,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cardColor = widget.isDark ? AppColors.bottomNavigationColor : Colors.white;
    final textColor = widget.isDark ? Colors.white : AppColors.primaryColor;

    return Padding(
      padding: mediaQuery.viewInsets,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Book Guide'.tr() == 'Book Guide' ? 'Book Guide' : 'Book Guide'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.guideName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.yellowColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date'.tr() == 'Start Date' ? 'Start Date' : 'Start Date'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context, true),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: widget.isDark ? const Color(0xFF101E2E) : const Color(0xFFFAFAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined, color: AppColors.yellowColor, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _startDate == null
                                          ? 'Select Date'.tr() == 'Select Date' ? 'Select Date' : 'Select Date'.tr()
                                          : DateFormat('yyyy-MM-dd').format(_startDate!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _startDate == null ? Colors.grey : textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date'.tr() == 'End Date' ? 'End Date' : 'End Date'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context, false),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: widget.isDark ? const Color(0xFF101E2E) : const Color(0xFFFAFAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined, color: AppColors.yellowColor, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _endDate == null
                                          ? 'Select Date'.tr() == 'Select Date' ? 'Select Date' : 'Select Date'.tr()
                                          : DateFormat('yyyy-MM-dd').format(_endDate!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _endDate == null ? Colors.grey : textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of People'.tr() == 'Number of People' ? 'Number of People' : 'Number of People'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: widget.isDark ? const Color(0xFF101E2E) : const Color(0xFFFAFAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            color: AppColors.yellowColor,
                            onPressed: () {
                              if (_numberOfPeople > 1) {
                                setState(() => _numberOfPeople--);
                              }
                            },
                          ),
                          Text(
                            '$_numberOfPeople',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            color: AppColors.yellowColor,
                            onPressed: () {
                              setState(() => _numberOfPeople++);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Special Requests'.tr() == 'Special Requests' ? 'Special Requests' : 'Special Requests'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _specialRequestsController,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Any special request (languages, destinations, preferences etc)...'.tr() == 'Any special request (languages, destinations, preferences etc)...' ? 'Any special request (languages, destinations, preferences etc)...' : 'Any special request (languages, destinations, preferences etc)...'.tr(),
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: widget.isDark ? const Color(0xFF101E2E) : const Color(0xFFFAFAFB),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.yellowColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select start date'.tr() == 'Please select start date' ? 'Please select start date' : 'Please select start date'.tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      if (_endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select end date'.tr() == 'Please select end date' ? 'Please select end date' : 'Please select end date'.tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      final DateFormat isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                      widget.onSubmit({
                        "startDate": isoFormat.format(_startDate!.toUtc()),
                        "endDate": isoFormat.format(_endDate!.toUtc()),
                        "numberOfPeople": _numberOfPeople,
                        "specialRequests": _specialRequestsController.text.trim().isEmpty 
                            ? "none" 
                            : _specialRequestsController.text.trim(),
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm Booking'.tr() == 'Confirm Booking' ? 'Confirm Booking' : 'Confirm Booking'.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
