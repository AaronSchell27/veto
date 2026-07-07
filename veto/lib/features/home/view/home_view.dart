// lib/features/home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:veto/features/home/widgets/location_onboarding_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Remove the Scaffold and BottomNavigationBar entirely here!
    // 2. Use a SingleChildScrollView or custom layout body so it fills the screen safely inside the AppShell.
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LocationOnboardingCard(),
            // Your other home feed components go below here safely
          ],
        ),
      ),
    );
  }
}
