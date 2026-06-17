// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_request_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderRequestResponseDto _$ProviderRequestResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProviderRequestResponseDto(
  success: json['success'] as bool?,
  data: json['data'] == null
      ? null
      : ProviderRequestDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProviderRequestResponseDtoToJson(
  ProviderRequestResponseDto instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

ProviderRequestDataDto _$ProviderRequestDataDtoFromJson(
  Map<String, dynamic> json,
) => ProviderRequestDataDto(
  id: json['id'] as String?,
  businessName: json['businessName'] as String?,
  businessType: json['businessType'] as String?,
  status: json['status'] as String?,
  submittedAt: json['submittedAt'] as String?,
  reviewedAt: json['reviewedAt'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
);

Map<String, dynamic> _$ProviderRequestDataDtoToJson(
  ProviderRequestDataDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessName': instance.businessName,
  'businessType': instance.businessType,
  'status': instance.status,
  'submittedAt': instance.submittedAt,
  'reviewedAt': instance.reviewedAt,
  'rejectionReason': instance.rejectionReason,
};
