import 'package:flutter/material.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String eventDescription;
  final String eventDate;
  final String eventTime;
  final String eventType;
  final String category;
  final String categoryColor;
  final String image;
  List<String> participants;
  final String untilDate;
  final String day;
  final bool recurring;
  final int rating;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.eventDescription,
    required this.eventDate,
    required this.eventTime,
    required this.eventType,
    required this.category,
    required this.categoryColor,
    required this.image,
    required this.participants,
    required this.untilDate,
    required this.day,
    required this.recurring,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'eventType': eventType,
      'category': category,
      'categoryColor': categoryColor,
      'image': image,
      'participants': participants,
      'untilDate': untilDate,
      'day': day,
      'recurring': recurring,
      'rating': rating,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventDescription: json['eventDescription'],
      eventDate: json['eventDate'],
      eventTime: json['eventTime'],
      eventType: json['eventType'],
      category: json['category'],
      categoryColor: json['categoryColor'],
      image: json['image'],
      participants: List<String>.from(json['participants']),
      untilDate: json['untilDate'],
      day: json['day'],
      recurring: json['recurring'],
      rating: json['rating'],
    );
  }
}
