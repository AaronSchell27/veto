// lib/features/home/widgets/elections_accordion.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/widgets/presidential_candidate_card.dart';

/// Accordion menu displaying Local, State, and Federal election categories inside a distinct bordered container.
class ElectionsAccordion extends StatelessWidget {
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
                _buildAccordionTile(
                  context: context,
                  title: 'Local Elections',
                  tier: ElectionTier.local,
                  state: state,
                ),
                _buildAccordionTile(
                  context: context,
                  title: 'State Elections',
                  tier: ElectionTier.state,
                  state: state,
                ),
                _buildAccordionTile(
                  context: context,
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

  Widget _buildAccordionTile({
    required BuildContext context,
    required String title,
    required ElectionTier tier,
    required HomeState state,
  }) {
    final isExpanded = state.selectedElectionTier == tier;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: Key('accordion_tile_${tier.name}_$isExpanded'),
        initiallyExpanded: isExpanded,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              ...state.candidates.map(
                (candidate) => PresidentialCandidateCard(
                  name: candidate.fullName,
                  party: candidate.party,
                  pictureUrl: candidate.photoUrl,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
