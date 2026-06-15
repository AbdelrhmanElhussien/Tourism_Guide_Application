import 'package:flutter/material.dart';
import 'package:tourist_app/features/guide/models/guide_model.dart';
import 'package:tourist_app/features/guide/services/guide_service.dart';

class GuideProvider extends ChangeNotifier {
  final GuideService _guideService = GuideService();

  List<GuideModel> _guides = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasFetched = false;

  List<GuideModel> get guides => _guides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _guides.isEmpty && !_isLoading && !hasError;

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

  void clearCache() {
    _hasFetched = false;
    _guides = [];
    _errorMessage = null;
    notifyListeners();
  }
}
