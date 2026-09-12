// lib/features/candidates/data/models/candidate_model.dart

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:veto/features/home/models/location_models.dart';

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
    this.tier,
    this.stances = const [],
    this.positions = const [],
  });

  factory Candidate.fromJson(
    Map<String, dynamic> json, {
    String? bucketPublicUrlBase,
  }) {
    // Check all potential database schema key variations
    final rawPictureUrl = json['picture_url'] as String? ??
        json['photo_url'] as String? ??
        json['avatar_url'] as String? ??
        json['image_url'] as String?;

    var resolvedPhotoUrl = rawPictureUrl?.trim();

    // If string is non-empty and relative, append bucket base URL if provided
    if (resolvedPhotoUrl != null &&
        resolvedPhotoUrl.isNotEmpty &&
        !resolvedPhotoUrl.startsWith('http://') &&
        !resolvedPhotoUrl.startsWith('https://') &&
        bucketPublicUrlBase != null) {
      final cleanBase = bucketPublicUrlBase.endsWith('/')
          ? bucketPublicUrlBase.substring(0, bucketPublicUrlBase.length - 1)
          : bucketPublicUrlBase;
      final cleanPath = resolvedPhotoUrl.startsWith('/')
          ? resolvedPhotoUrl.substring(1)
          : resolvedPhotoUrl;
      resolvedPhotoUrl = '$cleanBase/$cleanPath';
    }

    final stancesJson = json['stances'] as List<dynamic>?;
    final positionsJson = json['positions'] as List<dynamic>?;

    ElectionTier? parsedTier;
    final rawTier = json['tier'] as String? ?? json['jurisdiction'] as String?;
    if (rawTier != null) {
      final cleanTier = rawTier.toLowerCase().trim();
      if (cleanTier.contains('federal') || cleanTier.contains('national')) {
        parsedTier = ElectionTier.federal;
      } else if (cleanTier.contains('state')) {
        parsedTier = ElectionTier.state;
      } else if (cleanTier.contains('local') ||
          cleanTier.contains('city') ||
          cleanTier.contains('county')) {
        parsedTier = ElectionTier.local;
      }
    }

    return Candidate(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      countryId: (json['country_id'] ?? json['country'] ?? 'US') as String,
      stateId: json['state_id'] as String?,
      city: json['city'] as String?,
      party: json['party'] as String? ?? 'Independent',
      role: json['role'] as String? ?? 'Candidate',
      photoUrl: (resolvedPhotoUrl != null && resolvedPhotoUrl.isNotEmpty)
          ? resolvedPhotoUrl
          : null,
      tier: parsedTier,
      stances: stancesJson != null
          ? stancesJson
              .map((e) => CandidateStance.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      positions: positionsJson != null
          ? positionsJson
              .map((e) => CandidatePosition.fromJson(e as Map<String, dynamic>))
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
  final ElectionTier? tier;
  final List<CandidateStance> stances;
  final List<CandidatePosition> positions;

  String get fullName => '$firstName $lastName';

  ElectionTier get inferredTier {
    if (tier != null) return tier!;

    final r = role.toLowerCase().trim();

    if (r.contains('president') ||
        r.contains('u.s. senate') ||
        r.contains('us senate') ||
        r.contains('u.s. senator') ||
        r.contains('us senator') ||
        r.contains('u.s. house') ||
        r.contains('us house') ||
        r.contains('u.s. representative') ||
        r.contains('us representative') ||
        r.contains('congress')) {
      return ElectionTier.federal;
    }

    if (r.contains('governor') ||
        r.contains('attorney general') ||
        r.contains('secretary of state') ||
        r.contains('state treasurer') ||
        r.contains('state senator') ||
        r.contains('state representative') ||
        r.contains('state rep') ||
        r.contains('state house') ||
        r.contains('state assembly') ||
        r.contains('state supreme court') ||
        r.contains('lieutenant governor')) {
      return ElectionTier.state;
    }

    if (r.contains('mayor') ||
        r.contains('city council') ||
        r.contains('sheriff') ||
        r.contains('county') ||
        r.contains('district attorney') ||
        r.contains('school board') ||
        r.contains('alderman') ||
        r.contains('commissioner')) {
      return ElectionTier.local;
    }

    if (city != null && city!.isNotEmpty) {
      return ElectionTier.local;
    }
    if (stateId != null && stateId!.isNotEmpty) {
      return ElectionTier.state;
    }

    return ElectionTier.federal;
  }

  Candidate copyWithPhotoUrl(String? photoUrl) {
    return Candidate(
      id: id,
      firstName: firstName,
      lastName: lastName,
      countryId: countryId,
      stateId: stateId,
      city: city,
      party: party,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      tier: tier,
      stances: stances,
      positions: positions,
    );
  }

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
        tier,
        stances,
        positions,
      ];
}

class CandidateStance extends Equatable {
  const CandidateStance({
    required this.issueName,
    required this.agree,
    required this.statement,
    this.issueDescription,
    this.sourceUrl,
  });

  factory CandidateStance.fromJson(Map<String, dynamic> json) {
    final issuesMap = json['issues'] as Map<String, dynamic>?;

    return CandidateStance(
      issueName: issuesMap?['name'] as String? ??
          json['issue_name'] as String? ??
          issuesMap?['title'] as String? ??
          'Unknown Issue',
      agree: json['agree'] as bool? ?? true,
      statement: json['statement'] as String? ??
          json['stance'] as String? ??
          json['description'] as String? ??
          '',
      issueDescription: issuesMap?['description'] as String? ??
          json['issue_description'] as String?,
      sourceUrl: json['source_url'] as String? ??
          json['source'] as String? ??
          json['url'] as String?,
    );
  }

  final String issueName;
  final bool agree;
  final String statement;
  final String? issueDescription;
  final String? sourceUrl;

  @override
  List<Object?> get props => [
        issueName,
        agree,
        statement,
        issueDescription,
        sourceUrl,
      ];
}

class CandidatePosition extends Equatable {
  const CandidatePosition({
    required this.entity,
    required this.position,
    required this.startDate,
    this.endDate,
  });

  factory CandidatePosition.fromJson(Map<String, dynamic> json) {
    return CandidatePosition(
      entity: json['entity'] as String? ?? '',
      position: json['position'] as String? ?? '',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
    );
  }

  final String entity;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;

  String get dateRangeString {
    final startFormatted = DateFormat('MMM yyyy').format(startDate);
    if (endDate == null) {
      return '$startFormatted – Present';
    }
    final endFormatted = DateFormat('MMM yyyy').format(endDate!);
    return '$startFormatted – $endFormatted';
  }

  String get durationString {
    final targetEndDate = endDate ?? DateTime.now();
    final totalMonths =
        ((targetEndDate.year - startDate.year) * 12) + targetEndDate.month - startDate.month;

    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;

    if (years == 0 && months == 0) return 'Less than a month';

    final yearPart = years > 0 ? '$years yr${years > 1 ? 's' : ''}' : '';
    final monthPart = months > 0 ? '$months mo${months > 1 ? 's' : ''}' : '';

    if (yearPart.isNotEmpty && monthPart.isNotEmpty) {
      return '$yearPart $monthPart';
    }
    return yearPart.isNotEmpty ? yearPart : monthPart;
  }

  @override
  List<Object?> get props => [entity, position, startDate, endDate];
}
