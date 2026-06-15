import 'package:flutter/material.dart';
import 'package:tourist_app/features/guide/models/guide_model.dart';
import 'package:tourist_app/features/guide/services/guide_service.dart';

/// Provider for managing guide data state.
/// Follows the same [ChangeNotifier] pattern as [MapProvider].
class GuideProvider extends ChangeNotifier {
  final GuideService _guideService = GuideService();

  List<GuideModel> _guides = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasFetched = false;

  // ── Getters ──
  List<GuideModel> get guides => _guides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _guides.isEmpty && !_isLoading && !hasError;

  /// Fetches guides from the API.
  /// Skips re-fetching if data is already loaded (unless [forceRefresh] is true).
  Future<void> fetchGuides({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guides = await _guideService.fetchGuides();
      _hasFetched = true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the cached data so next fetch will call the API again.
  void clearCache() {
    _hasFetched = false;
    _guides = [];
    _errorMessage = null;
    notifyListeners();
  }
}
