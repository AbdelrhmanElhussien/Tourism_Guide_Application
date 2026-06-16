// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_earnings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderEarningsDto _$ProviderEarningsDtoFromJson(Map<String, dynamic> json) =>
    ProviderEarningsDto(
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
      earningsGrowth: json['earningsGrowth'] as String?,
      monthlyOverview: (json['monthlyOverview'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
          ?.map(
            (e) => ProviderTransactionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ProviderEarningsDtoToJson(
  ProviderEarningsDto instance,
) => <String, dynamic>{
  'totalEarnings': instance.totalEarnings,
  'earningsGrowth': instance.earningsGrowth,
  'monthlyOverview': instance.monthlyOverview,
  'recentTransactions': instance.recentTransactions,
};

ProviderTransactionDto _$ProviderTransactionDtoFromJson(
  Map<String, dynamic> json,
) => ProviderTransactionDto(
  title: json['title'] as String?,
  date: json['date'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  isCredit: json['isCredit'] as bool?,
);

Map<String, dynamic> _$ProviderTransactionDtoToJson(
  ProviderTransactionDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'date': instance.date,
  'amount': instance.amount,
  'isCredit': instance.isCredit,
};
