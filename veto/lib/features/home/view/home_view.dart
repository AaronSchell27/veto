// lib/features/home/view/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/widgets/location_onboarding_card.dart';
import 'package:veto/features/home/widgets/presidential_candidate_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationOnboardingCard(),
                if (state.isUSLocation && state.candidates.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      'Presidential Candidates',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ...state.candidates.map(
                    (candidate) => PresidentialCandidateCard(
                      name: candidate.fullName,
                      party: candidate.party,
                      pictureUrl: candidate.photoUrl,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
