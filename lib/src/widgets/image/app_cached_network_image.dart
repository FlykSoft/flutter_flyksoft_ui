import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../models/image_size.dart';
import '../../utils/cache_utils.dart';
import 'image_failure_widget.dart';

class AppCachedNetworkImage extends StatefulWidget {
  const AppCachedNetworkImage({
    required this.url,
    this.width,
    this.height,
    this.failureIcon,
    this.fit,
    this.memCacheHeight,
    this.memCacheWidth,
    this.imageSize = ImageSize.medium,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;
  final Widget? failureIcon;
  final BoxFit? fit;
  final int? memCacheHeight;
  final int? memCacheWidth;
  final ImageSize imageSize;

  @override
  State<AppCachedNetworkImage> createState() => _AppCachedNetworkImageState();
}

class _AppCachedNetworkImageState extends State<AppCachedNetworkImage> {
  GlobalKey _key = GlobalKey();

  void _retry() => setState(() => _key = GlobalKey());

  double _loadingSize() => widget.height != null && widget.height != null
      ? widget.height! > 150
          ? 17
          : widget.height! > 100
              ? 13
              : 10
      : 16;

  @override
  Widget build(final BuildContext context) => CachedNetworkImage(
        imageUrl: widget.url,
        key: _key,
        fit: widget.fit ?? BoxFit.cover,
        width: widget.width,
        height: widget.height,
        httpHeaders: widget.imageSize.imageHeaders,
        memCacheHeight: widget.memCacheHeight,
        memCacheWidth: widget.memCacheWidth,
        cacheManager: CacheUtils().manager,
        progressIndicatorBuilder: (
          final context,
          final _,
          final __,
        ) =>
            SizedBox(
          width: widget.width,
          height: widget.height,
          child: Center(
            child: CupertinoActivityIndicator(
              animating: true,
              radius: _loadingSize(),
            ),
          ),
        ),
        errorWidget: (
          final context,
          final _,
          final __,
        ) =>
            ImageFailureWidget(
          width: widget.width,
          height: widget.height,
          failureIcon: widget.failureIcon,
          onRetry: _retry,
        ),
      );
}
