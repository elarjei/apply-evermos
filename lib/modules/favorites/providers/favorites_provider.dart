import 'package:flutter/cupertino.dart';

import '../../../helpers/helper_hive.dart';
import '../../pexels_photo/models/pexels_photo_model.dart';

class FavoritesProvider with ChangeNotifier {
  Map<int, PexelsPhoto> favoritePexelsPhotos = {};

  Map<int, PexelsPhoto> get pexelsPhotos {
    return {
      ...favoritePexelsPhotos,
    };
  }

  void fetchFavorites() {
    favoritePexelsPhotos = HelperHive.getAllBoxData('favorites');
  }

  void toggleFavoriteStatus({required int id, PexelsPhoto? pexelsPhoto}) {
    if (favoritePexelsPhotos.containsKey(id)) {
      favoritePexelsPhotos.remove(id);
      HelperHive.removeFromBox(id, 'favorites');
    } else {
      favoritePexelsPhotos[id] = pexelsPhoto!;
      HelperHive.putIntoBox(id, pexelsPhoto, 'favorites');
    }
    notifyListeners();
  }
}
