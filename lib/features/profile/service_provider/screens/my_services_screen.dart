import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_services_cubit.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_services_states.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  String selectedFilter = 'All';

  Widget _buildFilterChip(String value, String label, bool isLight) {
    final isSelected = selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedFilter = value;
          });
        }
      },
      selectedColor: AppColors.primaryColor,
      backgroundColor: isLight ? Colors.grey[200] : const Color(0xFF1E2E3E),
      labelStyle: GoogleFonts.inter(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : (isLight ? Colors.black87 : Colors.white70),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryColor
              : (isLight ? Colors.grey[300]! : Colors.white.withOpacity(0.08)),
        ),
      ),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<ProviderServicesCubit>()..fetchServices(),
      child: Scaffold(
        backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
        body: SafeArea(
          top: false,
          bottom: true,
          child: BlocConsumer<ProviderServicesCubit, ProviderServicesState>(
            listener: (context, state) {
              if (state is ProviderServiceActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              int count = 0;
              if (state is ProviderServicesSuccess) {
                count = state.services.length;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Section ──────────────────────────────────────────
                  _buildHeader(context, isLight, size, count),

                  // ── Filter Chips ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildFilterChip('All', 'all'.tr() == 'all' ? 'All' : 'all'.tr(), isLight),
                          const SizedBox(width: 8),
                          _buildFilterChip('Guide', 'guide'.tr() == 'guide' ? 'Guide' : 'guide'.tr(), isLight),
                          const SizedBox(width: 8),
                          _buildFilterChip('Transportation', 'transportation'.tr() == 'transportation' ? 'Transportation' : 'transportation'.tr(), isLight),
                          const SizedBox(width: 8),
                          _buildFilterChip('Hotels', 'hotels'.tr() == 'hotels' ? 'Hotels' : 'hotels'.tr(), isLight),
                          const SizedBox(width: 8),
                          _buildFilterChip('Programs', 'programs'.tr() == 'programs' ? 'Programs' : 'programs'.tr(), isLight),
                        ],
                      ),
                    ),
                  ),

                  // ── Services List Content ───────────────────────────────────
                  Expanded(
                    child: _buildBody(context, isLight, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLight, Size size, int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, size.height * 0.06, 20, 20),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteColor : AppColors.darkBlueColor,
        border: Border(
          bottom: BorderSide(
            color: isLight
                ? Colors.black.withOpacity(0.05)
                : Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isLight
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                color: isLight ? AppColors.primaryColor : Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Titles Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "my_services".tr(),
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$count ${"services_listed_count".tr()}",
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isLight, ProviderServicesState state) {
    if (state is ProviderServicesLoading || state is ProviderServicesInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    } else if (state is ProviderServicesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMsg,
              style: TextStyle(color: isLight ? Colors.black : Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProviderServicesCubit>().fetchServices();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      final allServices = state is ProviderServicesSuccess ? state.services : <ProviderService>[];
      final services = allServices.where((service) {
        if (selectedFilter == 'All') return true;
        final category = service.category.toLowerCase();
        if (selectedFilter == 'Transportation') {
          return category == 'transportation' || category == 'transport';
        }
        if (selectedFilter == 'Hotels') {
          return category == 'hotel' || category == 'hotels';
        }
        if (selectedFilter == 'Programs') {
          return category == 'program' || category == 'programs';
        }
        return category == selectedFilter.toLowerCase();
      }).toList();
      
      return RefreshIndicator(
        onRefresh: () => context.read<ProviderServicesCubit>().fetchServices(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: services.length + 1,
          itemBuilder: (context, index) {
            if (index == services.length) {
              return _buildAddServiceButton(context, isLight);
            }
            final s = services[index];
            return _buildServiceCard(
              context: context,
              service: s,
              isLight: isLight,
            );
          },
        ),
      );
    }
  }

  Widget _buildAddServiceButton(BuildContext context, bool isLight) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addServiceRouteName).then((_) {
          // ignore: use_build_context_synchronously
          context.read<ProviderServicesCubit>().fetchServices();
        });
      },
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: isLight
              ? Colors.black.withOpacity(0.15)
              : Colors.white.withOpacity(0.15),
          borderRadius: 16.0,
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          child: Text(
            "+ ${"add_new_service".tr()}",
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : AppColors.blueColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required ProviderService service,
    required bool isLight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteColor : AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight
              ? Colors.black.withOpacity(0.05)
              : AppColors.blueColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Top Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: service.imageUrl.isNotEmpty
                        ? Image.network(
                            service.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: isLight ? const Color(0xFFF1F3F6) : Colors.white12,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                                  size: 20,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: isLight ? const Color(0xFFF1F3F6) : Colors.white12,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                              size: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              service.title,
                              style: GoogleFonts.inter(
                                color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.category.tr(),
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            "${service.price.toInt()} EGP",
                            style: GoogleFonts.inter(
                              color: AppColors.yellowColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              "${service.bookingsCount} ${"bookings".tr()}",
                              style: GoogleFonts.inter(
                                color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            color: AppColors.yellowColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service.rating.toString(),
                            style: GoogleFonts.inter(
                              color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 0.5,
            color: isLight
                ? Colors.black.withOpacity(0.05)
                : Colors.white.withOpacity(0.05),
          ),
          // Actions Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.addServiceRouteName,
                      arguments: service,
                    ).then((_) {
                      // ignore: use_build_context_synchronously
                      context.read<ProviderServicesCubit>().fetchServices();
                    });
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "edit".tr(),
                          style: GoogleFonts.inter(
                            color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: 44,
                color: isLight
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: Text('delete'.tr()),
                        content: Text('are_you_sure_delete_service'.tr() == 'are_you_sure_delete_service' 
                            ? 'Are you sure you want to delete this service?' 
                            : 'are_you_sure_delete_service'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: Text('cancel'.tr() == 'cancel' ? 'Cancel' : 'cancel'.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              context.read<ProviderServicesCubit>().deleteService(service.id, service.category);
                            },
                            child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "delete".tr(),
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    // Draw dashed path
    final dashPath = Path();
    double distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final isDash = (distance ~/ dashLength) % 2 == 0;
        if (isDash) {
          dashPath.addPath(
            metric.extractPath(distance, distance + dashLength),
            Offset.zero,
          );
        }
        distance += dashLength;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
