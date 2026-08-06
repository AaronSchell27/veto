// lib/features/home/widgets/local_events_card.dart

import 'package:flutter/material.dart';

/// Card component displaying a scrollable list of local events matching the visual style of `ElectionsAccordion`.
class LocalEventsCard extends StatelessWidget {
  const LocalEventsCard({
    super.key,
    this.events = const [],
  });

  /// List of event items to display.
  final List<Widget> events;

  /// Approximate height allowed for up to 3 event cards before internal scrolling kicks in.
  static const double _maxViewportHeight = 240;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
              child: Text(
                'Local Events',
                style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 4),
            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No Local Events available for this region.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: _maxViewportHeight,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: events.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => events[index],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
