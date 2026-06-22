import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/model/request/provider/create_service_request_dto.dart';
import 'package:tourist_app/api/model/request/provider/update_service_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_booking_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_dashboard_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_earnings_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_service_dto.dart';
import 'package:tourist_app/data/data_sources/remot/provider/provider_remote_data_source.dart';

import 'package:dio/dio.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/api/model/request/provider/provider_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_request_response_dto.dart';

@Injectable(as: ProviderRemoteDataSource)
class ProviderRemoteDataSourceImpl implements ProviderRemoteDataSource {
  final ApiServices _apiServices;

  ProviderRemoteDataSourceImpl(this._apiServices);

  @override
  Future<ProviderDashboardDto> getProviderDashboard() async {
    return await _apiServices.getProviderDashboard();
  }

  String _getApiSegment(String category) {
    switch (category.toLowerCase()) {
      case 'transport':
      case 'transportation':
        return 'Transport';
      case 'program':
      case 'programs':
        return 'Programs';
      case 'hotel':
      case 'hotels':
        return 'Hotels';
      case 'guide':
      case 'guides':
        return 'Guides';
      default:
        return 'Services';
    }
  }

  @override
  Future<List<ProviderServiceDto>> getProviderServices() async {
    final dio = getIt<Dio>();
    final categories = ['Transport', 'Programs', 'Hotels', 'Guides'];
    final List<ProviderServiceDto> allServices = [];

    for (final category in categories) {
      try {
        final response = await dio.get('${category}/my');
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          List<dynamic> itemsList = [];
          if (data is List) {
            itemsList = data;
          } else if (data is Map<String, dynamic>) {
            final dynamic dataField = data['data'];
            if (dataField != null) {
              if (dataField is List) {
                itemsList = dataField;
              } else if (dataField is Map<String, dynamic>) {
                itemsList = [dataField];
              }
            } else if (data['success'] == true) {
              // success without data field: empty list
            } else {
              itemsList = [data];
            }
          }

          for (final item in itemsList) {
            if (item is Map<String, dynamic>) {
              final String itemCategory;
              if (category.toLowerCase() == 'transport') {
                itemCategory = 'transportation';
              } else if (category.toLowerCase() == 'hotels') {
                itemCategory = 'hotel';
              } else if (category.toLowerCase() == 'programs') {
                itemCategory = 'program';
              } else if (category.toLowerCase() == 'guides') {
                itemCategory = 'guide';
                // Map Guide fields to ProviderServiceDto fields
                if (item['title'] == null && item['fullName'] != null) {
                  item['title'] = item['fullName'];
                }
                if (item['price'] == null && item['pricePerDay'] != null) {
                  item['price'] = item['pricePerDay'];
                }
                if (item['location'] == null && item['nationality'] != null) {
                  item['location'] = item['nationality'];
                }
                if (item['availability'] == null && item['languages'] != null) {
                  item['availability'] = item['languages'];
                }
              } else {
                itemCategory = category.toLowerCase();
              }
              item['category'] = itemCategory;
              allServices.add(ProviderServiceDto.fromJson(item));
            }
          }
        }
      } catch (e) {
        print('Error fetching services for $category: $e');
      }
    }
    return allServices;
  }


  @override
  Future<ProviderServiceDto> updateProviderService(
    String id,
    String category,
    UpdateServiceRequestDto request,
  ) async {
    final dio = getIt<Dio>();
    final apiSegment = _getApiSegment(category);
    final response = await dio.put(
      '${apiSegment}/$id',
      data: request.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        return ProviderServiceDto.fromJson(response.data);
      }
      return ProviderServiceDto(id: id, category: category);
    }
    throw Exception(
      'Failed to update service (Status: ${response.statusCode})',
    );
  }

  @override
  Future<void> deleteProviderService(String id, String category) async {
    final dio = getIt<Dio>();
    final apiSegment = _getApiSegment(category);
    final response = await dio.delete('${apiSegment}/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete service (Status: ${response.statusCode})',
      );
    }
  }

  @override
  Future<void> createCategorizedService(
    String category,
    Map<String, dynamic> data,
  ) async {
    final dio = getIt<Dio>();
    String endpoint;
    switch (category.toLowerCase()) {
      case 'guide':
        endpoint = 'Guides';
        break;
      case 'hotel':
      case 'hotels':
        endpoint = 'Hotels';
        break;
      case 'transport':
      case 'transportation':
        endpoint = 'Transport';
        break;
      case 'program':
      case 'programs':
        endpoint = 'Programs';
        break;
      default:
        throw Exception('Unknown category: $category');
    }

    final response = await dio.post(
      endpoint,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception('Failed to add service (Status: ${response.statusCode})');
    }
  }

  @override
  Future<void> updateCategorizedService(
    String id,
    String category,
    Map<String, dynamic> data,
  ) async {
    final dio = getIt<Dio>();
    String endpoint;
    switch (category.toLowerCase()) {
      case 'guide':
        endpoint = 'Guides';
        break;
      case 'hotel':
      case 'hotels':
        endpoint = 'Hotels';
        break;
      case 'transport':
      case 'transportation':
        endpoint = 'Transport';
        break;
      case 'program':
      case 'programs':
        endpoint = 'Programs';
        break;
      default:
        throw Exception('Unknown category: $category');
    }

    final response = await dio.put(
      '$endpoint/$id',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception('Failed to update service (Status: ${response.statusCode})');
    }
  }

  @override
  Future<List<ProviderBookingDto>> getProviderBookings() async {
    return await _apiServices.getProviderBookings();
  }

  @override
  Future<ProviderBookingDto> updateBookingStatus(
    String id,
    String status,
  ) async {
    return await _apiServices.updateBookingStatus(id, {'status': status});
  }

  @override
  Future<void> submitProviderRequest(ProviderRequestDto request) async {
    await _apiServices.submitProviderRequest(request);
  }

  @override
  Future<ProviderRequestResponseDto> getMyProviderRequest() async {
    return await _apiServices.getMyProviderRequest();
  }

  @override
  Future<ProviderEarningsDto> getProviderEarnings() async {
    return await _apiServices.getProviderEarnings();
  }

  @override
  Future<ProviderBookingDto> confirmBooking(String id) async {
    return await _apiServices.confirmBooking(id);
  }

  @override
  Future<ProviderBookingDto> declineBooking(String id) async {
    return await _apiServices.declineBooking(id);
  }

  @override
  Future<ProviderBookingDto> completeBooking(String id) async {
    return await _apiServices.completeBooking(id);
  }

  @override
  Future<void> contactBooking(String id, String message) async {
    await _apiServices.contactBooking(id, {
      "bookingId": id,
      "message": message,
    });
  }
}
