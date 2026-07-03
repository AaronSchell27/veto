import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/features/settings/view/settings_view.dart'; // Create this for your settings UI

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This is where you provide your Bloc so the UI can use it!
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: const SettingsView(), 
    );
  }
}
