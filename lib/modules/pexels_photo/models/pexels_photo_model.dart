import 'package:hive/hive.dart';

part 'pexels_photo_model.g.dart';

@HiveType(
  typeId: 1,
  adapterName: 'PexelsPhotoAdapter',
)
class PexelsPhoto {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? width;
  @HiveField(3)
  final int? height;
  @HiveField(4)
  final String? imageUrl;
  @HiveField(5)
  final String? photographer;
  @HiveField(6)
  final String? photographerUrl;
  @HiveField(7)
  final int? photographerId;
  @HiveField(8)
  final String? avgColor;
  @HiveField(9)
  final PexelsPhotoSource? src;
  @HiveField(10)
  final String? alt;

  PexelsPhoto({
    this.id,
    this.width,
    this.height,
    this.imageUrl,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.alt,
  });
}

@HiveType(
  typeId: 0,
  adapterName: 'PexelsPhotoSourceAdapter',
)
class PexelsPhotoSource {
  @HiveField(0)
  final String? original;
  @HiveField(1)
  final String? large2x;
  @HiveField(2)
  final String? large;
  @HiveField(3)
  final String? medium;
  @HiveField(4)
  final String? small;
  @HiveField(5)
  final String? portrait;
  @HiveField(6)
  final String? tiny;

  PexelsPhotoSource({
    this.original,
    this.large2x,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.tiny,
  });
}
