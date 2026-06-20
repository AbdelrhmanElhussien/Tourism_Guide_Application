// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderRequestDto _$ProviderRequestDtoFromJson(Map<String, dynamic> json) =>
    ProviderRequestDto(
      businessName: json['businessName'] as String?,
      businessType: json['businessType'] as String?,
      businessDescription: json['businessDescription'] as String?,
      contactNumber: json['contactNumber'] as String?,
      email: json['email'] as String?,
      taxNumber: json['taxNumber'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      documentUrl: json['documentUrl'] as String?,
    );

Map<String, dynamic> _$ProviderRequestDtoToJson(ProviderRequestDto instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'businessDescription': instance.businessDescription,
      'contactNumber': instance.contactNumber,
      'email': instance.email,
      'taxNumber': instance.taxNumber,
      'registrationNumber': instance.registrationNumber,
      'documentUrl': instance.documentUrl,
    };
