import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/profile/admin/cubits/admin_provider_requests_cubit.dart';
import 'package:tourist_app/features/profile/admin/cubits/admin_provider_requests_states.dart';
import 'package:tourist_app/features/profile/admin/models/admin_provider_request.dart';

class AdminProviderRequestsScreen extends StatelessWidget {
  const AdminProviderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isLight = themeProvider.apptheme == ThemeMode.light;

    return BlocProvider(
      create: (context) =>
          AdminProviderRequestsCubit(getIt<Dio>())..fetchRequests(),
      child: Scaffold(
        backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocConsumer<AdminProviderRequestsCubit,
                    AdminProviderRequestsState>(
                  listener: (context, state) {
                    if (state is AdminProviderRequestDetailsLoaded) {
                      _showRequestDetails(
                        context,
                        state.selectedRequest,
                        isLight,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AdminProviderRequestsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (state is AdminProviderRequestsError) {
                      return _buildError(context, state.errorMsg, isLight);
                    }

                    final requests = _requestsFromState(state);
                    final isLoadingDetails =
                        state is AdminProviderRequestDetailsLoading;

                    return Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () => context
                              .read<AdminProviderRequestsCubit>()
                              .fetchRequests(),
                          child: requests.isEmpty
                              ? _buildEmptyState(isLight)
                              : ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(16),
                                  itemBuilder: (context, index) {
                                    return _buildRequestCard(
                                      context,
                                      requests[index],
                                      isLight,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemCount: requests.length,
                                ),
                        ),
                        if (isLoadingDetails)
                          Container(
                            color: Colors.black.withOpacity(0.08),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
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
              'Admin Panel',
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

  Widget _buildRequestCard(
    BuildContext context,
    AdminProviderRequest request,
    bool isLight,
  ) {
    final statusColor = _statusColor(request.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context
            .read<AdminProviderRequestsCubit>()
            .fetchRequestDetails(request.id),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.bottomNavigationColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLight ? Colors.black.withOpacity(0.05) : Colors.white10,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isLight ? 0.03 : 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business_center_outlined,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.businessName.isEmpty
                          ? 'Unnamed Business'
                          : request.businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: isLight ? AppColors.primaryColor : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.businessType.isEmpty
                          ? 'Provider request'
                          : request.businessType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: isLight ? Colors.grey[600] : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(request.status, statusColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    final label = status.isEmpty ? 'Pending' : status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isLight) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 160),
        Icon(
          Icons.assignment_outlined,
          color: isLight ? AppColors.primaryColor : AppColors.blueColor,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          'No provider requests yet',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: isLight ? AppColors.primaryColor : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message, bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: isLight ? Colors.black : Colors.white),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () =>
                  context.read<AdminProviderRequestsCubit>().fetchRequests(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDetails(
    BuildContext context,
    AdminProviderRequest request,
    bool isLight,
  ) {
    final cubit = context.read<AdminProviderRequestsCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isLight ? Colors.white : AppColors.bottomNavigationColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isLight ? Colors.black12 : Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  request.businessName.isEmpty
                      ? 'Provider Request'
                      : request.businessName,
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                _buildDetailRow('Status', request.status, isLight),
                _buildDetailRow('Business Type', request.businessType, isLight),
                _buildDetailRow('Description', request.businessDescription, isLight),
                _buildDetailRow('Contact Number', request.contactNumber, isLight),
                _buildDetailRow('Email', request.email, isLight),
                _buildDetailRow('Tax Number', request.taxNumber, isLight),
                _buildDetailRow(
                  'Registration Number',
                  request.registrationNumber,
                  isLight,
                ),
                _buildDetailRow('Document URL', request.documentUrl, isLight),
                _buildDetailRow('Submitted At', request.submittedAt, isLight),
                _buildDetailRow('Reviewed At', request.reviewedAt, isLight),
                _buildDetailRow(
                  'Rejection Reason',
                  request.rejectionReason,
                  isLight,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: request.id.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context);
                                cubit.rejectRequest(request.id);
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: request.id.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context);
                                cubit.approveRequest(request.id);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Approve'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isLight) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isLight ? Colors.grey[600] : Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<AdminProviderRequest> _requestsFromState(
    AdminProviderRequestsState state,
  ) {
    if (state is AdminProviderRequestsLoaded) return state.requests;
    if (state is AdminProviderRequestDetailsLoading) return state.requests;
    if (state is AdminProviderRequestDetailsLoaded) return state.requests;
    return const [];
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
      case 'declined':
        return Colors.redAccent;
      default:
        return AppColors.yellowColor;
    }
  }
}
