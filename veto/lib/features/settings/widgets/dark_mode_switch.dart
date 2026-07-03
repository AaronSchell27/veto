// lib/features/settings/widgets/dark_mode_switch.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<SettingsBloc, bool>((bloc) => bloc.state.isDarkMode);

    return Switch(
      value: isDark,
      onChanged: (_) {
        context.read<SettingsBloc>().add(ToggleThemeEvent());
      },
    );
  }
}
