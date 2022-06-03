import 'dart:async';
import 'dart:convert';

import 'package:apply_evermos/constants/constant_env.dart';
import 'package:flutter/material.dart';

import '../helpers/helper_api.dart';
import '../modules/pexels_photo/components/pexels_photo_grid_view.dart';
import '../modules/pexels_photo/models/pexels_photo_model.dart';
import '../widgets/toast_widget.dart';

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
      toast('Search some photo...');
      return;
    }
    try {
      final response = await HelperApi.getPexelsApi(
        '$pexelsApiUrl/v1/search?query=$query&per_page=20',
      );
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) return;

      extractedData['photos'].forEach((pexelsPhoto) {
        setState(() {
          _searchedPexelsPhotos.add(
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
      });
      if (_searchedPexelsPhotos.isEmpty) {
        toast('No results found, Try again');
      }
    } on TimeoutException catch (_) {
      toast('Timeout!! Check Your Internet Connection');
    } catch (_) {
      toast('Something went wrong!');
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
