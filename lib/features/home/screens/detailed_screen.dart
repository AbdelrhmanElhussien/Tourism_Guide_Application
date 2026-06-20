import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/features/home/widgets/top_circular_button.dart';
import 'package:tourist_app/features/home/provider/place_provider.dart';
import 'package:tourist_app/features/guide/provider/guide_provider.dart';
import 'package:tourist_app/features/explore/provider/hotel_provider.dart';
import 'package:tourist_app/features/explore/provider/transport_provider.dart';
import 'package:tourist_app/features/explore/provider/program_provider.dart';
import 'package:intl/intl.dart';
import 'package:tourist_app/domain/use_cases/trips/create_trip_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/get_saved_places_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/save_place_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/unsave_place_use_case.dart';
import 'dart:convert';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/profile/cubit/profile_cubit.dart';
import 'package:tourist_app/features/profile/cubit/profile_states.dart';

enum DetailType { place, hotel, transport, guide, program }

class DetailArgs {
  final String? id;
  final DetailType type;
  final String title;
  final String location;
  final double rating;
  final int reviewsCount;
  final String? assetImage;
  final String? networkImage;
  final String about;

  // Type-specific properties
  final String? price; // Price: "200 EGP", "1500 EGP/night", etc.
  final String? hours; // Hours: "8:00 AM - 5:00 PM"
  final String? duration; // Duration: "3 hours"
  final String? distance; // Distance: "15 km from Cairo"
  final String? speciality; // Guide speciality: "Historical, Cultural"
  final String? languages; // Guide languages: "English, Arabic"
  final String? hotelStars; // Hotel stars: "5 Stars"
  final String? capacity; // Transport capacity: "4 Seats"
  final String? transportType; // Transport type: "Car", "Felucca"

  const DetailArgs({
    this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    this.assetImage,
    this.networkImage,
    required this.about,
    this.price,
    this.hours,
    this.duration,
    this.distance,
    this.speciality,
    this.languages,
    this.hotelStars,
    this.capacity,
    this.transportType,
  });

  // Default fallback args (Giza Pyramids) if none passed
  static const DetailArgs fallback = DetailArgs(
    id: "4cddac58-d326-420b-3a43-08deca6f1a42",
    type: DetailType.place,
    title: "Pyramids of Giza",
    location: "Giza, Egypt",
    rating: 4.9,
    reviewsCount: 12543,
    assetImage: "assets/images/ImagePyramidsofGiza.png",
    about:
        "The Pyramids of Giza are among the most iconic monuments in the world. Built over 4,500 years ago, these ancient structures continue to captivate visitors with their engineering marvels and historical significance.",
    hours: "8:00 AM - 5:00 PM",
    price: "200 EGP",
    distance: "15 km from Cairo",
  );
}

