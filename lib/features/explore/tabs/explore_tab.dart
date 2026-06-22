import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/explore/provider/hotel_provider.dart';
import 'package:tourist_app/features/explore/provider/transport_provider.dart';
import 'package:tourist_app/features/explore/provider/program_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
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

  final ScrollController _hotelScrollController = ScrollController();
  final ScrollController _transportScrollController = ScrollController();
  final ScrollController _programScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedSegmentIndex = widget.initialSegment;

    _hotelScrollController.addListener(() {
      if (_searchQuery.isEmpty &&
          _hotelScrollController.position.pixels >=
              _hotelScrollController.position.maxScrollExtent - 200) {
        context.read<HotelProvider>().fetchMoreHotels();
      }
    });

    _transportScrollController.addListener(() {
      if (_searchQuery.isEmpty &&
          _transportScrollController.position.pixels >=
              _transportScrollController.position.maxScrollExtent - 200) {
        context.read<TransportProvider>().fetchMoreTransports();
      }
    });

    _programScrollController.addListener(() {
      if (_searchQuery.isEmpty &&
          _programScrollController.position.pixels >=
              _programScrollController.position.maxScrollExtent - 200) {
        context.read<ProgramProvider>().fetchMorePrograms();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().fetchHotels();
      context.read<TransportProvider>().fetchTransports();
      context.read<ProgramProvider>().fetchPrograms();
    });
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
    _hotelScrollController.dispose();
    _transportScrollController.dispose();
    _programScrollController.dispose();
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
    final subcatKeys = ['cars', 'cruises', 'carriage', 'felucca', 'others'];
    final subcatIcons = [
      Icons.directions_car_outlined,
      Icons.directions_boat_outlined,
      Icons.airport_shuttle_outlined,
      Icons.sailing_outlined,
      Icons.more_horiz_outlined,
    ];

    return Consumer<TransportProvider>(
      builder: (context, transportProvider, child) {
        if (transportProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellowColor),
          );
        }

        if (transportProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  transportProvider.errorMessage ?? 'Error',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      transportProvider.fetchTransports(forceRefresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowColor,
                  ),
                  child: Text(
                    'retry'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final filteredList = transportProvider.transports.where((item) {
          bool matchesType = false;
          final typeLower = item.type.toLowerCase().trim();

          if (_selectedTransportSubcat == 0) {
            matchesType = typeLower == 'car' || typeLower == 'cars';
          } else if (_selectedTransportSubcat == 1) {
            matchesType =
                typeLower == 'train' ||
                typeLower == 'ferry' ||
                typeLower == 'cruise' ||
                typeLower == 'cruises';
          } else if (_selectedTransportSubcat == 2) {
            matchesType = typeLower == 'carriage';
          } else if (_selectedTransportSubcat == 3) {
            matchesType = typeLower == 'boat' || typeLower == 'felucca';
          } else if (_selectedTransportSubcat == 4) {
            final knownTypes = [
              'car',
              'cars',
              'train',
              'ferry',
              'cruise',
              'cruises',
              'carriage',
              'boat',
              'felucca',
            ];
            matchesType = !knownTypes.contains(typeLower);
          }

          bool matchesQuery =
              item.name.toLowerCase().contains(_searchQuery) ||
              item.departureLocation.toLowerCase().contains(_searchQuery) ||
              item.arrivalLocation.toLowerCase().contains(_searchQuery);
          return matchesType && matchesQuery;
        }).toList();

        return Column(
          children: [
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
                    label: Row(
                      children: [
                        Icon(
                          subcatIcons[index],
                          size: 16,
                          color: selected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.blueColor
                                    : AppColors.primaryColor),
                        ),
                        const SizedBox(width: 6),
                        Text(subcatKeys[index].tr()),
                      ],
                    ),
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
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: AppColors.yellowColor,
                      onRefresh: () =>
                          transportProvider.fetchTransports(forceRefresh: true),
                      child: ListView.separated(
                        controller: _transportScrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 10,
                        ),
                        itemCount:
                            filteredList.length +
                            (transportProvider.isFetchingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == filteredList.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.yellowColor,
                                ),
                              ),
                            );
                          }
                          final item = filteredList[index];
                          return _buildTransportCard(
                            id: item.id,
                            title: item.name,
                            price: '\$${item.price.toStringAsFixed(0)}',
                            location:
                                '${item.departureLocation} → ${item.arrivalLocation}',
                            rating: item.rating.toStringAsFixed(1),
                            reviews: item.reviewCount.toString(),
                            image: item.imageUrl,
                            buttonText: 'book_now'.tr(),
                            isDark: isDark,
                            onBook: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (bottomSheetContext) => TransportBookingBottomSheet(
                                  transportName: item.name,
                                  price: item.price,
                                  isDark: isDark,
                                  onSubmit: (bookingData) async {
                                    try {
                                      DialogeUtils.showLoading(
                                        context: context,
                                        text: "loading_msg".tr(),
                                      );
                                      await context.read<BookingProvider>().bookItem(
                                        'transport',
                                        item.id,
                                        data: bookingData,
                                      );
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: 'Booking Successful',
                                        title: 'Success',
                                        posActionName: 'OK',
                                      );
                                    } catch (e) {
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: e.toString(),
                                        title: 'Error',
                                        posActionName: 'OK',
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
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
      'others',
    ];
    final subcatIcons = [
      Icons.star,
      Icons.star,
      Icons.star,
      Icons.star,
      Icons.star_border_rounded,
    ];

    return Consumer<HotelProvider>(
      builder: (context, hotelProvider, child) {
        if (hotelProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellowColor),
          );
        }

        if (hotelProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  hotelProvider.errorMessage ?? 'Error',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      hotelProvider.fetchHotels(forceRefresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowColor,
                  ),
                  child: Text(
                    'retry'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final filteredList = hotelProvider.hotels.where((item) {
          bool matchesStars = false;
          if (_selectedHotelSubcat == 4) {
            matchesStars =
                item.starRating != 5 &&
                item.starRating != 4 &&
                item.starRating != 3 &&
                item.starRating != 2;
          } else {
            int targetStars = 5 - _selectedHotelSubcat;
            matchesStars = item.starRating == targetStars;
          }

          bool matchesQuery =
              item.name.toLowerCase().contains(_searchQuery) ||
              item.location.toLowerCase().contains(_searchQuery);
          return matchesStars && matchesQuery;
        }).toList();

        return Column(
          children: [
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
                    label: Row(
                      children: [
                        Icon(
                          subcatIcons[index],
                          size: 16,
                          color: selected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.blueColor
                                    : AppColors.primaryColor),
                        ),
                        const SizedBox(width: 6),
                        Text(subcatKeys[index].tr()),
                      ],
                    ),
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
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: AppColors.yellowColor,
                      onRefresh: () =>
                          hotelProvider.fetchHotels(forceRefresh: true),
                      child: ListView.separated(
                        controller: _hotelScrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 10,
                        ),
                        itemCount:
                            filteredList.length +
                            (hotelProvider.isFetchingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == filteredList.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.yellowColor,
                                ),
                              ),
                            );
                          }
                          final item = filteredList[index];
                          return _buildHotelCard(
                            id: item.id,
                            title: item.name,
                            price:
                                '\$${item.pricePerNight.toStringAsFixed(0)}/night',
                            location: item.location,
                            rating: item.rating.toStringAsFixed(1),
                            reviews: item.reviewCount.toString(),
                            image: item.imageUrl,
                            buttonText: 'book'.tr(),
                            isDark: isDark,
                            onBook: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (bottomSheetContext) => HotelBookingBottomSheet(
                                  hotelName: item.name,
                                  pricePerNight: item.pricePerNight,
                                  isDark: isDark,
                                  onSubmit: (bookingData) async {
                                    try {
                                      DialogeUtils.showLoading(
                                        context: context,
                                        text: "loading_msg".tr(),
                                      );
                                      await context.read<BookingProvider>().bookItem(
                                        'hotel',
                                        item.id,
                                        data: bookingData,
                                      );
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: 'Booking Successful',
                                        title: 'Success',
                                        posActionName: 'OK',
                                      );
                                    } catch (e) {
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: e.toString(),
                                        title: 'Error',
                                        posActionName: 'OK',
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
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

    return Consumer<ProgramProvider>(
      builder: (context, programProvider, child) {
        if (programProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellowColor),
          );
        }

        if (programProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  programProvider.errorMessage ?? 'Error',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      programProvider.fetchPrograms(forceRefresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowColor,
                  ),
                  child: Text(
                    'retry'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final filteredList = programProvider.programs.where((item) {
          return item.name.toLowerCase().contains(_searchQuery) ||
              item.location.toLowerCase().contains(_searchQuery) ||
              item.city.toLowerCase().contains(_searchQuery);
        }).toList();

        // Implement sorting based on selected chip if needed
        if (_selectedProgramChip == 2) {
          // Sort by price
          filteredList.sort((a, b) => a.price.compareTo(b.price));
        } else if (_selectedProgramChip == 3) {
          // Sort by duration
          filteredList.sort((a, b) => a.duration.compareTo(b.duration));
        } else if (_selectedProgramChip == 1) {
          // Sort by rating (recommended)
          filteredList.sort((a, b) => b.rating.compareTo(a.rating));
        } else {
          // Popular - sort by reviews
          filteredList.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        }

        return Column(
          children: [
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
                    label: Row(
                      children: [
                        Icon(
                          programIcons[index],
                          size: 16,
                          color: selected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.blueColor
                                    : AppColors.primaryColor),
                        ),
                        const SizedBox(width: 6),
                        Text(programChips[index].tr()),
                      ],
                    ),
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
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: AppColors.yellowColor,
                      onRefresh: () =>
                          programProvider.fetchPrograms(forceRefresh: true),
                      child: ListView.separated(
                        controller: _programScrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 10,
                        ),
                        itemCount:
                            filteredList.length +
                            (programProvider.isFetchingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == filteredList.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.yellowColor,
                                ),
                              ),
                            );
                          }
                          final item = filteredList[index];
                          return _buildProgramCard(
                            id: item.id,
                            title: item.name,
                            price: '\$${item.price.toStringAsFixed(0)}',
                            duration: '${item.duration} hrs',
                            rating: item.rating.toStringAsFixed(1),
                            reviews: item.reviewCount.toString(),
                            image: item.imageUrl,
                            buttonText: 'book_program'.tr(),
                            isDark: isDark,
                            onBook: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (bottomSheetContext) => ProgramBookingBottomSheet(
                                  programName: item.name,
                                  price: item.price,
                                  isDark: isDark,
                                  onSubmit: (bookingData) async {
                                    try {
                                      DialogeUtils.showLoading(
                                        context: context,
                                        text: "loading_msg".tr(),
                                      );
                                      await context.read<BookingProvider>().bookItem(
                                        'program',
                                        item.id,
                                        data: bookingData,
                                      );
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: 'Booking Successful',
                                        title: 'Success',
                                        posActionName: 'OK',
                                      );
                                    } catch (e) {
                                      DialogeUtils.hideLoading(context: context);
                                      DialogeUtils.showMassage(
                                        context: context,
                                        masseage: e.toString(),
                                        title: 'Error',
                                        posActionName: 'OK',
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  // ── Card Styles ──

  Widget _buildTransportCard({
    required String id,
    required String title,
    required String price,
    required String location,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
    VoidCallback? onBook,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: id,
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
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark
                        ? AppColors.bottomNavigationColor
                        : Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.yellowColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error_outline, color: Colors.red),
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
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                      onPressed: onBook ?? () {},
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
    required String id,
    required String title,
    required String price,
    required String location,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
    VoidCallback? onBook,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: id,
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
        ),
        child: Row(
          children: [
            // Image
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark
                          ? AppColors.bottomNavigationColor
                          : Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.yellowColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error_outline, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            // Details
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
                            onPressed: onBook ?? () {},
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
    required String id,
    required String title,
    required String price,
    required String duration,
    required String rating,
    required String reviews,
    required String image,
    required String buttonText,
    required bool isDark,
    VoidCallback? onBook,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: id,
            type: DetailType.program,
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
                    CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark
                            ? AppColors.bottomNavigationColor
                            : Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.yellowColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
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
                      onPressed: onBook ?? () {},
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

class HotelBookingBottomSheet extends StatefulWidget {
  final String hotelName;
  final double pricePerNight;
  final bool isDark;
  final Function(Map<String, dynamic> bookingData) onSubmit;

  const HotelBookingBottomSheet({
    super.key,
    required this.hotelName,
    required this.pricePerNight,
    required this.isDark,
    required this.onSubmit,
  });

  @override
  State<HotelBookingBottomSheet> createState() => _HotelBookingBottomSheetState();
}

class _HotelBookingBottomSheetState extends State<HotelBookingBottomSheet> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfRooms = 1;
  int _numberOfGuests = 1;
  final _specialRequestsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn 
          ? DateTime.now().add(const Duration(days: 1)) 
          : (_checkInDate ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
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
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = picked;
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
                  'Book Hotel'.tr() == 'Book Hotel' ? 'Book Hotel' : 'Book Hotel'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.hotelName,
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
                            'Check-in Date'.tr() == 'Check-in Date' ? 'Check-in Date' : 'Check-in Date'.tr(),
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
                                      _checkInDate == null
                                          ? 'Select Date'.tr() == 'Select Date' ? 'Select Date' : 'Select Date'.tr()
                                          : DateFormat('yyyy-MM-dd').format(_checkInDate!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _checkInDate == null ? Colors.grey : textColor,
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
                            'Check-out Date'.tr() == 'Check-out Date' ? 'Check-out Date' : 'Check-out Date'.tr(),
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
                                      _checkOutDate == null
                                          ? 'Select Date'.tr() == 'Select Date' ? 'Select Date' : 'Select Date'.tr()
                                          : DateFormat('yyyy-MM-dd').format(_checkOutDate!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _checkOutDate == null ? Colors.grey : textColor,
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rooms'.tr() == 'Rooms' ? 'Rooms' : 'Rooms'.tr(),
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
                                    if (_numberOfRooms > 1) {
                                      setState(() => _numberOfRooms--);
                                    }
                                  },
                                ),
                                Text(
                                  '$_numberOfRooms',
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
                                    setState(() => _numberOfRooms++);
                                  },
                                ),
                              ],
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
                            'Guests'.tr() == 'Guests' ? 'Guests' : 'Guests'.tr(),
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
                                    if (_numberOfGuests > 1) {
                                      setState(() => _numberOfGuests--);
                                    }
                                  },
                                ),
                                Text(
                                  '$_numberOfGuests',
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
                                    setState(() => _numberOfGuests++);
                                  },
                                ),
                              ],
                            ),
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
                    hintText: 'Any special request (extra bed, floor etc)...'.tr() == 'Any special request (extra bed, floor etc)...' ? 'Any special request (extra bed, floor etc)...' : 'Any special request (extra bed, floor etc)...'.tr(),
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
                      if (_checkInDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select check-in date'.tr() == 'Please select check-in date' ? 'Please select check-in date' : 'Please select check-in date'.tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      if (_checkOutDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select check-out date'.tr() == 'Please select check-out date' ? 'Please select check-out date' : 'Please select check-out date'.tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      final DateFormat isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                      widget.onSubmit({
                        "checkInDate": isoFormat.format(_checkInDate!.toUtc()),
                        "checkOutDate": isoFormat.format(_checkOutDate!.toUtc()),
                        "numberOfRooms": _numberOfRooms,
                        "numberOfGuests": _numberOfGuests,
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

class ProgramBookingBottomSheet extends StatefulWidget {
  final String programName;
  final double price;
  final bool isDark;
  final Function(Map<String, dynamic> bookingData) onSubmit;

  const ProgramBookingBottomSheet({
    super.key,
    required this.programName,
    required this.price,
    required this.isDark,
    required this.onSubmit,
  });

  @override
  State<ProgramBookingBottomSheet> createState() => _ProgramBookingBottomSheetState();
}

class _ProgramBookingBottomSheetState extends State<ProgramBookingBottomSheet> {
  int _numberOfParticipants = 1;
  final _formKey = GlobalKey<FormState>();

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
                  'Book Program'.tr() == 'Book Program' ? 'Book Program' : 'Book Program'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.programName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.yellowColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Participants'.tr() == 'Number of Participants' ? 'Number of Participants' : 'Number of Participants'.tr(),
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
                              if (_numberOfParticipants > 1) {
                                setState(() => _numberOfParticipants--);
                              }
                            },
                          ),
                          Text(
                            '$_numberOfParticipants',
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
                              setState(() => _numberOfParticipants++);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSubmit({
                        "numberOfParticipants": _numberOfParticipants,
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

class TransportBookingBottomSheet extends StatefulWidget {
  final String transportName;
  final double price;
  final bool isDark;
  final Function(Map<String, dynamic> bookingData) onSubmit;

  const TransportBookingBottomSheet({
    super.key,
    required this.transportName,
    required this.price,
    required this.isDark,
    required this.onSubmit,
  });

  @override
  State<TransportBookingBottomSheet> createState() => _TransportBookingBottomSheetState();
}

class _TransportBookingBottomSheetState extends State<TransportBookingBottomSheet> {
  int _numberOfSeats = 1;
  final _formKey = GlobalKey<FormState>();

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
                  'Book Transport'.tr() == 'Book Transport' ? 'Book Transport' : 'Book Transport'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.transportName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.yellowColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Seats'.tr() == 'Number of Seats' ? 'Number of Seats' : 'Number of Seats'.tr(),
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
                              if (_numberOfSeats > 1) {
                                setState(() => _numberOfSeats--);
                              }
                            },
                          ),
                          Text(
                            '$_numberOfSeats',
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
                              setState(() => _numberOfSeats++);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSubmit({
                        "numberOfSeats": _numberOfSeats,
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
