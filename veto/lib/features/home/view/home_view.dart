// lib/features/home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:veto/features/home/widgets/location_onboarding_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LocationOnboardingCard(),
          ],
        ),
      ),
    );
  }
}
