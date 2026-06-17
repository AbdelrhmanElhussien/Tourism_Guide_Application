import 'package:json_annotation/json_annotation.dart';

part 'provider_request_response_dto.g.dart';

@JsonSerializable()
class ProviderRequestResponseDto {
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "data")
  final ProviderRequestDataDto? data;

  ProviderRequestResponseDto({
    this.success,
    this.data,
  });

  factory ProviderRequestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderRequestResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderRequestResponseDtoToJson(this);
}

@JsonSerializable()
class ProviderRequestDataDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "businessName")
  final String? businessName;
  @JsonKey(name: "businessType")
  final String? businessType;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "submittedAt")
  final String? submittedAt;
  @JsonKey(name: "reviewedAt")
  final String? reviewedAt;
  @JsonKey(name: "rejectionReason")
  final String? rejectionReason;

  ProviderRequestDataDto({
    this.id,
    this.businessName,
    this.businessType,
    this.status,
    this.submittedAt,
    this.reviewedAt,
    this.rejectionReason,
  });

  factory ProviderRequestDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderRequestDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderRequestDataDtoToJson(this);
}
