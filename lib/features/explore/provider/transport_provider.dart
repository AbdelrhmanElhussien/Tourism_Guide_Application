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
        _transports.addAll(newItems);
        if (newItems.length < _limit) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _currentPage--;
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetched = false;
    _transports = [];
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
}
