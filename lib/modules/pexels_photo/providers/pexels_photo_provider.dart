import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../constants/constant_env.dart';
import '../../../helpers/helper_api.dart';
import '../models/pexels_photo_model.dart';

class PexelsPhotosProvider with ChangeNotifier {
  final List<PexelsPhoto> homePexelsPhotos = [];

  List<PexelsPhoto> get pexelsPhotos {
    return [
      ...homePexelsPhotos,
    ];
  }

  PexelsPhoto findPexelsPhotoById(int id) {
    return homePexelsPhotos.firstWhere((wallpaper) => wallpaper.id == id);
  }

  void addPexelsPhotoToPexelsPhotos(PexelsPhoto addedPexelsPhoto) {
    if (!homePexelsPhotos.contains(addedPexelsPhoto)) {
      homePexelsPhotos.add(addedPexelsPhoto);
      isNewlyAdded = true;
    }
  }

  bool isNewlyAdded = false;
  void removeNewlyAddedPexelsPhoto([int id = 0]) {
    if (isNewlyAdded) {
      homePexelsPhotos.removeLast();
      isNewlyAdded = false;
    }
  }

  int pageRequestCounter = 1;
  int requestedPexelsPhotos = 11;
  Future<void> fetchAndSetPexelsPhotos({bool forceFetch = false}) async {
    if (homePexelsPhotos.isEmpty || forceFetch) {
      if (forceFetch) {
        pageRequestCounter++;
        requestedPexelsPhotos = 12;
      }
      try {
        final response = await HelperApi.getPexelsApi(
          '$pexelsApiUrl/v1/curated?per_page=$requestedPexelsPhotos&page=$pageRequestCounter',
        );
        final extractedData =
            jsonDecode(response.body) as Map<String, dynamic>?;
        if (extractedData == null) return;
        List<PexelsPhoto> loadedPexelsPhotos = [];
        extractedData['photos'].forEach((wallpaper) {
          loadedPexelsPhotos.add(
            PexelsPhoto(
              id: wallpaper['id'],
              width: wallpaper['width'],
              height: wallpaper['height'],
              imageUrl: wallpaper['image_url'],
              alt: wallpaper['alt'],
              photographer: wallpaper['photographer'],
              photographerId: wallpaper['photographer_id'],
              avgColor: wallpaper['avg_color'],
              photographerUrl: wallpaper['photographer_url'],
              src: PexelsPhotoSource(
                original: wallpaper['src']['original'],
                large2x: wallpaper['src']['large2x'],
                large: wallpaper['src']['large'],
                medium: wallpaper['src']['medium'],
                portrait: wallpaper['src']['portrait'],
                small: wallpaper['src']['small'],
                tiny: wallpaper['src']['tiny'],
              ),
            ),
          );
        });
        homePexelsPhotos.addAll(loadedPexelsPhotos);
        notifyListeners();
      } on TimeoutException catch (_) {
        rethrow;
      } catch (_) {
        rethrow;
      }
    }
  }
}
