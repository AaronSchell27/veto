// lib/app/view/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart'; 
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/features/app_shell/view/app_shell.dart';
import 'package:veto/l10n/l10n.dart';

class App extends StatelessWidget {
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
      ],
      child: MaterialApp(
        // Remove the old theme class import reference and use Flutter's clean built-in styling
        theme: ThemeData(useMaterial3: true),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AppShell(), 
      ),
    );
  }
}
