// lib/features/home/models/location_models.dart

import 'package:equatable/equatable.dart';

enum ElectionTier {
  local,
  state,
  federal,
}

extension ElectionTierX on ElectionTier {
  String get displayName {
    switch (this) {
      case ElectionTier.local:
        return 'Local';
      case ElectionTier.state:
        return 'State';
      case ElectionTier.federal:
        return 'Federal';
    }
  }
}

class Country extends Equatable {
  const Country({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class Region extends Equatable {
  const Region({
    required this.id,
    required this.countryId,
    required this.name,
  });

  final String id;
  final String countryId;
  final String name;

  @override
  List<Object?> get props => [id, countryId, name];
}
