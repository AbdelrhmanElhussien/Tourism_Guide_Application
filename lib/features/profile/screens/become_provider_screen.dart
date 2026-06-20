import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/profile/cubit/provider_request_cubit.dart';
import 'package:tourist_app/features/profile/cubit/provider_request_states.dart';

class BecomeProviderScreen extends StatefulWidget {
  const BecomeProviderScreen({super.key});

  @override
  State<BecomeProviderScreen> createState() => _BecomeProviderScreenState();
}

class _BecomeProviderScreenState extends State<BecomeProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _documentUrlController = TextEditingController();

  String _selectedBusinessType = 'Tour Operator';

  final List<String> _businessTypes = [
    'Tour Operator',
    'Transportation Provider',
    'Hotel / Accommodation',
    'Local Guide Service',
    'Other'
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _taxNumberController.dispose();
    _registrationNumberController.dispose();
    _documentUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    return BlocProvider(
      create: (context) => getIt<ProviderRequestCubit>()..fetchMyRequest(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBlueColor : const Color(0xffF8FAFC),
        body: BlocConsumer<ProviderRequestCubit, ProviderRequestState>(
          listener: (context, state) {
            if (state is ProviderRequestSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ProviderRequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMsg),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // ── Header ──
                  _buildHeader(context, isDark),
                  
                  // ── Body Content ──
                  Expanded(
                    child: _buildBody(context, isDark, state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'become_provider'.tr() == 'become_provider' ? 'Become a Provider' : 'become_provider'.tr(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark, ProviderRequestState state) {
    if (state is ProviderRequestLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (state is ProviderRequestLoaded) {
      final req = state.requestResponse;
      if (req != null && req.success == true && req.data != null) {
        final status = req.data!.status?.toLowerCase() ?? 'pending';
        if (status == 'approved') {
          return _buildApprovedState(context, isDark);
        } else if (status == 'pending' || status == 'submitted') {
          return _buildPendingState(isDark, req.data!.businessName ?? '', req.data!.businessType ?? '');
        } else if (status == 'rejected' || status == 'declined') {
          return _buildRejectedState(isDark, req.data!.rejectionReason ?? 'No reason provided.');
        }
      }
    }

    // Default: Show Form
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'register_business_title'.tr() == 'register_business_title'
                      ? 'Register your business'
                      : 'register_business_title'.tr(),
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : AppColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'register_business_sub'.tr() == 'register_business_sub'
                      ? 'Submit your business details and credentials to join our provider community.'
                      : 'register_business_sub'.tr(),
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildLabel('business_name'.tr() == 'business_name' ? 'Business Name' : 'business_name'.tr(), isDark),
                _buildTextField(
                  controller: _businessNameController,
                  hintText: 'Enter business name',
                  isDark: isDark,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Business name is required' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('business_type'.tr() == 'business_type' ? 'Business Type' : 'business_type'.tr(), isDark),
                _buildDropdown(isDark),
                const SizedBox(height: 16),

                _buildLabel('business_description'.tr() == 'business_description' ? 'Business Description' : 'business_description'.tr(), isDark),
                _buildTextField(
                  controller: _businessDescriptionController,
                  hintText: 'Enter business description',
                  isDark: isDark,
                  maxLines: 3,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('contact_number'.tr() == 'contact_number' ? 'Contact Number' : 'contact_number'.tr(), isDark),
                _buildTextField(
                  controller: _contactNumberController,
                  hintText: 'Enter contact phone number',
                  isDark: isDark,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Contact number is required' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('email'.tr(), isDark),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter email address',
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('tax_number'.tr() == 'tax_number' ? 'Tax Number' : 'tax_number'.tr(), isDark),
                _buildTextField(
                  controller: _taxNumberController,
                  hintText: 'Enter tax registration number',
                  isDark: isDark,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Tax number is required' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('registration_number'.tr() == 'registration_number' ? 'Commercial Registration Number' : 'registration_number'.tr(), isDark),
                _buildTextField(
                  controller: _registrationNumberController,
                  hintText: 'Enter commercial registration number',
                  isDark: isDark,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Registration number is required' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('document_url'.tr() == 'document_url' ? 'Credential Document URL' : 'document_url'.tr(), isDark),
                _buildTextField(
                  controller: _documentUrlController,
                  hintText: 'Link to PDF/Image of registration certificate',
                  isDark: isDark,
                  keyboardType: TextInputType.url,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Document URL is required';
                    if (!val.startsWith('http://') && !val.startsWith('https://')) {
                      return 'Must be a valid URL starting with http:// or https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProviderRequestCubit>().submitRequest(
                        businessName: _businessNameController.text.trim(),
                        businessType: _selectedBusinessType,
                        businessDescription: _businessDescriptionController.text.trim(),
                        contactNumber: _contactNumberController.text.trim(),
                        email: _emailController.text.trim(),
                        taxNumber: _taxNumberController.text.trim(),
                        registrationNumber: _registrationNumberController.text.trim(),
                        documentUrl: _documentUrlController.text.trim(),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.yellowColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellowColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'submit_request'.tr() == 'submit_request' ? 'Submit Request' : 'submit_request'.tr(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        if (state is ProviderRequestSubmitting)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: isDark ? Colors.white30 : Colors.black38, fontSize: 14),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E2F46) : const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.yellowColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2F46) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBusinessType,
          dropdownColor: isDark ? AppColors.darkBlueColor : Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : Colors.black87),
          style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black, fontSize: 15),
          isExpanded: true,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedBusinessType = newValue;
              });
            }
          },
          items: _businessTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPendingState(bool isDark, String businessName, String businessType) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_empty_rounded,
              color: AppColors.yellowColor,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              'request_pending_title'.tr() == 'request_pending_title'
                  ? 'Request Pending Review'
                  : 'request_pending_title'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'request_pending_desc'.tr() == 'request_pending_desc'
                  ? 'Thank you for submitting your application. Our team is currently reviewing your details. We will contact you shortly.'
                  : 'request_pending_desc'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2F46) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Column(
                children: [
                  _buildStatusRow('Business Name:', businessName, isDark),
                  const Divider(height: 20),
                  _buildStatusRow('Business Type:', businessType, isDark),
                  const Divider(height: 20),
                  _buildStatusRow('Status:', 'Pending', isDark, isStatus: true, statusColor: AppColors.yellowColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              'request_approved_title'.tr() == 'request_approved_title'
                  ? 'Application Approved!'
                  : 'request_approved_title'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'request_approved_desc'.tr() == 'request_approved_desc'
                  ? 'Congratulations! Your provider permissions are now active. You can manage services from your provider dashboard.'
                  : 'request_approved_desc'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () async {
                await CacheHelper.saveData(key: 'role', value: 'provider');
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.serviceProviderRouteName,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Open Provider Dashboard',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedState(bool isDark, String reason) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cancel_outlined,
              color: Colors.redAccent,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              'request_rejected_title'.tr() == 'request_rejected_title'
                  ? 'Application Rejected'
                  : 'request_rejected_title'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'request_rejected_desc'.tr() == 'request_rejected_desc'
                  ? 'Unfortunately, your provider request was not approved. You can review the reason below and submit a new application.'
                  : 'request_rejected_desc'.tr(),
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rejection Reason:',
                    style: GoogleFonts.inter(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reason,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // To allow re-submission, emit standard state or clear form
                setState(() {
                  _businessNameController.clear();
                  _businessDescriptionController.clear();
                  _contactNumberController.clear();
                  _emailController.clear();
                  _taxNumberController.clear();
                  _registrationNumberController.clear();
                  _documentUrlController.clear();
                });
                context.read<ProviderRequestCubit>().emit(ProviderRequestInitial());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Reapply Now',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, bool isDark, {bool isStatus = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white60 : Colors.black54,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: isStatus ? (statusColor ?? Colors.green) : (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
