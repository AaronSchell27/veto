// lib/features/home/widgets/candidate_card.dart

import 'package:flutter/material.dart';

/// {@template candidate_card}
/// A card displaying a candidate's overview information
/// alongside a 1x1 aspect ratio avatar portrait and an external detail link icon.
/// {@endtemplate}
class CandidateCard extends StatelessWidget {
  /// {@macro candidate_card}
  const CandidateCard({
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
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(128),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        leading: _CandidateAvatar(pictureUrl: pictureUrl),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            party,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          size: 20,
          color: theme.colorScheme.primary,
        ),
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

  static const double _avatarSize = 48;

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
        Icons.person_rounded,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
