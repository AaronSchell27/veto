// lib/features/settings/view/settings_page.dart
import 'package:flutter/material.dart';
import 'package:veto/features/settings/view/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // No BlocProvider here anymore! It's globally provided at the root.
    return const SettingsView(); 
  }
}
