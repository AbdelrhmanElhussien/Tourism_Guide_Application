import 'package:json_annotation/json_annotation.dart';

part 'provider_request_dto.g.dart';

@JsonSerializable()
class ProviderRequestDto {
  @JsonKey(name: "businessName")
  final String? businessName;
  @JsonKey(name: "businessType")
  final String? businessType;
  @JsonKey(name: "businessDescription")
  final String? businessDescription;
  @JsonKey(name: "contactNumber")
  final String? contactNumber;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "taxNumber")
  final String? taxNumber;
  @JsonKey(name: "registrationNumber")
  final String? registrationNumber;
  @JsonKey(name: "documentUrl")
  final String? documentUrl;

  ProviderRequestDto({
    this.businessName,
    this.businessType,
    this.businessDescription,
    this.contactNumber,
    this.email,
    this.taxNumber,
    this.registrationNumber,
    this.documentUrl,
  });

  factory ProviderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderRequestDtoToJson(this);
}
