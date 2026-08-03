// lib/features/candidates/data/models/candidate_model.dart

import 'package:equatable/equatable.dart';

class Candidate extends Equatable {
  const Candidate({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryId,
    required this.party,
    required this.role,
    this.stateId,
    this.city,
    this.photoUrl,
  });

  factory Candidate.fromJson(
    Map<String, dynamic> json, {
    String? bucketPublicUrlBase,
  }) {
    final rawPictureUrl =
        json['picture_url'] as String? ?? json['photo_url'] as String?;

    var resolvedPhotoUrl = rawPictureUrl;
    if (rawPictureUrl != null &&
        !rawPictureUrl.startsWith('http') &&
        bucketPublicUrlBase != null) {
      resolvedPhotoUrl = '$bucketPublicUrlBase/$rawPictureUrl';
    }

    return Candidate(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      countryId: (json['country_id'] ?? json['country']) as String,
      stateId: json['state_id'] as String?,
      city: json['city'] as String?,
      party: json['party'] as String,
      role: json['role'] as String? ?? 'Candidate',
      photoUrl: resolvedPhotoUrl,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String countryId;
  final String? stateId;
  final String? city;
  final String party;
  final String role;
  final String? photoUrl;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        countryId,
        stateId,
        city,
        party,
        role,
        photoUrl,
      ];
}
