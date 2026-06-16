import 'package:flutter/material.dart';
import 'package:tourist_app/features/explore/models/program_model.dart';
import 'package:tourist_app/features/explore/services/program_service.dart';

class ProgramProvider extends ChangeNotifier {
  final ProgramService _programService = ProgramService();

  List<ProgramModel> _programs = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;
  bool _hasFetched = false;
  
  int _currentPage = 1;
  bool _hasMore = true;
  static const int _limit = 10;

  List<ProgramModel> get programs => _programs;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _programs.isEmpty && !_isLoading && !hasError;
  bool get hasMore => _hasMore;

  Future<void> fetchPrograms({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final newItems = await _programService.fetchPrograms(page: _currentPage, limit: _limit);
      _programs = newItems;
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
  
  Future<void> fetchMorePrograms() async {
    if (_isFetchingMore || !_hasMore || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newItems = await _programService.fetchPrograms(page: _currentPage, limit: _limit);
      
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _programs.addAll(newItems);
        if (newItems.length < _limit) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _currentPage--; // Revert page count on error
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  ProgramModel? _selectedProgramDetails;
  bool _isLoadingDetails = false;
  String? _errorMessageDetails;

  ProgramModel? get selectedProgramDetails => _selectedProgramDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessageDetails => _errorMessageDetails;

  Future<void> fetchProgramDetails(String id, {bool forceRefresh = false}) async {
    if (_selectedProgramDetails?.id == id && !forceRefresh) return;

    _isLoadingDetails = true;
    _errorMessageDetails = null;
    notifyListeners();

    try {
      final details = await _programService.fetchProgramDetails(id);
      _selectedProgramDetails = details;
    } catch (e) {
      _errorMessageDetails = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetched = false;
    _programs = [];
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    _selectedProgramDetails = null;
    _isLoadingDetails = false;
    _errorMessageDetails = null;
    notifyListeners();
  }
}
