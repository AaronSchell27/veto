// lib/main_development.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/app/app.dart';
import 'package:veto/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your staging database credentials
  final databaseClient = await SupabaseDatabaseClient.initialize(
    url: 'https://rttcxycxzitlwwkbtnoj.supabase.co',
    anonKey: 'sb_publishable_FhXgMdId4X-lTiJIDtJgpw_EvyCNdaf',
  );

  // Initialize the HydratedBloc storage engine
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  await bootstrap(
    databaseClient: databaseClient,
    builder: () => App(databaseClient: databaseClient),
  );
}
