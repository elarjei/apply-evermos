import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../pages/detail_page.dart';
import '../../../widgets/toast.dart';
import '../models/pexels_photo_model.dart';
import '../providers/pexels_photo_provider.dart';
import 'pexels_photo_grid_item.dart';

enum ScreenName {
  home,
  search,
  favorites,
}

class PexelsPhotosGridView extends StatefulWidget {
  final List<PexelsPhoto> pexelsPhotos;
  final bool canLoadMore;
  final ScreenName screenName;

  const PexelsPhotosGridView({
    Key? key,
    required this.pexelsPhotos,
    this.canLoadMore = true,
    this.screenName = ScreenName.home,
  }) : super(key: key);

  @override
  State<PexelsPhotosGridView> createState() => _PexelsPhotosGridViewState();
}

class _PexelsPhotosGridViewState extends State<PexelsPhotosGridView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  loadMoreData() async {
    try {
      await Provider.of<PexelsPhotosProvider>(
        context,
        listen: false,
      ).fetchAndSetPexelsPhotos(forceFetch: true);
    } on TimeoutException catch (_) {
      toast('Timeout!! Check Your Internet Connection');
    } catch (_) {
      toast('Something Went Wrong!!');
    }
  }

  void managePexelsPhotoDetailsNavigation(
    BuildContext context,
    PexelsPhoto wallpaper,
  ) {
    final wallpapersProvider = Provider.of<PexelsPhotosProvider>(
      context,
      listen: false,
    );
    if (widget.screenName != ScreenName.home) {
      wallpapersProvider.addPexelsPhotoToPexelsPhotos(wallpaper);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        itemCount: widget.canLoadMore
            ? widget.pexelsPhotos.length + 1
            : widget.pexelsPhotos.length,
        itemBuilder: (context, index) {
          if (widget.canLoadMore && index == widget.pexelsPhotos.length) {
            return GestureDetector(
              onTap: () async {
                loadMoreData();
              },
              child: const SizedBox(),
            );
          }
          return GestureDetector(
            onTap: () {
              managePexelsPhotoDetailsNavigation(
                context,
                widget.pexelsPhotos[index],
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: PexelsPhotoGridItem(
                id: widget.pexelsPhotos[index].id!,
                imageUrl: widget.pexelsPhotos[index].src!.medium!,
                avgColor: widget.pexelsPhotos[index].avgColor!,
              ),
            ),
          );
        },
      ),
    );
  }
}
