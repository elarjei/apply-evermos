import 'dart:async';
import 'dart:convert';

import 'package:apply_evermos/constants/constant_env.dart';
import 'package:flutter/material.dart';

import '../helpers/helper_api.dart';
import '../modules/pexels_photo/components/pexels_photo_grid_view.dart';
import '../modules/pexels_photo/models/pexels_photo_model.dart';
import '../widgets/toast.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<PexelsPhoto> _searchedPexelsPhotos = [];

  Future<void> searchForPexelsPhotos(String query) async {
    setState(() {
      _searchedPexelsPhotos.clear();
    });
    if (query.isEmpty) {
      toast('Enter Something To Search For');
      return;
    }
    try {
      final response = await HelperApi.getPexelsApi(
        '$pexelsApiUrl/v1/search?query=$query&per_page=20',
      );
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) return;

      extractedData['photos'].forEach((wallpaper) {
        setState(() {
          _searchedPexelsPhotos.add(
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
      });
      if (_searchedPexelsPhotos.isEmpty) {
        toast('No results found, Try again');
      }
    } on TimeoutException catch (_) {
      toast('Timeout!! Check Your Internet Connection');
    } catch (_) {
      toast('Something Went Wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                right: 10,
                left: 10,
                bottom: 5,
              ),
              child: Column(
                children: [
                  TextField(
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      label: Text('Search For what you are looking for'),
                    ),
                    onSubmitted: (value) async {
                      return searchForPexelsPhotos(value);
                    },
                  ),
                ],
              ),
            ),
            if (_searchedPexelsPhotos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: deviceSize.height * 0.75,
                  child: PexelsPhotosGridView(
                    pexelsPhotos: _searchedPexelsPhotos,
                    screenName: ScreenName.search,
                    canLoadMore: false,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
