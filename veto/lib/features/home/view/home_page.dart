import 'package:flutter/material.dart';
import 'package:veto/features/home/view/home_view.dart';

/// {@template home_page}
/// Entry point for the home feature route.
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
