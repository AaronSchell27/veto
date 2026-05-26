class Candidate {
  Candidate({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.party,
    required this.role,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
      return Candidate(
        id: json['id'] as int,
        firstName: json['first_name'] as String, 
        lastName: json['last_name'] as String,
        country: json['country'] as String,
        party: json['party'] as String,
        role: json['role'] as String,
      );
    }

  final int id;
  final String firstName;
  final String lastName;
  final String country;
  final String party;
  final String role;

  String get fullName => '$firstName $lastName';
}
