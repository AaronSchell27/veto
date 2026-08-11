// lib/features/candidate_info/widgets/candidate_header_card.dart

import 'package:flutter/material.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class CandidateHeaderCard extends StatelessWidget {
  const CandidateHeaderCard({required this.candidate, super.key});

  final Candidate candidate;

  static const double _avatarSize = 56;

  Color _getPartyColor(String party) {
    final lowerParty = party.toLowerCase();
    if (lowerParty.contains('republican')) {
      return const Color(0xFFD32F2F); // Red
    } else if (lowerParty.contains('democrat')) {
      return const Color(0xFF1976D2); // Blue
    } else if (lowerParty.contains('green')) {
      return const Color(0xFF388E3C); // Green
    } else if (lowerParty.contains('libertarian')) {
      return const Color(0xFFFBC02D); // Yellow
    }
    return Colors.white; // Default / Other
  }

  Color _getTextColor(String party) {
    final lowerParty = party.toLowerCase();
    if (lowerParty.contains('republican') ||
        lowerParty.contains('democrat') ||
        lowerParty.contains('green')) {
      return Colors.white;
    }
    return Colors.black87; // Dark text for Libertarian (Yellow) & Other (White)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoUrl = candidate.photoUrl;
    final cardColor = _getPartyColor(candidate.party);
    final textColor = _getTextColor(candidate.party);

    return Card(
      elevation: 0,
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: _avatarSize,
                height: _avatarSize,
                child: (photoUrl != null && photoUrl.isNotEmpty)
                    ? Image.network(
                        photoUrl,
                        width: _avatarSize,
                        height: _avatarSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackIcon(theme),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : _buildFallbackIcon(theme),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Text(
                    candidate.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (candidate.party.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      candidate.party,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withAlpha(204),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(ThemeData theme) {
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person_rounded,
        size: 32,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
