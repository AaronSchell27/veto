// lib/features/candidate_info/view/candidate_info_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_state.dart';
// Ensure these widget imports are explicitly declared:
import 'package:veto/features/candidate_info/widgets/candidate_header_card.dart';
import 'package:veto/features/candidate_info/widgets/stances_card.dart';

class CandidateInfoView extends StatelessWidget {
  const CandidateInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Details'),
      ),
      body: BlocBuilder<CandidateInfoBloc, CandidateInfoState>(
        builder: (context, state) {
          switch (state.status) {
            case CandidateInfoStatus.initial:
            case CandidateInfoStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case CandidateInfoStatus.failure:
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to load candidate info.',
                  style: const TextStyle(color: Colors.red),
                ),
              );

            case CandidateInfoStatus.success:
              final candidate = state.candidate;
              if (candidate == null) {
                return const Center(child: Text('Candidate not found.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CandidateHeaderCard(candidate: candidate),
                    const SizedBox(height: 16),
                    StancesCard(stances: state.stances),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
