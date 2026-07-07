import 'package:equatable/equatable.dart';

class Country extends Equatable {
  const Country({required this.id, required this.name});
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class Region extends Equatable {
  const Region({required this.id, required this.countryId, required this.name});
  final String id;
  final String countryId;
  final String name;

  @override
  List<Object?> get props => [id, countryId, name];
}
