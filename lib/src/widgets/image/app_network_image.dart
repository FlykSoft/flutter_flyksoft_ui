import 'package:flutter/cupertino.dart';

import '../../../flyksoft_ui.dart';

class AppNetworkImage extends StatefulWidget {
  const AppNetworkImage({
    required this.url,
    this.width,
    this.height,
    this.failureIcon,
    this.fit,
    this.imageSize = ImageSize.medium,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;
  final Widget? failureIcon;
  final BoxFit? fit;
  final ImageSize imageSize;

  @override
  State<AppNetworkImage> createState() => _AppCachedNetworkImageState();
}

class _AppCachedNetworkImageState extends State<AppNetworkImage> {
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
  Widget build(final BuildContext context) => Image.network(
        widget.url,
        key: _key,
        headers: widget.imageSize.imageHeaders,
        fit: widget.fit ?? BoxFit.cover,
        width: widget.width,
        height: widget.height,
        loadingBuilder: (
          final context,
          final child,
          final loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: CupertinoActivityIndicator(
                animating: true,
                radius: _loadingSize(),
              ),
            ),
          );
        },
        errorBuilder: (
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
