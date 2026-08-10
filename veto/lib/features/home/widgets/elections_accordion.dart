// lib/features/home/widgets/elections_accordion.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/candidate_info/view/candidate_info_page.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';
import 'package:veto/features/candidates/data/repositories/candidate_repository.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/widgets/candidate_card.dart';

/// {@template elections_accordion}
/// Accordion menu displaying Local, State, and Federal election categories
/// inside a distinct bordered container.
/// {@endtemplate}
class ElectionsAccordion extends StatelessWidget {
  /// {@macro elections_accordion}
  const ElectionsAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: Text(
                    'Elections',
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
                _AccordionTile(
                  title: 'Local Elections',
                  tier: ElectionTier.local,
                  state: state,
                ),
                _AccordionTile(
                  title: 'State Elections',
                  tier: ElectionTier.state,
                  state: state,
                ),
                _AccordionTile(
                  title: 'Federal Elections',
                  tier: ElectionTier.federal,
                  state: state,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AccordionTile extends StatelessWidget {
  const _AccordionTile({
    required this.title,
    required this.tier,
    required this.state,
  });

  final String title;
  final ElectionTier tier;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = state.selectedElectionTier == tier;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: Key('accordion_tile_${tier.name}_$isExpanded'),
        initiallyExpanded: isExpanded,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        onExpansionChanged: (expanded) {
          if (expanded) {
            context.read<HomeBloc>().add(HomeElectionTierChanged(tier));
          } else if (state.selectedElectionTier == tier) {
            context.read<HomeBloc>().add(const HomeLocationSubmitted());
          }
        },
        children: [
          if (isExpanded) ...[
            if (state.isFetchingCandidates)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            else if (state.candidates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No $title candidates available for this region.'),
              )
            else
              _GroupedCandidatesList(candidates: state.candidates),
          ],
        ],
      ),
    );
  }
}

class _GroupedCandidatesList extends StatelessWidget {
  const _GroupedCandidatesList({
    required this.candidates,
  });

  final List<Candidate> candidates;

  @override
  Widget build(BuildContext context) {
    final groupedCandidates = candidates.fold<Map<String, List<Candidate>>>(
      {},
      (map, candidate) {
        final positionTitle = candidate.role;
        map.putIfAbsent(positionTitle, () => []).add(candidate);
        return map;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groupedCandidates.entries)
          _PositionGroupCard(
            positionTitle: entry.key,
            candidates: entry.value,
          ),
      ],
    );
  }
}

class _PositionGroupCard extends StatelessWidget {
  const _PositionGroupCard({
    required this.positionTitle,
    required this.candidates,
  });

  final String positionTitle;
  final List<Candidate> candidates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(180),
        ),
      ),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.primaryContainer.withAlpha(100),
            child: Text(
              positionTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: candidates
                  .map(
                    (candidate) => CandidateCard(
                      name: candidate.fullName,
                      party: candidate.party,
                      pictureUrl: candidate.photoUrl,
                      onTap: () {
                        unawaited(
                          Navigator.of(context).push(
                            CandidateInfoPage.route(
                              candidateId: candidate.id,
                              candidateRepository:
                                  context.read<CandidateRepository>(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
