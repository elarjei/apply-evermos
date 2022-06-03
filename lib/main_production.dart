import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'generated/assets.gen.dart';
import 'start.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: Assets.env.envProduction,
  );
  await start();
}
