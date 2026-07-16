// lib/features/settings/view/settings_view.dart
import 'dart:async'; // Required for unawaited
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/widgets/location_onboarding_card.dart'; // Corrected folder path!
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';
import 'package:veto/features/settings/widgets/dark_mode_switch.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Dark Mode'),
            trailing: DarkModeSwitch(),
          ),
          const Divider(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final String subtitleText;
              final IconData iconData;
              final Color? iconColor;

              if (state.hasSavedLocation) {
                subtitleText = '${state.cityName}, ${state.regionId}';
                iconData = Icons.location_on;
                iconColor = Theme.of(context).colorScheme.primary;
              } else {
                subtitleText = 'No location configured';
                iconData = Icons.location_off_outlined;
                iconColor = Theme.of(context).colorScheme.error;
              }

              return ListTile(
                leading: Icon(iconData, color: iconColor),
                title: const Text('Local Location'),
                subtitle: Text(subtitleText),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  unawaited(
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          insetPadding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: BlocProvider.value(
                              value: context.read<HomeBloc>(),
                              child: const LocationOnboardingCard(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
