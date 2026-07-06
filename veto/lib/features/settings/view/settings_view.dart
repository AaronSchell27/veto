// lib/features/settings/view/settings_view.dart
import 'package:flutter/material.dart';
import 'package:veto/features/settings/widgets/dark_mode_switch.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Dark Mode'),
            trailing: DarkModeSwitch(),
          ),
        ],
      ),
    );
  }
}
