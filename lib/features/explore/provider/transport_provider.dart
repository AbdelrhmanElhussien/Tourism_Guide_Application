import 'package:flutter/material.dart';
import 'package:tourist_app/features/explore/models/transport_model.dart';
import 'package:tourist_app/features/explore/services/transport_service.dart';

class TransportProvider extends ChangeNotifier {
  final TransportService _transportService = TransportService();

  List<TransportModel> _transports = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;
  bool _hasFetched = false;
  
  int _currentPage = 1;
  bool _hasMore = true;
  static const int _limit = 10;

  List<TransportModel> get transports => _transports;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _transports.isEmpty && !_isLoading && !hasError;
  bool get hasMore => _hasMore;

  Future<void> fetchTransports({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final newItems = await _transportService.fetchTransports(page: _currentPage, limit: _limit);
      _transports = newItems;
      _hasFetched = true;
      if (newItems.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreTransports() async {
    if (_isFetchingMore || !_hasMore || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newItems = await _transportService.fetchTransports(page: _currentPage, limit: _limit);
      
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        final existingIds = _transports.map((item) => item.id).toSet();
        final uniqueNewItems = newItems.where((item) => !existingIds.contains(item.id)).toList();
        if (uniqueNewItems.isEmpty) {
          _hasMore = false;
        } else {
          _transports.addAll(uniqueNewItems);
          if (newItems.length < _limit) {
            _hasMore = false;
          }
        }
      }
    } catch (e) {
      _currentPage--;
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  TransportModel? _selectedTransportDetails;
  bool _isLoadingDetails = false;
  String? _errorMessageDetails;

  TransportModel? get selectedTransportDetails => _selectedTransportDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessageDetails => _errorMessageDetails;

  Future<void> fetchTransportDetails(String id, {bool forceRefresh = false}) async {
    if (_selectedTransportDetails?.id == id && !forceRefresh) return;

    _isLoadingDetails = true;
    _errorMessageDetails = null;
    notifyListeners();

    try {
      final details = await _transportService.fetchTransportDetails(id);
      _selectedTransportDetails = details;
    } catch (e) {
      _errorMessageDetails = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetched = false;
    _transports = [];
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    _selectedTransportDetails = null;
    _isLoadingDetails = false;
    _errorMessageDetails = null;
    notifyListeners();
  }
}
