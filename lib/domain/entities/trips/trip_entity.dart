class Trip {
  final String id;
  final String title;
  final String startDate;
  final String endDate;
  final String notes;
  final List<TripDay> days;

  Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.notes,
    this.days = const [],
  });
}

class TripDay {
  final String id;
  final int dayNumber;
  final String date;
  final List<TripActivity> activities;

  TripDay({
    required this.id,
    required this.dayNumber,
    required this.date,
    this.activities = const [],
  });
}

class TripActivity {
  final String id;
  final String title;
  final String time;
  final String notes;
  final String imageUrl;

  TripActivity({
    required this.id,
    required this.title,
    required this.time,
    required this.notes,
    required this.imageUrl,
  });
}
