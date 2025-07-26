class Itinerary {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<ItineraryDay> days;

  Itinerary(this.title, this.startDate, this.endDate, this.days);
  // ...
}

class ItineraryDay {
  final DateTime date;
  final String summary;
  final List<ActivityItem> items;

  ItineraryDay(this.date, this.summary, this.items);
  // ...
}

class ActivityItem {
  final String time;
  final String activity;
  final String location;

  ActivityItem(this.time, this.activity, this.location);
}
