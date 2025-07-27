import 'dart:convert';

// Helper function to decode the main JSON string
Itinerary itineraryFromJson(String str) => Itinerary.fromJson(json.decode(str));

class Itinerary {
    final String title;
    final String startDate;
    final String endDate;
    final List<Day> days;

    Itinerary({
        required this.title,
        required this.startDate,
        required this.endDate,
        required this.days,
    });

    // This factory constructor parses the JSON map into an Itinerary object
    factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        title: json["title"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
    );
}

class Day {
    final String date;
    final String summary;
    final List<Item> items;

    Day({
        required this.date,
        required this.summary,
        required this.items,
    });

    factory Day.fromJson(Map<String, dynamic> json) => Day(
        date: json["date"],
        summary: json["summary"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );
}

class Item {
    final String time;
    final String activity;
    final String location; // Storing as "lat,lng" string as per JSON

    Item({
        required this.time,
        required this.activity,
        required this.location,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        time: json["time"],
        activity: json["activity"],
        location: json["location"],
    );
}