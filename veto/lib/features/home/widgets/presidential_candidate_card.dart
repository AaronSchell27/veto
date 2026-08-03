// lib/features/home/widgets/presidential_candidate_card.dart

import 'package:flutter/material.dart';

/// {@template presidential_candidate_card}
/// A card displaying a presidential candidate's overview information
/// alongside a 1x1 aspect ratio avatar portrait.
/// {@endtemplate}
class PresidentialCandidateCard extends StatelessWidget {
  /// {@macro presidential_candidate_card}
  const PresidentialCandidateCard({
    required this.name,
    required this.party,
    this.pictureUrl,
    this.onTap,
    super.key,
  });

  /// The full name of the candidate.
  final String name;

  /// The political party affiliation (e.g., Democrat, Republican, Independent).
  final String party;

  /// Optional remote public URL for the candidate's 1x1 face photo.
  final String? pictureUrl;

  /// Optional callback triggered when tapping the candidate card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: _CandidateAvatar(pictureUrl: pictureUrl),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            party,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

/// {@template candidate_avatar}
/// Helper widget to render a 1x1 square candidate portrait or a fallback icon.
/// {@endtemplate}
class _CandidateAvatar extends StatelessWidget {
  const _CandidateAvatar({this.pictureUrl});

  final String? pictureUrl;

  static const double _avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: _avatarSize,
        height: _avatarSize,
        child: (pictureUrl != null && pictureUrl!.isNotEmpty)
            ? Image.network(
                pictureUrl!,
                width: _avatarSize,
                height: _avatarSize,
                fit: BoxFit.cover, // Ensures exact 1x1 square crop
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackIcon(theme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              )
            : _buildFallbackIcon(theme),
      ),
    );
  }

  Widget _buildFallbackIcon(ThemeData theme) {
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 32,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
