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
    return homePexelsPhotos.firstWhere((pexelsPhoto) => pexelsPhoto.id == id);
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
        extractedData['photos'].forEach((pexelsPhoto) {
          loadedPexelsPhotos.add(
            PexelsPhoto(
              id: pexelsPhoto['id'],
              width: pexelsPhoto['width'],
              height: pexelsPhoto['height'],
              imageUrl: pexelsPhoto['image_url'],
              alt: pexelsPhoto['alt'],
              photographer: pexelsPhoto['photographer'],
              photographerId: pexelsPhoto['photographer_id'],
              avgColor: pexelsPhoto['avg_color'],
              photographerUrl: pexelsPhoto['photographer_url'],
              src: PexelsPhotoSource(
                original: pexelsPhoto['src']['original'],
                large2x: pexelsPhoto['src']['large2x'],
                large: pexelsPhoto['src']['large'],
                medium: pexelsPhoto['src']['medium'],
                portrait: pexelsPhoto['src']['portrait'],
                small: pexelsPhoto['src']['small'],
                tiny: pexelsPhoto['src']['tiny'],
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