class DetailScreen extends StatefulWidget {
  final DetailArgs? args;
  const DetailScreen({super.key, this.args});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isVisited = false;
  bool _isInit = true;
  DetailArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _args = widget.args ??
          (ModalRoute.of(context)?.settings.arguments as DetailArgs?) ??
          DetailArgs.fallback;
      if (_args!.id != null) {
        final id = _args!.id!;
        getIt<GetSavedPlacesUseCase>().invoke().then((savedList) {
          final isServerFavorite = savedList.any((item) => item.id == id);
          if (isServerFavorite) {
            if (mounted) {
              setState(() {
                isFavorite = true;
              });
            }
          } else {
            final localJson = CacheHelper.getData(key: _getLocalFavoritesKey());
            if (localJson != null && localJson is String) {
              final List<dynamic> localList = jsonDecode(localJson);
              final isLocalFavorite = localList.any((item) => item['id'] == id);
              if (mounted) {
                setState(() {
                  isFavorite = isLocalFavorite;
                });
              }
            }
          }
        }).catchError((_) {
          final localJson = CacheHelper.getData(key: _getLocalFavoritesKey());
          if (localJson != null && localJson is String) {
            final List<dynamic> localList = jsonDecode(localJson);
            final isLocalFavorite = localList.any((item) => item['id'] == id);
            if (mounted) {
              setState(() {
                isFavorite = isLocalFavorite;
              });
            }
          }
        });
        Future.microtask(() {
          if (!mounted) return;
          switch (_args!.type) {
            case DetailType.place:
              context.read<PlaceProvider>().fetchPlaceDetails(id);
              break;
            case DetailType.guide:
              context.read<GuideProvider>().fetchGuideDetails(id);
              break;
            case DetailType.hotel:
              context.read<HotelProvider>().fetchHotelDetails(id);
              break;
            case DetailType.transport:
              context.read<TransportProvider>().fetchTransportDetails(id);
              break;
            case DetailType.program:
              context.read<ProgramProvider>().fetchProgramDetails(id);
              break;
          }
        });
      }
      _isInit = false;
    }
  }

  String _getLocalFavoritesKey() {
    final email = CacheHelper.getData(key: 'email');
    if (email != null && email.toString().isNotEmpty) {
      return 'local_favorites_${email.toString()}';
    }
    return 'local_favorites';
  }

  void _toggleLocalFavorite(String id, DetailArgs args, bool isCurrentlyFavorite) {
    try {
      final key = _getLocalFavoritesKey();
      final localJson = CacheHelper.getData(key: key);
      List<dynamic> localList = [];
      if (localJson != null && localJson is String) {
        localList = List.from(jsonDecode(localJson));
      }
      
      if (isCurrentlyFavorite) {
        localList.removeWhere((item) => item['id'] == id);
      } else {
        final newItem = {
          'id': id,
          'title': args.title,
          'location': args.location,
          'rating': args.rating,
          'reviews': args.reviewsCount,
          'category': args.type.name,
          'networkImage': args.networkImage,
          'assetImage': args.assetImage,
        };
        if (!localList.any((item) => item['id'] == id)) {
          localList.add(newItem);
        }
      }
      CacheHelper.saveData(key: key, value: jsonEncode(localList));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    final guideProvider = Provider.of<GuideProvider>(context);
    final hotelProvider = Provider.of<HotelProvider>(context);
    final transportProvider = Provider.of<TransportProvider>(context);
    final programProvider = Provider.of<ProgramProvider>(context);

    DetailArgs args = _args ?? DetailArgs.fallback;

    if (args.id != null) {
      bool isLoading = false;
      String? errorMessage;

      switch (args.type) {
        case DetailType.place:
          isLoading = placeProvider.isLoadingDetails;
          errorMessage = placeProvider.errorMessageDetails;
          if (!isLoading && errorMessage == null && placeProvider.selectedPlaceDetails != null) {
            final place = placeProvider.selectedPlaceDetails!;
            args = DetailArgs(
              id: place.id,
              type: DetailType.place,
              title: place.name,
              location: place.locationName,
              rating: place.rating,
              reviewsCount: place.reviewCount,
              networkImage: place.imageUrl.isNotEmpty ? place.imageUrl : null,
              about: place.description,
              price: place.priceFrom > 0 ? "${place.priceFrom.toStringAsFixed(0)} EGP" : "Free",
              hours: place.openingHours,
              distance: "${place.distanceKm.toStringAsFixed(1)} km",
            );
          }
          break;
        case DetailType.guide:
          isLoading = guideProvider.isLoadingDetails;
          errorMessage = guideProvider.errorMessageDetails;
          if (!isLoading && errorMessage == null && guideProvider.selectedGuideDetails != null) {
            final guide = guideProvider.selectedGuideDetails!;
            args = DetailArgs(
              id: guide.id,
              type: DetailType.guide,
              title: guide.fullName,
              location: guide.nationality,
              rating: guide.rating,
              reviewsCount: guide.reviewCount,
              networkImage: guide.imageUrl.isNotEmpty ? guide.imageUrl : null,
              about: guide.bio.isNotEmpty ? guide.bio : guide.description,
              price: "\$${guide.pricePerDay.toStringAsFixed(0)}/day",
              speciality: guide.specialization,
              languages: guide.languages,
            );
          }
          break;
        case DetailType.hotel:
          isLoading = hotelProvider.isLoadingDetails;
          errorMessage = hotelProvider.errorMessageDetails;
          if (!isLoading && errorMessage == null && hotelProvider.selectedHotelDetails != null) {
            final hotel = hotelProvider.selectedHotelDetails!;
            args = DetailArgs(
              id: hotel.id,
              type: DetailType.hotel,
              title: hotel.name,
              location: hotel.location,
              rating: hotel.rating,
              reviewsCount: hotel.reviewCount,
              networkImage: hotel.imageUrl.isNotEmpty ? hotel.imageUrl : null,
              about: hotel.description,
              price: "\$${hotel.pricePerNight.toStringAsFixed(0)}/night",
              hotelStars: "${hotel.starRating} Stars",
            );
          }
          break;
        case DetailType.transport:
          isLoading = transportProvider.isLoadingDetails;
          errorMessage = transportProvider.errorMessageDetails;
          if (!isLoading && errorMessage == null && transportProvider.selectedTransportDetails != null) {
            final transport = transportProvider.selectedTransportDetails!;
            args = DetailArgs(
              id: transport.id,
              type: DetailType.transport,
              title: transport.name,
              location: "${transport.departureLocation} → ${transport.arrivalLocation}",
              rating: transport.rating,
              reviewsCount: transport.reviewCount,
              networkImage: transport.imageUrl.isNotEmpty ? transport.imageUrl : null,
              about: transport.description,
              price: "\$${transport.price.toStringAsFixed(0)}",
              capacity: "${transport.totalCapacity} Seats",
              transportType: transport.type,
            );
          }
          break;
        case DetailType.program:
          isLoading = programProvider.isLoadingDetails;
          errorMessage = programProvider.errorMessageDetails;
          if (!isLoading && errorMessage == null && programProvider.selectedProgramDetails != null) {
            final program = programProvider.selectedProgramDetails!;
            args = DetailArgs(
              id: program.id,
              type: DetailType.program,
              title: program.name,
              location: program.location,
              rating: program.rating,
              reviewsCount: program.reviewCount,
              networkImage: program.imageUrl.isNotEmpty ? program.imageUrl : null,
              about: program.description,
              price: "\$${program.price.toStringAsFixed(0)}",
              duration: "${program.duration} hrs",
            );
          }
          break;
      }

      if (isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (errorMessage != null) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final id = _args!.id!;
                    switch (_args!.type) {
                      case DetailType.place:
                        context.read<PlaceProvider>().fetchPlaceDetails(id, forceRefresh: true);
                        break;
                      case DetailType.guide:
                        context.read<GuideProvider>().fetchGuideDetails(id, forceRefresh: true);
                        break;
                      case DetailType.hotel:
                        context.read<HotelProvider>().fetchHotelDetails(id, forceRefresh: true);
                        break;
                      case DetailType.transport:
                        context.read<TransportProvider>().fetchTransportDetails(id, forceRefresh: true);
                        break;
                      case DetailType.program:
                        context.read<ProgramProvider>().fetchProgramDetails(id, forceRefresh: true);
                        break;
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingSide = screenWidth * 0.05;
    final themeProvider = Provider.of<Themeprovider>(context);
    final bool isDark = themeProvider.apptheme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBlueColor
          : const Color(0xffF8FAFC),
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100,
            ), // Padding to avoid overlap with bottom navigation bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Image Section
                _buildHeaderImage(context, args, isDark),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingSide,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Rating & Reviews
                      _buildRatingRow(args, isDark),
                      const SizedBox(height: 20),

                      // 3. Dynamic Info Cards Row (Differs by Type)
                      _buildDynamicInfoRow(args, isDark),
                      const SizedBox(height: 25),

                      // 4. About Section
                      _buildAboutSection(args, isDark),
                      const SizedBox(height: 25),

                      // 5. Context-based specific details
                      _buildContextSpecificDetails(args, isDark),
                      const SizedBox(height: 25),

                      // 6. Map Section (For places & hotels)
                      if (args.type == DetailType.place ||
                          args.type == DetailType.hotel) ...[
                        _buildMapPlaceholder(args, isDark),
                        const SizedBox(height: 25),
                      ],

                      // 7. Dynamic bottom list (Nearby places, other guides, etc.)
                      _buildBottomListSection(args, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Persistent Bottom Navigation/Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActionBar(context, args, isDark),
          ),
        ],
      ),
    );
  }

  // --- Header Image Widget ---
  Widget _buildHeaderImage(BuildContext context, DetailArgs args, bool isDark) {
    ImageProvider imageProvider;
    if (args.assetImage != null) {
      imageProvider = AssetImage(args.assetImage!);
    } else if (args.networkImage != null) {
      imageProvider = NetworkImage(args.networkImage!);
    } else {
      imageProvider = const NetworkImage(
        'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368',
      );
    }

    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 50,
          left: 20,
          child: ElevatedButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.HomeRouteName,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: const Color(0xFF1D3557),
              elevation: 4,
            ),
            child: const Icon(Icons.arrow_back, size: 20),
          ),
        ),

        // Action Buttons (Share, Visited, Favorite)
        Positioned(
          top: 50,
          right: 20,
          child: Row(
            children: [
              Topcircularbutton(
                icon: Icons.share,
                isSelected: false,
                fun: () {
                  // Share action
                },
              ),
              const SizedBox(width: 10),
              Topcircularbutton(
                icon: isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                isSelected: isFavorite,
                fun: () async {
                  if (_args!.id == null) return;
                  final id = _args!.id!;
                  try {
                    if (isFavorite) {
                      await getIt<UnsavePlaceUseCase>().invoke(id);
                    } else {
                      await getIt<SavePlaceUseCase>().invoke(id);
                    }
                    _toggleLocalFavorite(id, args, isFavorite);
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  } catch (e) {
                    // Fallback to saving/unsaving locally if the server fails (e.g., mock IDs or non-place categories)
                    _toggleLocalFavorite(id, args, isFavorite);
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        // Title and Location text overlay
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args.title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      args.location,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(1, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Rating Row ---
  Widget _buildRatingRow(DetailArgs args, bool isDark) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          args.rating.toString(),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? AppColors.begiColor : AppColors.blackColor,
          ),
        ),
        Text(
          " (${args.reviewsCount} reviews)",
          style: GoogleFonts.inter(
            color: isDark ? AppColors.blueColor : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // --- Dynamic Info Row ---
  Widget _buildDynamicInfoRow(DetailArgs args, bool isDark) {
    final Color textColorPrimary = isDark
        ? AppColors.begiColor
        : AppColors.primaryColor;
    final Color textColorSec = isDark ? AppColors.blueColor : Colors.blueGrey;

    List<Widget> infoItems = [];

    switch (args.type) {
      case DetailType.place:
        infoItems = [
          _buildInfoItem(
            Icons.access_time,
            "hours_label".tr(),
            args.hours ?? "8:00 AM - 5:00 PM",
            Colors.orange.shade50,
            Colors.orange,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.attach_money,
            "price_label".tr(),
            args.price ?? "200 EGP",
            Colors.yellow.shade50,
            Colors.orangeAccent,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.location_on_outlined,
            "distance_label".tr(),
            args.distance ?? "15 km",
            Colors.teal.shade50,
            Colors.teal,
            textColorPrimary,
            textColorSec,
          ),
        ];
        break;

      case DetailType.program:
        infoItems = [
          _buildInfoItem(
            Icons.access_time,
            "duration_label".tr() == "duration_label" ? "Duration" : "duration_label".tr(),
            args.duration ?? "1 Day",
            Colors.orange.shade50,
            Colors.orange,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.attach_money,
            "price_label".tr(),
            args.price ?? "200 EGP",
            Colors.yellow.shade50,
            Colors.orangeAccent,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.location_on_outlined,
            "distance_label".tr(),
            args.distance ?? "Egypt",
            Colors.teal.shade50,
            Colors.teal,
            textColorPrimary,
            textColorSec,
          ),
        ];
        break;

      case DetailType.guide:
        infoItems = [
          _buildInfoItem(
            Icons.translate,
            "languages_label".tr(),
            args.languages ?? "En, Ar",
            Colors.blue.shade50,
            Colors.blue,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.attach_money,
            "rate_label".tr(),
            args.price ?? "500 EGP/day",
            Colors.yellow.shade50,
            Colors.orangeAccent,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.workspace_premium_outlined,
            "speciality_label".tr(),
            args.speciality ?? "History",
            Colors.purple.shade50,
            Colors.purple,
            textColorPrimary,
            textColorSec,
          ),
        ];
        break;

      case DetailType.hotel:
        infoItems = [
          _buildInfoItem(
            Icons.star_outline,
            "stars_label".tr(),
            args.hotelStars ?? "5 Stars",
            Colors.amber.shade50,
            Colors.amber,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.attach_money,
            "price_label".tr(),
            args.price ?? "1500 EGP/night",
            Colors.yellow.shade50,
            Colors.orangeAccent,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.wifi,
            "wifi_label".tr(),
            "Free WiFi",
            Colors.green.shade50,
            Colors.green,
            textColorPrimary,
            textColorSec,
          ),
        ];
        break;

      case DetailType.transport:
        infoItems = [
          _buildInfoItem(
            Icons.directions_car_outlined,
            "type_label".tr(),
            args.transportType ?? "Car",
            Colors.blue.shade50,
            Colors.blue,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.people_outline,
            "capacity_label".tr(),
            args.capacity ?? "4 Seats",
            Colors.teal.shade50,
            Colors.teal,
            textColorPrimary,
            textColorSec,
          ),
          _buildInfoItem(
            Icons.attach_money,
            "price_label".tr(),
            args.price ?? "400 EGP/day",
            Colors.yellow.shade50,
            Colors.orangeAccent,
            textColorPrimary,
            textColorSec,
          ),
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.blueColor : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: infoItems,
      ),
    );
  }

  // --- Info Item Helper ---
  Widget _buildInfoItem(
    IconData icon,
    String label,
    String sub,
    Color bgColor,
    Color iconColor,
    Color textColorPrimary,
    Color textColorSec,
  ) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 22,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: textColorPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColorSec,
            ),
          ),
        ],
      ),
    );
  }

  // --- About Section ---
  Widget _buildAboutSection(DetailArgs args, bool isDark) {
    String aboutTitle = "about_label".tr();
    if (args.type == DetailType.guide) {
      aboutTitle = "bio_label".tr();
    } else if (args.type == DetailType.hotel) {
      aboutTitle = "overview_label".tr();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          aboutTitle,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.begiColor : AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          args.about,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isDark ? AppColors.blueColor : Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- Context-Specific Details (Amenities, Specialities, etc.) ---
  Widget _buildContextSpecificDetails(DetailArgs args, bool isDark) {
    if (args.type == DetailType.guide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "details_label".tr(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.begiColor : AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.check_circle_outline,
            "certified_guide".tr(),
            isDark,
          ),
          _buildDetailRow(
            Icons.chat_bubble_outline,
            "languages_fluent".tr(),
            isDark,
          ),
          _buildDetailRow(
            Icons.history_edu_outlined,
            "specialized_history".tr(),
            isDark,
          ),
        ],
      );
    } else if (args.type == DetailType.hotel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "amenities_label".tr(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.begiColor : AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildAmenityChip(Icons.pool, "Pool", isDark),
              _buildAmenityChip(Icons.wifi, "Free WiFi", isDark),
              _buildAmenityChip(Icons.local_parking, "Parking", isDark),
              _buildAmenityChip(Icons.spa, "Spa & Wellness", isDark),
              _buildAmenityChip(Icons.restaurant, "Restaurant", isDark),
            ],
          ),
        ],
      );
    } else if (args.type == DetailType.transport) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "rental_includes".tr(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.begiColor : AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.check_circle_outline,
            "air_conditioning".tr(),
            isDark,
          ),
          _buildDetailRow(Icons.person, "with_driver".tr(), isDark),
          _buildDetailRow(
            Icons.local_gas_station,
            "fuel_included".tr(),
            isDark,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDetailRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.yellowColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String text, bool isDark) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: isDark ? AppColors.yellowColor : AppColors.primaryColor,
      ),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: isDark
          ? AppColors.bottomNavigationColor
          : Colors.grey.shade100,
      side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
    );
  }

  // --- Map Placeholder Widget ---
  Widget _buildMapPlaceholder(DetailArgs args, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101E2E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? AppColors.blueColor : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.map_outlined,
            size: 50,
            color: isDark ? AppColors.yellowColor : Colors.blueGrey,
          ),
          const SizedBox(height: 45),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.bottomNavigationColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "view_on_map".tr(),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.begiColor : Colors.black,
                      ),
                    ),
                    Text(
                      args.location,
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark
                      ? AppColors.yellowColor
                      : AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Dynamic Bottom Horizontal List Section ---
  Widget _buildBottomListSection(DetailArgs args, bool isDark) {
    String sectionTitle = "nearby_places".tr();
    if (args.type == DetailType.guide) {
      sectionTitle = "other_guides".tr();
    } else if (args.type == DetailType.hotel) {
      sectionTitle = "recommended_hotels".tr();
    } else if (args.type == DetailType.transport) {
      sectionTitle = "other_transport".tr();
    }

    final Color textColorPrimary = isDark ? AppColors.begiColor : Colors.black;
    final Color textColorSec = isDark ? AppColors.blueColor : Colors.blueGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColorPrimary,
          ),
        ),
        const SizedBox(height: 15),

        // Horizontal List
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildBottomListCards(
              args.type,
              textColorPrimary,
              textColorSec,
              isDark,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBottomListCards(
    DetailType type,
    Color textColorPrimary,
    Color textColorSec,
    bool isDark,
  ) {
    if (type == DetailType.guide) {
      return [
        _buildNearbyCard(
          "Ahmed Mansour",
          "Cairo, Egypt",
          "4.9",
          "48",
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
        _buildNearbyCard(
          "Sarah Ali",
          "Luxor, Egypt",
          "4.8",
          "35",
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
      ];
    } else if (type == DetailType.hotel) {
      return [
        _buildNearbyCard(
          "Steigenberger Hotel",
          "El Gouna, Egypt",
          "4.8",
          "1205",
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
        _buildNearbyCard(
          "Hilton Luxor",
          "Luxor, Egypt",
          "4.7",
          "854",
          "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
      ];
    } else if (type == DetailType.transport) {
      return [
        _buildNearbyCard(
          "Luxury SUV (Hyundai)",
          "Cairo, Egypt",
          "4.9",
          "210",
          "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
        _buildNearbyCard(
          "Private Nile Felucca",
          "Aswan, Egypt",
          "4.9",
          "184",
          "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&q=80",
          textColorPrimary,
          textColorSec,
        ),
      ];
    }

    // Default place
    return [
      _buildNearbyCard(
        "Great Sphinx",
        "Giza, Egypt",
        "4.8",
        "9876",
        "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368",
        textColorPrimary,
        textColorSec,
      ),
      _buildNearbyCard(
        "Egyptian Museum",
        "Cairo, Egypt",
        "4.7",
        "5432",
        "https://images.unsplash.com/photo-1572252009286-268acec5a0af?w=400&q=80",
        textColorPrimary,
        textColorSec,
      ),
    ];
  }

  // Card Helper
  Widget _buildNearbyCard(
    String title,
    String loc,
    String rating,
    String reviews,
    String imgUrl,
    Color textColorPrimary,
    Color textColorSec,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColorSec.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imgUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColorPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        loc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      " $rating",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: textColorSec,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "($reviews)",
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Bottom Action Bar Widget ---
  Widget _buildBottomActionBar(
    BuildContext context,
    DetailArgs args,
    bool isDark,
  ) {
    String buttonText = "book_now".tr();
    if (args.type == DetailType.guide) {
      buttonText = "book_guide".tr();
    } else if (args.type == DetailType.hotel) {
      buttonText = "book_room".tr();
    } else if (args.type == DetailType.transport) {
      buttonText = "rent_now".tr();
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (args.price != null) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "price_label".tr(),
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  args.price!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark
                        ? AppColors.yellowColor
                        : AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
          ],
          if (args.type == DetailType.guide) ...[
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.yellowColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.yellowColor,
                ),
                onPressed: () {
                  if (args.id != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatRoomRouteName,
                      arguments: {
                        'guideId': args.id!,
                        'guideName': args.title,
                        'guideImageUrl': args.networkImage ?? '',
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Trigger booking success dialog
                  DialogeUtils.showMassage(
                    context: context,
                    title: "success_title".tr(),
                    masseage: "booking_success_msg".tr(),
                    posActionName: "ok_action".tr(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellowColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String trDefault(String defaultValue) {
    final translated = this.tr();
    return translated == this ? defaultValue : translated;
  }
}
