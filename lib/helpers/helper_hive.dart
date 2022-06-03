import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../modules/pexels_photo/models/pexels_photo_model.dart';

abstract class HelperHive {
  static Future<Box> openHiveBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  static void putIntoBox(dynamic key, dynamic value, String boxName) {
    Box<dynamic> box = Hive.box(boxName);
    box.put(key, value);
    debugPrint('${box.length}');
  }

  static dynamic getFromBox(dynamic key, String boxName) {
    Box<dynamic> box = Hive.box(boxName);
    return box.get(key);
  }

  static Map<int, PexelsPhoto> getAllBoxData(String boxName) {
    Box<dynamic> box = Hive.box(boxName);
    Map<int, PexelsPhoto> extractedData = {};
    box.toMap().forEach((key, value) {
      extractedData[key] = value;
    });
    return extractedData;
  }

  static void removeFromBox(dynamic key, String boxName) {
    Box<dynamic> box = Hive.box(boxName);
    box.delete(key);
    debugPrint('${box.length}');
  }
}
