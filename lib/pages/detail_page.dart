import 'package:apply_evermos/constants/constant_secret.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_hex_color.dart';
import '../modules/favorites/providers/favorites_provider.dart';
import '../modules/pexels_photo/providers/pexels_photo_provider.dart';
import '../widgets/toast_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static const routeName = '/wallpaper-details';

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  final Map<String, String> headers = {
    'authorization': pexelsApiKey,
  };

  Future<void> downloadImage(String imageUrl) async {
    try {
      toast('Downloading...');

      if (kIsWeb) {
        await WebImageDownloader().downloadImageFromWeb(
          imageUrl,
          headers: headers,
        );
      } else {
        await ImageDownloader.downloadImage(imageUrl);
      }
    } on PlatformException catch (error) {
      debugPrint('$error');
      toast('Something went wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final pexelsPhoto = Provider.of<PexelsPhotosProvider>(
      context,
      listen: false,
    ).findPexelsPhotoById(id);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            color: HelperHexColor(pexelsPhoto.avgColor!),
            width: double.infinity,
            height: deviceSize.height,
            child: CachedNetworkImage(
              placeholder: (context, url) {
                return Container(
                  color: HelperHexColor(pexelsPhoto.avgColor!),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
              imageUrl: pexelsPhoto.src!.original!,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      FloatingActionButton(
                        heroTag: 'copyLink',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: pexelsPhoto.src!.large!,
                            ),
                          );
                          toast('Copied to clipboard');
                        },
                        child: const Icon(Icons.link),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                pexelsPhoto.src!.large!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: 'download',
                        onPressed: () {
                          downloadImage(pexelsPhoto.src!.large!);
                        },
                        child: const Icon(Icons.arrow_circle_down_sharp),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'By ${pexelsPhoto.photographer!}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, _) {
                          return FloatingActionButton(
                            heroTag: 'favorite',
                            onPressed: () {
                              favoritesProvider.toggleFavoriteStatus(
                                id: id,
                                pexelsPhoto: pexelsPhoto,
                              );
                            },
                            child: Icon(
                              favoritesProvider.pexelsPhotos.containsKey(id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
