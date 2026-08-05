// lib/features/home/view/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/widgets/elections_accordion.dart';
import 'package:veto/features/home/widgets/location_onboarding_card.dart';

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
                if (state.hasSubmittedLocation && state.isUSLocation)
                  const ElectionsAccordion(),
              ],
            );
          },
        ),
      ),
    );
  }
}
