// lib/features/app_shell/view/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:veto/features/app_shell/view/app_shell_view.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart'; // Import SettingsBloc

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        locationRepository: context.read<LocationRepository>(),
        settingsBloc: context.read<SettingsBloc>(), // <-- Pass SettingsBloc here
      )..add(const HomeCountriesRequested()),
      child: const AppShellView(),
    );
  }
}
