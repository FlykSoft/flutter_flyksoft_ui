import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';

class AppImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final String? assetPath;
  final BoxFit? fit;
  final ImageClip imageClip;
  final bool useBackgroundColor;
  final Widget Function()? placeHolderBuilder;
  final int? memCacheHeight;
  final int? memCacheWidth;
  final bool useCache;
  final ImageSize networkImageSize;

  const AppImage({
    this.url,
    this.networkImageSize = ImageSize.medium,
    this.assetPath,
    this.width,
    this.height,
    this.imageClip = const ImageNoClip(),
    this.fit,
    this.placeHolderBuilder,
    this.memCacheHeight,
    this.memCacheWidth,
    this.useCache = true,
    this.useBackgroundColor = true,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    late Widget image;
    if (url != null) {
      image = useCache
          ? AppCachedNetworkImage(
              url: url!,
              height: height,
              width: width,
              fit: fit,
              memCacheHeight: memCacheHeight,
              memCacheWidth: memCacheWidth,
              imageSize: networkImageSize,
            )
          : AppNetworkImage(
              url: url!,
              height: height,
              width: width,
              fit: fit,
              imageSize: networkImageSize,
            );
    } else if (assetPath != null) {
      image = Image.asset(
        assetPath!,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (
          final context,
          final _,
          final __,
        ) =>
            ImageFailureWidget(
          width: width,
          height: height,
        ),
        width: width,
        height: height,
      );
    } else {
      image = ImagePlaceHolder(
        width: width,
        height: height,
        placeHolderBuilder: placeHolderBuilder,
      );
    }

    return ConditionalWidget(
      condition: imageClip != const ImageNoClip(),
      conditionBuilder: (child) => switch (imageClip) {
        ImageClipRRect() => ClipRRect(
            borderRadius: (imageClip as ImageClipRRect).borderRadius,
            child: child,
          ),
        ImageClipOval() => ClipOval(
            child: child,
          ),
        ImageNoClip() => child,
      },
      child: ConditionalWidget(
        condition: useBackgroundColor,
        conditionBuilder: (child) => ColoredBox(
          color: Theme.of(context).highlightColor,
          child: child,
        ),
        child: InkResponse(
          enableFeedback: true,
          child: image,
        ),
      ),
    );
  }
}
