import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/favorites/providers/favorites_provider.dart';
import '../modules/pexels_photo/components/pexels_photo_grid_view.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    Provider.of<FavoritesProvider>(context, listen: false).fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoritePexelsPhotos =
        Provider.of<FavoritesProvider>(context).pexelsPhotos;

    return favoritePexelsPhotos.isEmpty
        ? const Center(
            child: Text('Let`s favorite some pretty photos!'),
          )
        : PexelsPhotosGridView(
            pexelsPhotos: favoritePexelsPhotos.values.toList(),
            screenName: ScreenName.favorites,
            canLoadMore: false,
          );
  }
}
