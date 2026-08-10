// lib/app/view/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/features/app_shell/view/app_shell.dart';
import 'package:veto/features/candidates/data/repositories/candidate_repository.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/l10n/l10n.dart';

/// {@template app}
/// Root application widget responsible for top-level repository and BLoC provision.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({
    required SupabaseDatabaseClient databaseClient,
    super.key,
  }) : _databaseClient = databaseClient;

  final SupabaseDatabaseClient _databaseClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _databaseClient),
        RepositoryProvider(
          create: (context) => LocationRepository(
            databaseClient: _databaseClient,
          ),
        ),
        RepositoryProvider(
          create: (context) => CandidateRepository(
            databaseClient: _databaseClient,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SettingsBloc(
              locationRepository: context.read<LocationRepository>(),
            ),
          ),
          // Any future global blocs (like an AuthBloc) can go here too!
        ],
        child: const AppView(),
      ),
    );
  }
}

/// AppView is pulled out as a separate widget so it can safely read 
/// the context of the newly created MultiBlocProvider above it.
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the dark mode value from SettingsBloc to dynamically adjust the theme
    final isDarkMode = context.select<SettingsBloc, bool>(
      (bloc) => bloc.state.isDarkMode,
    );

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
