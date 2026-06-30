// lib/features/settings/view/settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';
import 'package:veto/features/settings/widgets/dark_mode_switch.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Theme'),
            trailing: DarkModeSwitch(),
          ),
        ],
      ),
    );
  }
}
