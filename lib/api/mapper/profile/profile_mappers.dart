import 'package:tourist_app/api/model/response/profile/place_dto.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

extension PlaceDtoMapper on PlaceDto {
  TourismDestination toTourismDestination() {
    return TourismDestination(
      id: id,
      title: name ?? '',
      location: address ?? '',
      rating: rating ?? 0.0,
      reviews: 0,
      category: category ?? '',
      networkImage: imageUrl,
    );
  }
}
