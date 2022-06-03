import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'helpers/helper_hive.dart';
import 'modules/pexels_photo/models/pexels_photo_model.dart';
import 'myapp.dart';

Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter(PexelsPhotoSourceAdapter());
  Hive.registerAdapter(PexelsPhotoAdapter());

  await Hive.initFlutter();
  await HelperHive.openHiveBox('favorites');

  runApp(
    const MyApp(),
  );
}
