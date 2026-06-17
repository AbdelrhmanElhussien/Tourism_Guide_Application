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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['guide', 'transportation', 'hotel', 'program'];
  final _availabilityController = TextEditingController();

  ProviderService? _editingService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ProviderService) {
        _editingService = args;
        _titleController.text = args.title;
        _descriptionController.text = args.description;
        _priceController.text = args.price.toString();
        _durationController.text = args.duration;
        _locationController.text = args.location;
        final String mappedCategory = args.category.toLowerCase();
        _selectedCategory = _categories.contains(mappedCategory) ? mappedCategory : null;
        _availabilityController.text = args.availability.join(', ');
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
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
      
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final duration = _durationController.text.trim();
      final location = _locationController.text.trim();
      final category = _selectedCategory!;
      final availability = _availabilityController.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (_editingService != null) {
        context.read<ProviderServicesCubit>().updateService(
          id: _editingService!.id,
          title: title,
          description: description,
          price: price,
          duration: duration,
          location: location,
          category: category,
          availability: availability,
        );
      } else {
        context.read<ProviderServicesCubit>().createService(
          title: title,
          description: description,
          price: price,
          duration: duration,
          location: location,
          category: category,
          availability: availability,
        );
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
                            // Photo Upload Area
                            _buildPhotoUploadArea(isLight),
                            const SizedBox(height: 24),

                            // Service Title Field
                            _buildLabel('service_title'.tr(), isLight),
                            _buildTextField(
                              controller: _titleController,
                              hintText: 'service_title_hint'.tr(),
                              isLight: isLight,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_title'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Category Selector
                            _buildLabel('category_label'.tr(), isLight),
                            _buildCategoryDropdown(isLight),
                            const SizedBox(height: 20),

                            // Price & Duration Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('price_label'.tr(), isLight),
                                      _buildTextField(
                                        controller: _priceController,
                                        hintText: 'price_hint'.tr(),
                                        isLight: isLight,
                                        keyboardType: TextInputType.number,
                                        prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'please_enter_price'.tr();
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('duration_label'.tr(), isLight),
                                      _buildTextField(
                                        controller: _durationController,
                                        hintText: 'duration_hint'.tr(),
                                        isLight: isLight,
                                        prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'please_enter_duration'.tr();
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Location Field
                            _buildLabel('address'.tr(), isLight),
                            _buildTextField(
                              controller: _locationController,
                              hintText: 'address_placeholder'.tr(),
                              isLight: isLight,
                              prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_address'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Description Field
                            _buildLabel('describe_service_hint'.tr(), isLight),
                            _buildTextField(
                              controller: _descriptionController,
                              hintText: 'describe_service_hint'.tr(),
                              isLight: isLight,
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_description'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Availability
                            _buildLabel('availability_label'.tr(), isLight),
                            _buildTextField(
                              controller: _availabilityController,
                              hintText: 'availability_hint'.tr() == 'availability_hint' ? 'e.g. Daily, Weekends, Mon, Tue' : 'availability_hint'.tr(),
                              isLight: isLight,
                              prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_availability'.tr() == 'please_enter_availability' ? 'Please enter availability' : 'please_enter_availability'.tr();
                                }
                                return null;
                              },
                            ),
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

  Widget _buildCategoryDropdown(bool isLight) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: _categories.map((cat) {
        return DropdownMenuItem<String>(
          value: cat,
          child: Text(
            cat.tr(),
            style: GoogleFonts.inter(
              color: isLight ? Colors.black : Colors.white,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedCategory = val;
        });
      },
      dropdownColor: isLight ? Colors.white : AppColors.bottomNavigationColor,
      decoration: InputDecoration(
        hintText: 'category_label'.tr(),
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
      ),
    );
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
