import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_services_cubit.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_services_states.dart';
import 'my_services_screen.dart'; // To reuse DashedBorderPainter

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  String? _selectedCategory;
  final List<String> _categories = ['guide', 'transportation', 'hotel', 'program'];

  ProviderService? _editingService;
  bool _isInitialized = false;
  String _selectedTransportType = 'cars';
  int _selectedHotelStarRating = 5;

  TextEditingController _getController(String key) {
    return _controllers.putIfAbsent(key, () => TextEditingController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ProviderService) {
        _editingService = args;
        final String mappedCategory = args.category.toLowerCase();
        _selectedCategory = _categories.contains(mappedCategory) ? mappedCategory : 'guide';
        
        // Populate mapped controllers
        if (_selectedCategory == 'guide') {
          _getController('guide_fullName').text = args.title;
          _getController('guide_description').text = args.description;
          _getController('guide_pricePerDay').text = args.price.toString();
          _getController('guide_bio').text = args.description;
          _getController('guide_specialization').text = args.location;
          _getController('guide_nationality').text = args.location;
          _getController('guide_languages').text = args.availability.join(', ');
          _getController('guide_imageUrl').text = args.imageUrl;
        } else if (_selectedCategory == 'hotel') {
          _getController('hotel_name').text = args.title;
          _getController('hotel_description').text = args.description;
          _getController('hotel_pricePerNight').text = args.price.toString();
          _getController('hotel_location').text = args.location;
          _getController('hotel_amenities').text = args.availability.join(', ');
          _getController('hotel_imageUrl').text = args.imageUrl;
          
          final ratingInt = args.rating.round();
          if (ratingInt >= 2 && ratingInt <= 5) {
            _selectedHotelStarRating = ratingInt;
          } else {
            _selectedHotelStarRating = 5;
          }
        } else if (_selectedCategory == 'transportation') {
          _getController('transport_name').text = args.title;
          _getController('transport_description').text = args.description;
          _getController('transport_price').text = args.price.toString();
          _getController('transport_departureLocation').text = args.location;
          _getController('transport_arrivalLocation').text = args.availability.join(', ');
          _getController('transport_imageUrl').text = args.imageUrl;
          
          final rawType = args.duration.toLowerCase().trim();
          if (rawType == 'cars' || rawType == 'cruises' || rawType == 'carriage' || rawType == 'felucca') {
            _selectedTransportType = rawType;
          } else if (rawType == 'car') {
            _selectedTransportType = 'cars';
          } else if (rawType == 'boat') {
            _selectedTransportType = 'felucca';
          } else {
            _selectedTransportType = 'cars';
          }
        } else if (_selectedCategory == 'program') {
          _getController('program_name').text = args.title;
          _getController('program_description').text = args.description;
          _getController('program_price').text = args.price.toString();
          _getController('program_location').text = args.location;
          _getController('program_category').text = args.availability.join(', ');
          _getController('program_duration').text = args.duration.replaceAll(' days', '').replaceAll(' day', '');
          _getController('program_imageUrl').text = args.imageUrl;
        }
      } else {
        _selectedCategory = 'guide'; // default category
        _selectedTransportType = 'cars';
        _selectedHotelStarRating = 5;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('please_select_category'.tr()),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      
      final category = _selectedCategory!;
      
      if (_editingService != null) {
        String title = '';
        String description = '';
        double price = 0.0;
        String duration = '';
        String location = '';
        List<String> availability = [];

        if (category == 'guide') {
          title = _getController('guide_fullName').text.trim();
          description = _getController('guide_description').text.trim();
          price = double.tryParse(_getController('guide_pricePerDay').text.trim()) ?? 0.0;
          duration = '1 day';
          location = _getController('guide_nationality').text.trim();
          availability = [_getController('guide_languages').text.trim()];
        } else if (category == 'hotel') {
          title = _getController('hotel_name').text.trim();
          description = _getController('hotel_description').text.trim();
          price = double.tryParse(_getController('hotel_pricePerNight').text.trim()) ?? 0.0;
          duration = '1 night';
          location = _getController('hotel_location').text.trim();
          availability = [_getController('hotel_amenities').text.trim()];
        } else if (category == 'transportation') {
          title = _getController('transport_name').text.trim();
          description = _getController('transport_description').text.trim();
          price = double.tryParse(_getController('transport_price').text.trim()) ?? 0.0;
          duration = _selectedTransportType;
          location = _getController('transport_departureLocation').text.trim();
          availability = [_getController('transport_arrivalLocation').text.trim()];
        } else if (category == 'program') {
          title = _getController('program_name').text.trim();
          description = _getController('program_description').text.trim();
          price = double.tryParse(_getController('program_price').text.trim()) ?? 0.0;
          duration = '${_getController('program_duration').text.trim()} days';
          location = _getController('program_location').text.trim();
          availability = [_getController('program_category').text.trim()];
        }

        context.read<ProviderServicesCubit>().updateService(
          id: _editingService!.id,
          title: title,
          description: description,
          price: price,
          duration: duration,
          location: location,
          category: category,
          availability: availability,
          placeId: _editingService!.placeId,
        );
      } else {
        final Map<String, dynamic> data = {};
        
        if (category == 'guide') {
          data['fullName'] = _getController('guide_fullName').text.trim();
          data['phoneNumber'] = _getController('guide_phoneNumber').text.trim();
          data['email'] = _getController('guide_email').text.trim();
          data['description'] = _getController('guide_description').text.trim();
          data['nationality'] = _getController('guide_nationality').text.trim();
          data['languages'] = _getController('guide_languages').text.trim();
          data['specialization'] = _getController('guide_specialization').text.trim();
          data['imageUrl'] = _getController('guide_imageUrl').text.trim().isNotEmpty 
              ? _getController('guide_imageUrl').text.trim()
              : 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e';
          data['bio'] = _getController('guide_bio').text.trim();
          data['pricePerDay'] = double.tryParse(_getController('guide_pricePerDay').text.trim()) ?? 0.0;
        } else if (category == 'hotel') {
          data['name'] = _getController('hotel_name').text.trim();
          data['location'] = _getController('hotel_location').text.trim();
          data['city'] = _getController('hotel_city').text.trim();
          data['country'] = _getController('hotel_country').text.trim();
          data['description'] = _getController('hotel_description').text.trim();
          data['imageUrl'] = _getController('hotel_imageUrl').text.trim().isNotEmpty 
              ? _getController('hotel_imageUrl').text.trim()
              : 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e';
          data['starRating'] = _selectedHotelStarRating;
          data['pricePerNight'] = double.tryParse(_getController('hotel_pricePerNight').text.trim()) ?? 0.0;
          data['availableRooms'] = int.tryParse(_getController('hotel_availableRooms').text.trim()) ?? 10;
          data['amenities'] = _getController('hotel_amenities').text.trim();
          data['contactNumber'] = _getController('hotel_contactNumber').text.trim();
          data['email'] = _getController('hotel_email').text.trim();
        } else if (category == 'transportation') {
          data['name'] = _getController('transport_name').text.trim();
          data['type'] = _selectedTransportType;
          data['description'] = _getController('transport_description').text.trim();
          data['imageUrl'] = _getController('transport_imageUrl').text.trim().isNotEmpty 
              ? _getController('transport_imageUrl').text.trim()
              : 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e';
          data['departureLocation'] = _getController('transport_departureLocation').text.trim();
          data['arrivalLocation'] = _getController('transport_arrivalLocation').text.trim();
          data['departureTime'] = _getController('transport_departureTime').text.trim();
          data['arrivalTime'] = _getController('transport_arrivalTime').text.trim();
          data['price'] = double.tryParse(_getController('transport_price').text.trim()) ?? 0.0;
          data['totalCapacity'] = int.tryParse(_getController('transport_totalCapacity').text.trim()) ?? 4;
        } else if (category == 'program') {
          data['name'] = _getController('program_name').text.trim();
          data['description'] = _getController('program_description').text.trim();
          data['imageUrl'] = _getController('program_imageUrl').text.trim().isNotEmpty 
              ? _getController('program_imageUrl').text.trim()
              : 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e';
          data['category'] = _getController('program_category').text.trim();
          data['location'] = _getController('program_location').text.trim();
          data['city'] = _getController('program_city').text.trim();
          data['country'] = _getController('program_country').text.trim();
          data['price'] = double.tryParse(_getController('program_price').text.trim()) ?? 0.0;
          data['duration'] = int.tryParse(_getController('program_duration').text.trim()) ?? 1;
          data['maxParticipants'] = int.tryParse(_getController('program_maxParticipants').text.trim()) ?? 10;
          data['includedServices'] = _getController('program_includedServices').text.trim();
          
          final inputDate = _getController('program_startDate').text.trim();
          data['startDate'] = inputDate.isNotEmpty ? inputDate : DateTime.now().toIso8601String();
        }

        context.read<ProviderServicesCubit>().createCategorizedService(category, data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<ProviderServicesCubit>(),
      child: BlocConsumer<ProviderServicesCubit, ProviderServicesState>(
        listener: (context, state) {
          if (state is ProviderServiceActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProviderServicesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProviderServicesLoading;
          return Scaffold(
            backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
            body: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                children: [
                  // ── Header Section ──────────────────────────────────────────
                  _buildHeader(context, isLight, size),

                  // ── Form Content ───────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Categories fixed buttons
                            _buildLabel('category_label'.tr(), isLight),
                            _buildFixedCategoryButtons(isLight),
                            const SizedBox(height: 24),

                            // Photo Upload Area
                            _buildPhotoUploadArea(isLight),
                            const SizedBox(height: 24),

                            // Category-Specific Form Fields
                            _buildCategoryFields(isLight),
                            const SizedBox(height: 32),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => _submitForm(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.yellowColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        _editingService != null ? 'edit'.tr() : 'add_service'.tr(),
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
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
    );
  }

  Widget _buildHeader(BuildContext context, bool isLight, Size size) {
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
          // Title
          Text(
            _editingService != null ? 'edit'.tr() : 'add_service_title'.tr(),
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, bool isLight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isLight ? AppColors.primaryColor : Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isLight,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        color: isLight ? Colors.black : Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        filled: true,
        fillColor: isLight ? Colors.white : AppColors.cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight ? Colors.black.withOpacity(0.06) : Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.yellowColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFixedCategoryButtons(bool isLight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = (constraints.maxWidth - 24) / 4;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              
              IconData icon;
              String label;
              switch (cat) {
                case 'guide':
                  icon = Icons.explore_outlined;
                  label = 'guide'.tr();
                  break;
                case 'transportation':
                  icon = Icons.directions_car_outlined;
                  label = 'transportation'.tr();
                  break;
                case 'hotel':
                  icon = Icons.hotel_outlined;
                  label = 'hotel'.tr();
                  break;
                case 'program':
                  icon = Icons.event_note_outlined;
                  label = 'program'.tr();
                  break;
                default:
                  icon = Icons.category_outlined;
                  label = cat;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryColor 
                        : (isLight ? Colors.white : AppColors.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : (isLight ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.08)),
                      width: 1.5,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isSelected 
                            ? Colors.white 
                            : (isLight ? AppColors.primaryColor : AppColors.blueColor),
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          color: isSelected 
                              ? Colors.white 
                              : (isLight ? Colors.black87 : Colors.white70),
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _getCleanStarRatingLabel(int starRating) {
    final key = '${starRating}_star_hotels';
    final raw = key.tr();
    return raw
        .replaceAll('Hotels', '')
        .replaceAll('hotels', '')
        .replaceAll('Hotel', '')
        .replaceAll('hotel', '')
        .replaceAll('فنادق ', '')
        .replaceAll('Hôtels ', '')
        .replaceAll('Hoteles ', '')
        .replaceAll('酒店', '')
        .replaceAll(' отели', '')
        .replaceAll('отели', '')
        .trim();
  }

  Widget _buildTransportTypeSelector(bool isLight) {
    final types = ['cars', 'cruises', 'carriage', 'felucca'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = (constraints.maxWidth - 24) / 4;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: types.map((type) {
              final isSelected = _selectedTransportType == type;
              
              IconData icon;
              switch (type) {
                case 'cars':
                  icon = Icons.directions_car_outlined;
                  break;
                case 'cruises':
                  icon = Icons.directions_boat_outlined;
                  break;
                case 'carriage':
                  icon = Icons.airport_shuttle_outlined;
                  break;
                case 'felucca':
                  icon = Icons.sailing_outlined;
                  break;
                default:
                  icon = Icons.directions_car_outlined;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTransportType = type;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryColor 
                        : (isLight ? Colors.white : AppColors.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : (isLight ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.08)),
                      width: 1.5,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isSelected 
                            ? Colors.white 
                            : (isLight ? AppColors.primaryColor : AppColors.blueColor),
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        type.tr(),
                        style: GoogleFonts.inter(
                          color: isSelected 
                              ? Colors.white 
                              : (isLight ? Colors.black87 : Colors.white70),
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildHotelStarRatingSelector(bool isLight) {
    final ratings = [5, 4, 3, 2];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = (constraints.maxWidth - 24) / 4;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ratings.map((rating) {
              final isSelected = _selectedHotelStarRating == rating;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHotelStarRating = rating;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryColor 
                        : (isLight ? Colors.white : AppColors.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : (isLight ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.08)),
                      width: 1.5,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: isSelected 
                            ? AppColors.yellowColor 
                            : (isLight ? AppColors.yellowColor : AppColors.blueColor),
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getCleanStarRatingLabel(rating),
                        style: GoogleFonts.inter(
                          color: isSelected 
                              ? Colors.white 
                              : (isLight ? Colors.black87 : Colors.white70),
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFields(bool isLight) {
    if (_selectedCategory == null) return const SizedBox.shrink();
    
    switch (_selectedCategory!) {
      case 'guide':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Full Name', isLight),
            _buildTextField(controller: _getController('guide_fullName'), hintText: 'Enter full name', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Phone Number', isLight),
            _buildTextField(controller: _getController('guide_phoneNumber'), hintText: 'Enter phone number', isLight: isLight, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildLabel('Email', isLight),
            _buildTextField(controller: _getController('guide_email'), hintText: 'Enter email address', isLight: isLight, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildLabel('Description', isLight),
            _buildTextField(controller: _getController('guide_description'), hintText: 'Enter description', isLight: isLight, maxLines: 3),
            const SizedBox(height: 16),
            _buildLabel('Nationality', isLight),
            _buildTextField(controller: _getController('guide_nationality'), hintText: 'Enter nationality', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Languages Spoken', isLight),
            _buildTextField(controller: _getController('guide_languages'), hintText: 'e.g. English, Arabic', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Specialization', isLight),
            _buildTextField(controller: _getController('guide_specialization'), hintText: 'e.g. Historical sites', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Image URL', isLight),
            _buildTextField(controller: _getController('guide_imageUrl'), hintText: 'Enter image URL', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Biography', isLight),
            _buildTextField(controller: _getController('guide_bio'), hintText: 'Enter short bio', isLight: isLight, maxLines: 2),
            const SizedBox(height: 16),
            _buildLabel('Price Per Day (EGP)', isLight),
            _buildTextField(controller: _getController('guide_pricePerDay'), hintText: 'e.g. 500', isLight: isLight, keyboardType: TextInputType.number),
          ],
        );
      case 'hotel':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Hotel Name', isLight),
            _buildTextField(controller: _getController('hotel_name'), hintText: 'Enter hotel name', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Location / Address', isLight),
            _buildTextField(controller: _getController('hotel_location'), hintText: 'Enter location address', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('City', isLight),
            _buildTextField(controller: _getController('hotel_city'), hintText: 'Enter city', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Country', isLight),
            _buildTextField(controller: _getController('hotel_country'), hintText: 'Enter country', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Description', isLight),
            _buildTextField(controller: _getController('hotel_description'), hintText: 'Enter hotel description', isLight: isLight, maxLines: 3),
            const SizedBox(height: 16),
            _buildLabel('Image URL', isLight),
            _buildTextField(controller: _getController('hotel_imageUrl'), hintText: 'Enter image URL', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Star Rating', isLight),
            _buildHotelStarRatingSelector(isLight),
            const SizedBox(height: 16),
            _buildLabel('Price Per Night (EGP)', isLight),
            _buildTextField(controller: _getController('hotel_pricePerNight'), hintText: 'e.g. 1500', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Available Rooms', isLight),
            _buildTextField(controller: _getController('hotel_availableRooms'), hintText: 'e.g. 25', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Amenities', isLight),
            _buildTextField(controller: _getController('hotel_amenities'), hintText: 'e.g. Pool, WiFi, Spa', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Contact Number', isLight),
            _buildTextField(controller: _getController('hotel_contactNumber'), hintText: 'Enter contact phone number', isLight: isLight, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildLabel('Email Address', isLight),
            _buildTextField(controller: _getController('hotel_email'), hintText: 'Enter contact email address', isLight: isLight, keyboardType: TextInputType.emailAddress),
          ],
        );
      case 'transportation':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Name / Title', isLight),
            _buildTextField(controller: _getController('transport_name'), hintText: 'e.g. Luxury Bus, Private Car', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Type', isLight),
            _buildTransportTypeSelector(isLight),
            const SizedBox(height: 16),
            _buildLabel('Description', isLight),
            _buildTextField(controller: _getController('transport_description'), hintText: 'Enter vehicle description', isLight: isLight, maxLines: 3),
            const SizedBox(height: 16),
            _buildLabel('Image URL', isLight),
            _buildTextField(controller: _getController('transport_imageUrl'), hintText: 'Enter image URL', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Departure Location', isLight),
            _buildTextField(controller: _getController('transport_departureLocation'), hintText: 'Enter departure station', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Arrival Location', isLight),
            _buildTextField(controller: _getController('transport_arrivalLocation'), hintText: 'Enter arrival station', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Departure Time', isLight),
            _buildTextField(controller: _getController('transport_departureTime'), hintText: 'e.g. 08:00 AM', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Arrival Time', isLight),
            _buildTextField(controller: _getController('transport_arrivalTime'), hintText: 'e.g. 12:00 PM', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Price (EGP)', isLight),
            _buildTextField(controller: _getController('transport_price'), hintText: 'e.g. 200', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Total Capacity (Passengers)', isLight),
            _buildTextField(controller: _getController('transport_totalCapacity'), hintText: 'e.g. 50', isLight: isLight, keyboardType: TextInputType.number),
          ],
        );
      case 'program':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Program Name', isLight),
            _buildTextField(controller: _getController('program_name'), hintText: 'Enter program name', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Description', isLight),
            _buildTextField(controller: _getController('program_description'), hintText: 'Enter program description', isLight: isLight, maxLines: 3),
            const SizedBox(height: 16),
            _buildLabel('Image URL', isLight),
            _buildTextField(controller: _getController('program_imageUrl'), hintText: 'Enter image URL', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Category', isLight),
            _buildTextField(controller: _getController('program_category'), hintText: 'e.g. Adventure, Cultural', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Location', isLight),
            _buildTextField(controller: _getController('program_location'), hintText: 'Enter main location', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('City', isLight),
            _buildTextField(controller: _getController('program_city'), hintText: 'Enter city', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Country', isLight),
            _buildTextField(controller: _getController('program_country'), hintText: 'Enter country', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Price (EGP)', isLight),
            _buildTextField(controller: _getController('program_price'), hintText: 'e.g. 1000', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Duration (Days)', isLight),
            _buildTextField(controller: _getController('program_duration'), hintText: 'e.g. 3', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Max Participants', isLight),
            _buildTextField(controller: _getController('program_maxParticipants'), hintText: 'e.g. 15', isLight: isLight, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildLabel('Included Services', isLight),
            _buildTextField(controller: _getController('program_includedServices'), hintText: 'e.g. Meals, Guidance, Tickets', isLight: isLight),
            const SizedBox(height: 16),
            _buildLabel('Start Date', isLight),
            _buildTextField(controller: _getController('program_startDate'), hintText: 'e.g. 2026-06-20T13:59:47Z', isLight: isLight),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPhotoUploadArea(bool isLight) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: isLight ? Colors.black.withOpacity(0.12) : Colors.white.withOpacity(0.12),
        borderRadius: 16,
      ),
      child: Container(
        width: double.infinity,
        height: 120,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 36,
              color: isLight ? AppColors.primaryColor : AppColors.blueColor,
            ),
            const SizedBox(height: 8),
            Text(
              'upload_photos'.tr(),
              style: GoogleFonts.inter(
                color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'upload_photos_subtitle'.tr(),
              style: GoogleFonts.inter(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
