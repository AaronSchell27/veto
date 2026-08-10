// lib/features/candidate_info/widgets/stances_card.dart

import 'package:flutter/material.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class StancesCard extends StatelessWidget {
  const StancesCard({required this.stances, super.key});

  final List<CandidateStance> stances;

  @override
  Widget build(BuildContext context) {
    if (stances.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No recorded stances for this candidate.'),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Stances',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stances.length,
              separatorBuilder: (context, _) => const Divider(), // Changed from __ to _
              itemBuilder: (context, index) {
                final stance = stances[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    stance.issueName.isNotEmpty
                        ? stance.issueName
                        : 'Issue Position',
                  ),
                  subtitle: Text(stance.statement),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
