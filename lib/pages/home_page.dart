import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/pexels_photo/components/pexels_photo_grid_view.dart';
import '../modules/pexels_photo/components/pexels_photo_list_view.dart';
import '../modules/pexels_photo/providers/pexels_photo_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<bool> isSelected;
  late bool isGridView;

  @override
  void initState() {
    super.initState();
    _wallpapersFuture = _obtainPexelsPhotosFuture();
    isSelected = <bool>[
      true,
      false,
    ];
    isGridView = true;
  }

  Future? _wallpapersFuture;
  Future _obtainPexelsPhotosFuture() {
    return Provider.of<PexelsPhotosProvider>(
      context,
      listen: false,
    ).fetchAndSetPexelsPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _wallpapersFuture,
      builder: (context, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (dataSnapShot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else {
          return Consumer<PexelsPhotosProvider>(
            builder: (context, wallpapersProvider, _) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(8),
                          constraints: const BoxConstraints(
                            minHeight: 32,
                          ),
                          isSelected: isSelected,
                          onPressed: (index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  isSelected[buttonIndex] = true;
                                  isGridView = false;
                                } else {
                                  isSelected[buttonIndex] = false;
                                  isGridView = true;
                                }
                              }
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.grid_view_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Grid'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.table_rows_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text('List'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isGridView
                        ? PexelsPhotosGridView(
                            pexelsPhotos: wallpapersProvider.pexelsPhotos,
                          )
                        : PexelsPhotosListView(
                            pexelsPhotos: wallpapersProvider.pexelsPhotos,
                          ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
