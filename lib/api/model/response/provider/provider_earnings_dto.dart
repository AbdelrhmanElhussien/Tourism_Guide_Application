import 'package:json_annotation/json_annotation.dart';

part 'provider_earnings_dto.g.dart';

@JsonSerializable()
class ProviderEarningsDto {
  @JsonKey(name: "totalEarnings")
  final double? totalEarnings;
  @JsonKey(name: "earningsGrowth")
  final String? earningsGrowth;
  @JsonKey(name: "monthlyOverview")
  final List<double>? monthlyOverview;
  @JsonKey(name: "recentTransactions")
  final List<ProviderTransactionDto>? recentTransactions;

  ProviderEarningsDto({
    this.totalEarnings,
    this.earningsGrowth,
    this.monthlyOverview,
    this.recentTransactions,
  });

  factory ProviderEarningsDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderEarningsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderEarningsDtoToJson(this);
}

@JsonSerializable()
class ProviderTransactionDto {
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "isCredit")
  final bool? isCredit;

  ProviderTransactionDto({
    this.title,
    this.date,
    this.amount,
    this.isCredit,
  });

  factory ProviderTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderTransactionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderTransactionDtoToJson(this);
}
