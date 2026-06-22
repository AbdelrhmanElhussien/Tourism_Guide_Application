import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';

class BookGuideBottomSheet extends StatefulWidget {
  final String guideId;
  final String guideName;

  const BookGuideBottomSheet({
    super.key,
    required this.guideId,
    required this.guideName,
  });

  static void show(BuildContext context, String guideId, String guideName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return BookGuideBottomSheet(guideId: guideId, guideName: guideName);
      },
    );
  }

  @override
  State<BookGuideBottomSheet> createState() => _BookGuideBottomSheetState();
}

class _BookGuideBottomSheetState extends State<BookGuideBottomSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _numberOfPeople = 1;
  final TextEditingController _specialRequestsController = TextEditingController();

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);
    
    final DateTime firstDate = isStart ? now : (_startDate ?? now);
    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final themeProvider = Provider.of<Themeprovider>(context, listen: false);
        final isDark = themeProvider.apptheme == ThemeMode.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.yellowColor,
                    onPrimary: Colors.white,
                    surface: AppColors.bottomNavigationColor,
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: AppColors.darkBlueColor,
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.primaryColor,
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
          // Clear end date if it is before the new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _confirmBooking() async {
    if (_startDate == null || _endDate == null) {
      DialogeUtils.showMassage(
        context: context,
        masseage: 'Please select start and end dates',
        title: 'Validation Error',
        posActionName: 'OK',
      );
      return;
    }

    final data = {
      "startDate": _startDate!.toUtc().toIso8601String(),
      "endDate": _endDate!.toUtc().toIso8601String(),
      "numberOfPeople": _numberOfPeople,
      "specialRequests": _specialRequestsController.text.trim().isEmpty
          ? "None"
          : _specialRequestsController.text.trim(),
    };

    try {
      DialogeUtils.showLoading(context: context, text: "loading_msg".tr());
      await context.read<BookingProvider>().bookItem('guide', widget.guideId, data: data);
      DialogeUtils.hideLoading(context: context);
      
      // Close Bottom Sheet
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show Success Dialog
      if (mounted) {
        DialogeUtils.showMassage(
          context: context,
          masseage: 'Your booking for ${widget.guideName} was successful.',
          title: 'Booking Success',
          posActionName: 'OK',
        );
      }
    } catch (e) {
      DialogeUtils.hideLoading(context: context);
      if (mounted) {
        DialogeUtils.showMassage(
          context: context,
          masseage: e.toString().replaceAll('Exception: ', ''),
          title: 'Booking Failed',
          posActionName: 'OK',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    final bgColor = isDark ? AppColors.darkBlueColor : Colors.white;
    final cardColor = isDark ? AppColors.bottomNavigationColor : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : AppColors.blackColor;
    final subTextColor = isDark ? AppColors.blueColor : AppColors.lightGrayColor;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle & Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Tour Guide',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.guideName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.yellowColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: isDark ? Colors.white70 : Colors.black87,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),

            // Date Pickers Row
            Row(
              children: [
                // Start Date
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                              fontSize: 11,
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: isDark ? AppColors.yellowColor : AppColors.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _startDate != null
                                      ? DateFormat('MMM dd, yyyy').format(_startDate!)
                                      : 'Select',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _startDate != null ? textColor : Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // End Date
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: 11,
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: isDark ? AppColors.yellowColor : AppColors.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _endDate != null
                                      ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                      : 'Select',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _endDate != null ? textColor : Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Number of People Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of Guests',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total count of people traveling',
                        style: TextStyle(
                          fontSize: 11,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Minus Button
                      GestureDetector(
                        onTap: _numberOfPeople > 1
                            ? () => setState(() => _numberOfPeople--)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _numberOfPeople > 1
                                ? AppColors.yellowColor.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 18,
                            color: _numberOfPeople > 1
                                ? AppColors.yellowColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _numberOfPeople.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Plus Button
                      GestureDetector(
                        onTap: () => setState(() => _numberOfPeople++),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.yellowColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Special Requests Text Field
            Text(
              'Special Requests (Optional)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _specialRequestsController,
              maxLines: 3,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. Speak specific language dialect, child seat required, etc.',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.blueColor.withOpacity(0.5) : AppColors.lightGrayColor.withOpacity(0.7),
                  fontSize: 13,
                ),
                fillColor: cardColor,
                filled: true,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
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
            ),
            const SizedBox(height: 24),

            // Confirm Button
            ElevatedButton(
              onPressed: (_startDate != null && _endDate != null) ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowColor,
                disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
