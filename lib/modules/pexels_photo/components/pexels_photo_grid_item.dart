import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helper_hex_color.dart';

class PexelsPhotoGridItem extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String avgColor;

  const PexelsPhotoGridItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.avgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        decoration: BoxDecoration(
          color: HelperHexColor(avgColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            placeholder: (context, url) {
              return Container(
                color: HelperHexColor(avgColor),
              );
            },
            errorWidget: (context, url, error) {
              return const Icon(Icons.error);
            },
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
