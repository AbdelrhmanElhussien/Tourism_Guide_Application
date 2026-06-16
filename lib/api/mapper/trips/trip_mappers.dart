import 'package:tourist_app/api/model/response/trips/trip_dto.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';

extension TripDtoMapper on TripDto {
  Trip toTrip() {
    return Trip(
      id: id ?? '',
      title: title ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      notes: notes ?? '',
      days: days?.map((d) => d.toTripDay()).toList() ?? [],
    );
  }
}

extension TripDayDtoMapper on TripDayDto {
  TripDay toTripDay() {
    return TripDay(
      id: id ?? '',
      dayNumber: dayNumber ?? 0,
      date: date ?? '',
      activities: activities?.map((a) => a.toTripActivity()).toList() ?? [],
    );
  }
}

extension TripActivityDtoMapper on TripActivityDto {
  TripActivity toTripActivity() {
    return TripActivity(
      id: id ?? '',
      title: title ?? '',
      time: time ?? '',
      notes: notes ?? '',
      imageUrl: imageUrl ?? '',
    );
  }
}
