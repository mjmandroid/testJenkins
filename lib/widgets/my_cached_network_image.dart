//图片添加占位图
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCachedNetworkImage extends CachedNetworkImage {
  MyCachedNetworkImage(
      {super.key,
        required super.imageUrl,
        super.httpHeaders,
        super.imageBuilder,
        super.placeholder,
        super.progressIndicatorBuilder,
        LoadingErrorWidgetBuilder? errorWidget,
        super.fadeOutDuration = const Duration(milliseconds: 1000),
        super.fadeOutCurve = Curves.easeOut,
        super.fadeInDuration = const Duration(milliseconds: 500),
        super.fadeInCurve = Curves.easeIn,
        super.width,
        super.height,
        super.fit,
        super.alignment = Alignment.center,
        super.repeat = ImageRepeat.noRepeat,
        super.matchTextDirection = false,
        super.cacheManager,
        super.useOldImageOnUrlChange = false,
        super.color,
        super.filterQuality = FilterQuality.low,
        super.colorBlendMode,
        super.placeholderFadeInDuration,
        super.memCacheWidth,
        super.memCacheHeight,
        super.cacheKey,
        super.maxWidthDiskCache,
        super.maxHeightDiskCache})
      : super(errorWidget: (context, url, error) {
    return Container();
  });
}