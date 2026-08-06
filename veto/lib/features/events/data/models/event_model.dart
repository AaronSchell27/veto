// lib/features/events/data/models/event_model.dart

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.id,
    required this.name,
    required this.location,
    required this.startTime,
    this.endTime,
    this.description,
  });

  /// Factory constructor to parse PostgreSQL `timestamptz` values.
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String).toLocal()
          : null,
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String location;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime?.toUtc().toIso8601String(),
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        startTime,
        endTime,
        description,
      ];
}
