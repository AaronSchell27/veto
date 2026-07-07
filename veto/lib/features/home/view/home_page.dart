// lib/features/home/view/home_page.dart
import 'package:flutter/material.dart';
import 'package:veto/features/home/view/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Your AppShell already hosts the BlocProvider! 
    // Simply return the view layer directly here.
    return const HomeView(); 
  }
}
