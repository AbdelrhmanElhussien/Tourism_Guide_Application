import 'package:flutter/material.dart';
import 'package:tourist_app/features/explore/models/transport_model.dart';
import 'package:tourist_app/features/explore/services/transport_service.dart';

class TransportProvider extends ChangeNotifier {
  final TransportService _transportService = TransportService();

  List<TransportModel> _transports = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasFetched = false;

  List<TransportModel> get transports => _transports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _transports.isEmpty && !_isLoading && !hasError;

  Future<void> fetchTransports({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transports = await _transportService.fetchTransports();
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
    _transports = [];
    _errorMessage = null;
    notifyListeners();
  }
}
