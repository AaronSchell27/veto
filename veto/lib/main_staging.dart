import 'package:veto/app/app.dart';
import 'package:veto/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
