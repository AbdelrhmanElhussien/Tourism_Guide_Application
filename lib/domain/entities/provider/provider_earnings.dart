class ProviderEarnings {
  final double totalEarnings;
  final String earningsGrowth;
  final List<double> monthlyOverview;
  final List<ProviderTransaction> recentTransactions;

  ProviderEarnings({
    required this.totalEarnings,
    required this.earningsGrowth,
    required this.monthlyOverview,
    required this.recentTransactions,
  });
}

class ProviderTransaction {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  ProviderTransaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}
