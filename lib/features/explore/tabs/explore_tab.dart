import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';

class ExploreTab extends StatefulWidget {
  final int initialSegment;

  const ExploreTab({super.key, this.initialSegment = 0});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  late int _selectedSegmentIndex;

  // Transport Subcategories: Cars, Cruises, Carriage, Felucca
  int _selectedTransportSubcat = 0;

  // Hotels Subcategories: 5 Star, 4 Star, 3 Star, 2 Star
  int _selectedHotelSubcat = 0;

  // Programs filter chip: Popular, Recommended, Price, Duration
  int _selectedProgramChip = 0;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedSegmentIndex = widget.initialSegment;
  }

  @override
  void didUpdateWidget(covariant ExploreTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSegment != oldWidget.initialSegment) {
      _selectedSegmentIndex = widget.initialSegment;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Mock Data ---
  final List<Map<String, dynamic>> _carsList = [
    {
      'title': 'Luxury Sedan – Cairo Tours',
      'price': '\$45/day',
      'location': 'Cairo, Egypt',
      'rating': '4.8',
      'reviews': '312',
      'image':
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=500&q=80',
    },
    {
      'title': 'SUV Desert Explorer',
      'price': '\$75/day',
      'location': 'Siwa, Egypt',
      'rating': '4.7',
      'reviews': '189',
      'image':
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=500&q=80',
    },
  ];

  final List<Map<String, dynamic>> _cruisesList = [
    {
      'title': 'Nile Luxury Cruise',
      'price': '\$180/night',
      'location': 'Luxor → Aswan',
      'rating': '4.9',
      'reviews': '542',
      'image':
          'https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=500&q=80',
    },
    {
      'title': 'Dahabiya Nile Sailing',
      'price': '\$220/night',
      'location': 'Esna → Aswan',
      'rating': '4.8',
      'reviews': '287',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500&q=80',
    },
  ];

  final List<Map<String, dynamic>> _carriageList = [
    {
      'title': 'Historic Hantour Carriage',
      'price': '\$25/hour',
      'location': 'Luxor, Egypt',
      'rating': '4.6',
      'reviews': '156',
      'image':
          'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=500&q=80',
    },
    {
      'title': 'Old Cairo Carriage Ride',
      'price': '\$20/hour',
      'location': 'Cairo, Egypt',
      'rating': '4.5',
      'reviews': '98',
      'image':
          'https://images.unsplash.com/photo-1500627869374-13cd993b1115?w=500&q=80',
    },
  ];

  final List<Map<String, dynamic>> _feluccaList = [
    {
      'title': 'Sunset Felucca Ride',
      'price': '\$15/hour',
      'location': 'Aswan, Egypt',
      'rating': '4.9',
      'reviews': '423',
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500&q=80',
    },
    {
      'title': 'Nile Felucca Day Trip',
      'price': '\$30/half-day',
      'location': 'Cairo, Egypt',
      'rating': '4.7',
      'reviews': '231',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500&q=80',
    },
  ];

  // Grouped Hotels: 5-Star, 4-Star, 3-Star, 2-Star
  final Map<String, List<Map<String, dynamic>>> _hotelsList = {
    '5_star_hotels': [
      {
        'title': 'Four Seasons Nile Plaza',
        'location': 'Cairo, Egypt',
        'rating': '4.9',
        'reviews': '1243',
        'price': '\$350/night',
        'image':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&q=80',
      },
      {
        'title': 'Marriott Mena House',
        'location': 'Giza, Egypt',
        'rating': '4.8',
        'reviews': '987',
        'price': '\$290/night',
        'image':
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=500&q=80',
      },
    ],
    '4_star_hotels': [
      {
        'title': 'Hilton Luxor Resort',
        'location': 'Luxor, Egypt',
        'rating': '4.7',
        'reviews': '756',
        'price': '\$160/night',
        'image':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80',
      },
      {
        'title': 'Sofitel Hurghada Red Sea',
        'location': 'Hurghada, Egypt',
        'rating': '4.6',
        'reviews': '623',
        'price': '\$140/night',
        'image':
            'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500&q=80',
      },
    ],
    '3_star_hotels': [
      {
        'title': 'Ibis Cairo Citadel',
        'location': 'Cairo, Egypt',
        'rating': '4.3',
        'reviews': '412',
        'price': '\$75/night',
        'image':
            'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=500&q=80',
      },
    ],
    '2_star_hotels': [
      {
        'title': 'Dahab Paradise',
        'location': 'Dahab, Egypt',
        'rating': '4.2',
        'reviews': '198',
        'price': '\$45/night',
        'image':
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=500&q=80',
      },
    ],
  };

  final List<Map<String, dynamic>> _programsList = [
    {
      'title': 'Pyramids & Sphinx Full Day',
      'price': '\$85/pp',
      'rating': '4.9',
      'reviews': '1543',
      'duration': '8 hours',
      'image':
          'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?w=500&q=80',
    },
    {
      'title': 'Nile Felucca Sunset Cruise',
      'price': '\$35/pp',
      'rating': '4.8',
      'reviews': '789',
      'duration': '3 hours',
      'image':
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = (width * 0.055).clamp(20.0, 32.0);
        final topPadding = (width * 0.05).clamp(18.0, 28.0);

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header (Title & Search Row) ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'explore_egypt'.tr(),
                      style: AppStyles.primary24semiBold.copyWith(
                        color: isDark
                            ? AppColors.begiColor
                            : const Color(0xFF1E3A5F),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSearchAndFilterRow(isDark),
                    const SizedBox(height: 20),
                    _buildSegmentSelector(isDark),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Dynamic Content List ──
              Expanded(child: _buildSegmentContent(horizontalPadding)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterRow(bool isDark) {
    final fieldColor = isDark
        ? AppColors.bottomNavigationColor
        : const Color(0xFFFAFAFB);
    final borderColor = isDark
        ? AppColors.blueColor.withOpacity(0.18)
        : Colors.transparent;
    final iconColor = isDark ? AppColors.blueColor : AppColors.lightGrayColor;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim().toLowerCase();
              });
            },
            style: AppStyles.primary12Medium.copyWith(
              color: isDark ? AppColors.begiColor : AppColors.primaryColor,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'search_hint'.tr(),
              hintStyle: AppStyles.lightGray14Regular.copyWith(
                color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
                fontSize: 13,
              ),
              prefixIcon: Icon(Icons.search, color: iconColor),
              filled: true,
              fillColor: fieldColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox.square(
          dimension: 46,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppColors.blueColor.withOpacity(0.18)
                    : AppColors.socialBorder,
              ),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune,
                color: isDark ? AppColors.begiColor : AppColors.primaryColor,
                size: 21,
              ),
              tooltip: 'Filter'.tr(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentSelector(bool isDark) {
    final backgroundColor = isDark
        ? AppColors.bottomNavigationColor
        : const Color(0xFFFBF6EE);
    final selectedColor = isDark
        ? AppColors.darkBlueColor
        : AppColors.whiteColor;
    final selectedBorder = isDark
        ? AppColors.primaryColor.withOpacity(0.85)
        : const Color(0xFFF5EBDD);
    final labelColor = isDark ? AppColors.blueColor : AppColors.primaryColor;
    final selectedLabelColor = isDark
        ? AppColors.begiColor
        : AppColors.primaryColor;

    final segments = ['transport', 'hotels', 'programs'];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final selected = _selectedSegmentIndex == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  _selectedSegmentIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: selected ? Border.all(color: selectedBorder) : null,
                ),
                child: Text(
                  segments[index].tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.primary12Medium.copyWith(
                    color: selected ? selectedLabelColor : labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSegmentContent(double horizontalPadding) {
    if (_selectedSegmentIndex == 0) {
      return _buildTransportView(horizontalPadding);
    } else if (_selectedSegmentIndex == 1) {
      return _buildHotelsView(horizontalPadding);
    } else {
      return _buildProgramsView(horizontalPadding);
    }
  }

  // ── 1. Transport Sub-View ──
  Widget _buildTransportView(double horizontalPadding) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final subcatKeys = ['cars', 'cruises', 'carriage', 'felucca'];
    final subcatIcons = [
      Icons.directions_car_outlined,
      Icons.directions_boat_outlined,
      Icons.airport_shuttle_outlined,
      Icons.sailing_outlined,
    ];

    // Select correct mock list
    List<Map<String, dynamic>> rawList;
    if (_selectedTransportSubcat == 0) {
      rawList = _carsList;
    } else if (_selectedTransportSubcat == 1) {
      rawList = _cruisesList;
    } else if (_selectedTransportSubcat == 2) {
      rawList = _carriageList;
    } else {
      rawList = _feluccaList;
    }

    final filteredList = rawList.where((item) {
      return item['title'].toString().toLowerCase().contains(_searchQuery) ||
          item['location'].toString().toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        // Subcategory Chip Bar
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: subcatKeys.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final selected = _selectedTransportSubcat == index;
              return ChoiceChip(
                avatar: Icon(
                  subcatIcons[index],
                  size: 16,
                  color: selected
                      ? Colors.white
                      : (isDark
                            ? AppColors.blueColor
                            : AppColors.primaryColor),
                ),
                label: Text(subcatKeys[index].tr()),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _selectedTransportSubcat = index;
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
                      : (isDark ? AppColors.blueColor : AppColors.primaryColor),
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
        // Item List
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return _buildTransportCard(
                      title: item['title'],
                      price: item['price'],
                      location: item['location'],
                      rating: item['rating'],
                      reviews: item['reviews'],
                      image: item['image'],
                      buttonText: 'book_now'.tr(),
                      isDark: isDark,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── 2. Hotels Sub-View ──
  Widget _buildHotelsView(double horizontalPadding) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final subcatKeys = [
      '5_star_hotels',
      '4_star_hotels',
      '3_star_hotels',
      '2_star_hotels',
    ];
    final subcatIcons = [Icons.star, Icons.star, Icons.star, Icons.star];

    // Select correct mock list
    List<Map<String, dynamic>> rawList;
    if (_selectedHotelSubcat == 0) {
      rawList = [];
      _hotelsList.values.forEach((list) => rawList.addAll(list));
    } else {
      String currentKey = subcatKeys[_selectedHotelSubcat];
      rawList = _hotelsList[currentKey] ?? [];
    }

    final filteredList = rawList.where((item) {
      return item['title'].toString().toLowerCase().contains(_searchQuery) ||
          item['location'].toString().toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        // Subcategory ChoiceChip Bar
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: subcatKeys.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final selected = _selectedHotelSubcat == index;
              return ChoiceChip(
                avatar: Icon(
                  subcatIcons[index],
                  size: 16,
                  color: selected
                      ? Colors.white
                      : (isDark
                            ? AppColors.blueColor
                            : AppColors.primaryColor),
                ),
                label: Text(subcatKeys[index].tr()),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _selectedHotelSubcat = index;
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
                      : (isDark ? AppColors.blueColor : AppColors.primaryColor),
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
        // Item List
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return _buildHotelCard(
                      title: item['title'],
                      price: item['price'],
                      location: item['location'],
                      rating: item['rating'],
                      reviews: item['reviews'],
                      image: item['image'],
                      buttonText: 'book'.tr(),
                      isDark: isDark,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── 3. Programs Sub-View ──
  Widget _buildProgramsView(double horizontalPadding) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final programChips = ['popular', 'recommended', 'price', 'duration'];
    final programIcons = [
      Icons.trending_up,
      Icons.star_outline_rounded,
      Icons.attach_money_outlined,
      Icons.access_time_outlined,
    ];

    final filteredList = _programsList.where((item) {
      return item['title'].toString().toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        // Filter tags chip bar
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: programChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final selected = _selectedProgramChip == index;
              return ChoiceChip(
                avatar: Icon(
                  programIcons[index],
                  size: 16,
                  color: selected
                      ? Colors.white
                      : (isDark
                            ? AppColors.blueColor
                            : AppColors.primaryColor),
                ),
                label: Text(programChips[index].tr()),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _selectedProgramChip = index;
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
                      : (isDark ? AppColors.blueColor : AppColors.primaryColor),
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
        // Item List
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return _buildProgramCard(
                      title: item['title'],
                      price: item['price'],
                      duration: item['duration'],
                      rating: item['rating'],
                      reviews: item['reviews'],
                      image: item['image'],
                      buttonText: 'book_program'.tr(),
                      isDark: isDark,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Card Styles ──

  Widget _buildTransportCard({
    required String title,
    required String price,
    required String location,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            type: DetailType.transport,
            title: title,
            location: location,
            rating: double.tryParse(rating) ?? 4.5,
            reviewsCount:
                int.tryParse(reviews.replaceAll(RegExp(r'[^0-9]'), '')) ?? 100,
            networkImage: image,
            about:
                "Enjoy a comfortable ride with our top-rated transport service.",
            price: price,
            transportType: "Transport",
          ),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.yellowColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Outlined full width button
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.yellowColor,
                          width: 1.5,
                        ),
                        backgroundColor: isDark
                            ? const Color(0xFF0B1825)
                            : Colors.white,
                        foregroundColor: AppColors.yellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard({
    required String title,
    required String price,
    required String location,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            type: DetailType.hotel,
            title: title,
            location: location,
            rating: double.tryParse(rating) ?? 4.5,
            reviewsCount:
                int.tryParse(reviews.replaceAll(RegExp(r'[^0-9]'), '')) ?? 100,
            networkImage: image,
            about: "Experience luxury and comfort at $title.",
            price: price,
            hotelStars: "5 Stars",
          ),
        );
      },
      child: Container(
        height: 124,
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
        child: Row(
          children: [
            // Left image
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),
            // Right details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($reviews)',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.yellowColor,
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellowColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                            ),
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String price,
    required String duration,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            type: DetailType.place,
            title: title,
            location: "Egypt",
            rating: double.tryParse(rating) ?? 4.5,
            reviewsCount:
                int.tryParse(reviews.replaceAll(RegExp(r'[^0-9]'), '')) ?? 100,
            networkImage: image,
            about: "Discover our recommended program: $title.",
            price: price,
            duration: duration,
          ),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with duration badge
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.network(
                      image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.yellowColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Filled button
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
        'no_destinations_found'.tr(),
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
