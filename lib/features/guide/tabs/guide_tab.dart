import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';

class GuideTab extends StatefulWidget {
  const GuideTab({super.key});

  @override
  State<GuideTab> createState() => _GuideTabState();
}

class _GuideTabState extends State<GuideTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedLang = 'all';

  final List<Map<String, dynamic>> _guidesList = [
    {
      'name': 'Ahmed Hassan',
      'speciality': 'historical_sites',
      'location': 'cairo_giza',
      'languages': ['English', 'Arabic', 'French'],
      'price': '\$80/day',
      'rating': '4.9',
      'reviews': '234',
      'image':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&fit=crop&q=80',
      'online': true,
    },
    {
      'name': 'Fatma El-Zahraa',
      'speciality': 'luxor_karnak',
      'location': 'luxor',
      'languages': ['English', 'Arabic', 'German'],
      'price': '\$70/day',
      'rating': '4.8',
      'reviews': '187',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&fit=crop&q=80',
      'online': true,
    },
    {
      'name': 'Mohamed Salah',
      'speciality': 'nile_cruises',
      'location': 'aswan_luxor',
      'languages': ['English', 'Arabic', 'Italian'],
      'price': '\$90/day',
      'rating': '4.7',
      'reviews': '156',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&fit=crop&q=80',
      'online': false,
    },
    {
      'name': 'Sarah Smith',
      'speciality': 'adventure_hiking',
      'location': 'dahab_sinai',
      'languages': ['English', 'German', 'Spanish'],
      'price': '\$85/day',
      'rating': '4.9',
      'reviews': '94',
      'image':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&fit=crop&q=80',
      'online': true,
    },
    {
      'name': 'Youssef Ali',
      'speciality': 'cultural_landmarks',
      'location': 'alexandria',
      'languages': ['English', 'Arabic', 'French'],
      'price': '\$60/day',
      'rating': '4.6',
      'reviews': '112',
      'image':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&fit=crop&q=80',
      'online': true,
    },
    {
      'name': 'Elena Petrova',
      'speciality': 'historical_tours',
      'location': 'hurghada',
      'languages': ['English', 'Russian'],
      'price': '\$95/day',
      'rating': '4.8',
      'reviews': '138',
      'image':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&fit=crop&q=80',
      'online': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.055).clamp(20.0, 32.0);

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

    // Filtering logic
    final filteredGuides = _guidesList.where((guide) {
      final matchesQuery =
          guide['name'].toString().toLowerCase().contains(_searchQuery) ||
          guide['speciality'].toString().toLowerCase().contains(_searchQuery);
      final matchesLang =
          _selectedLang == 'all' ||
          (guide['languages'] as List<String>).contains(_selectedLang);
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
            child: filteredGuides.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 10,
                    ),
                    itemCount: filteredGuides.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final guide = filteredGuides[index];
                      return _buildGuideCard(guide, isDark);
                    },
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

  Widget _buildGuideCard(Map<String, dynamic> guide, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            type: DetailType.guide,
            title: guide['name'],
            location: guide['location'],
            rating: double.tryParse(guide['rating']) ?? 4.5,
            reviewsCount:
                int.tryParse(
                  guide['reviews'].replaceAll(RegExp(r'[^0-9]'), ''),
                ) ??
                100,
            networkImage: guide['image'],
            about:
                "Learn more about ${guide['name']}, an expert in ${guide['speciality']}.",
            price: guide['price'],
            speciality: guide['speciality'],
            languages: (guide['languages'] as List<String>).join(', '),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bottomNavigationColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
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
                      child: Image.network(
                        guide['image'],
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 65,
                          height: 65,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person),
                        ),
                      ),
                    ),
                    if (guide['online'] as bool)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1ABC9C),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.bottomNavigationColor
                                  : Colors.white,
                              width: 2,
                            ),
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
                          Text(
                            guide['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                guide['rating'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${guide['reviews']})',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        guide['speciality'],
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
                            guide['location'],
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
                Row(
                  children: [
                    const Icon(Icons.language, color: Colors.grey, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      (guide['languages'] as List<String>).join(', '),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  '${guide['price']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.yellowColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Book button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF1E3A5F)
                      : AppColors.primaryColor.withOpacity(0.09),
                  foregroundColor: AppColors.yellowColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'book_guide'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
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
