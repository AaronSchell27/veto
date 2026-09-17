// lib/features/candidate_info/widgets/donors_card.dart

import 'package:flutter/material.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class DonorsCard extends StatelessWidget {
  const DonorsCard({
    required this.donors,
    super.key,
  });

  final List<CandidateDonor> donors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donors',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (donors.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No recorded donors for this candidate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ...donors.map(
            (donor) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DonorCardItem(donor: donor),
            ),
          ),
      ],
    );
  }
}

class _DonorCardItem extends StatelessWidget {
  const _DonorCardItem({required this.donor});

  final CandidateDonor donor;

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      final formatted = (amount / 1000000).toStringAsFixed(2);
      return '\$${formatted}m';
    } else if (amount >= 1000) {
      final formatted = (amount / 1000).toStringAsFixed(2);
      return '\$${formatted}k';
    }
    return '\$$amount';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              donor.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatAmount(donor.amount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
