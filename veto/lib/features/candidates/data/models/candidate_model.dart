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
    this.stances = const [],
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

    final stancesJson = json['stances'] as List<dynamic>?;

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
      stances: stancesJson != null
          ? stancesJson
              .map((e) => CandidateStance.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
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
  final List<CandidateStance> stances;

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
        stances,
      ];
}

class CandidateStance extends Equatable {
  const CandidateStance({
    required this.issueName,
    required this.agree,
    required this.statement,
    this.issueDescription,
  });

  factory CandidateStance.fromJson(Map<String, dynamic> json) {
    // Cast nested issues join table map to prevent avoid_dynamic_calls lint error
    final issuesMap = json['issues'] as Map<String, dynamic>?;

    return CandidateStance(
      issueName: json['issue_name'] as String? ??
          issuesMap?['name'] as String? ??
          '',
      agree: json['agree'] as bool? ?? true,
      statement: json['statement'] as String? ?? '',
      issueDescription: json['issue_description'] as String? ??
          issuesMap?['description'] as String?,
    );
  }

  final String issueName;
  final bool agree;
  final String statement;
  final String? issueDescription;

  @override
  List<Object?> get props => [issueName, agree, statement, issueDescription];
}
