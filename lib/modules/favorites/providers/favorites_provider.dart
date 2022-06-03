import 'package:flutter/cupertino.dart';

import '../../../helpers/helper_hive.dart';
import '../../pexels_photo/models/pexels_photo_model.dart';

class FavoritesProvider with ChangeNotifier {
  Map<int, PexelsPhoto> _favoritePexelsPhotos = {};

  Map<int, PexelsPhoto> get pexelsPhotos {
    return {..._favoritePexelsPhotos};
  }

  void fetchFavorites() {
    _favoritePexelsPhotos = HelperHive.getAllBoxData('favorites');
  }

  void toggleFavoriteStatus({required int id, PexelsPhoto? pexelsPhoto}) {
    if (_favoritePexelsPhotos.containsKey(id)) {
      _favoritePexelsPhotos.remove(id);
      HelperHive.removeFromBox(id, 'favorites');
    } else {
      _favoritePexelsPhotos[id] = pexelsPhoto!;
      HelperHive.putIntoBox(id, pexelsPhoto, 'favorites');
    }
    notifyListeners();
  }
}
