// lib/features/candidate_info/widgets/candidate_header_card.dart

import 'package:flutter/material.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class CandidateHeaderCard extends StatelessWidget {
  const CandidateHeaderCard({required this.candidate, super.key});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              candidate.fullName, // Changed from candidate.name
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
