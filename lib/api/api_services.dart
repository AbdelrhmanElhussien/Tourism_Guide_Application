import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/api/model/request/login/login_request_dto.dart';
import 'package:tourist_app/api/model/request/register/register_request_dto.dart';
import 'package:tourist_app/api/model/response/auth/auth_response_dto.dart';
import 'package:tourist_app/api/model/response/profile/place_dto.dart';
import 'package:tourist_app/api/model/response/trips/trip_dto.dart';

import 'package:tourist_app/api/model/request/trips/create_trip_request_dto.dart';
import 'package:tourist_app/api/model/request/trips/create_activity_request_dto.dart';

import 'package:tourist_app/api/model/request/provider/create_service_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_booking_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_dashboard_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_earnings_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_service_dto.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiServices {
  factory ApiServices(Dio dio, {String? baseUrl}) = _ApiServices;

  @POST(ApiConstant.signInEndPoint)
  Future<Auth_response_dto> login(@Body() LoginRequestDto loginRequest);

  @POST(ApiConstant.signUpEndPoint)
  Future<Auth_response_dto> signUp(@Body() RegisterRequestDto registerRequest);

  @GET(ApiConstant.getUsernameEndPoint)
  Future<String> getUsername();

  @GET('user/places/saved')
  Future<List<PlaceDto>> getSavedPlaces();

  @POST('user/places/saved/{placeId}')
  Future<void> savePlace(@Path('placeId') String placeId);

  @DELETE('user/places/saved/{placeId}')
  Future<void> unsavePlace(@Path('placeId') String placeId);

  @GET('user/places/visited')
  Future<List<PlaceDto>> getVisitedPlaces();

  @POST('user/places/visited/{placeId}')
  Future<void> visitPlace(@Path('placeId') String placeId);

  @GET('Trips')
  Future<List<TripDto>> getTrips();

  @POST('Trips')
  Future<TripDto> createTrip(@Body() CreateTripRequestDto request);

  @GET('Trips/{id}')
  Future<TripDto> getTripById(@Path('id') String id);

  @PUT('Trips/{id}')
  Future<TripDto> updateTrip(@Path('id') String id, @Body() CreateTripRequestDto request);

  @DELETE('Trips/{id}')
  Future<void> deleteTrip(@Path('id') String id);

  @POST('Trips/{tripId}/days/{dayId}/activities')
  Future<TripActivityDto> addActivity(
    @Path('tripId') String tripId,
    @Path('dayId') String dayId,
    @Body() CreateActivityRequestDto request,
  );

  @DELETE('Trips/{tripId}/activities/{activityId}')
  Future<void> deleteActivity(
    @Path('tripId') String tripId,
    @Path('activityId') String activityId,
  );

  // ── Service Provider Endpoints ──

  @GET('provider/dashboard')
  Future<ProviderDashboardDto> getProviderDashboard();

  @GET('provider/services')
  Future<List<ProviderServiceDto>> getProviderServices();

  @POST('provider/services')
  Future<ProviderServiceDto> createProviderService(@Body() CreateServiceRequestDto request);

  @GET('provider/services/{id}')
  Future<ProviderServiceDto> getProviderServiceById(@Path('id') String id);

  @PUT('provider/services/{id}')
  Future<ProviderServiceDto> updateProviderService(@Path('id') String id, @Body() CreateServiceRequestDto request);

  @DELETE('provider/services/{id}')
  Future<void> deleteProviderService(@Path('id') String id);

  @GET('provider/bookings')
  Future<List<ProviderBookingDto>> getProviderBookings();

  @PUT('provider/bookings/{id}/status')
  Future<ProviderBookingDto> updateBookingStatus(@Path('id') String id, @Query('status') String status);

  @POST('provider/request')
  Future<void> submitProviderRequest();

  @GET('provider/request/my')
  Future<dynamic> getMyProviderRequest();

  @GET('provider/earnings')
  Future<ProviderEarningsDto> getProviderEarnings();

  @PUT('provider/bookings/{id}/confirm')
  Future<ProviderBookingDto> confirmBooking(@Path('id') String id);

  @PUT('provider/bookings/{id}/decline')
  Future<ProviderBookingDto> declineBooking(@Path('id') String id);

  @PUT('provider/bookings/{id}/complete')
  Future<ProviderBookingDto> completeBooking(@Path('id') String id);

  @POST('provider/bookings/{id}/contact')
  Future<void> contactBooking(@Path('id') String id);
}
