import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({
    this.width,
    this.height,
    this.iconSize,
    this.placeHolderBuilder,
    this.imageName = 'image_placeholder',
    super.key,
  });

  final double? width;
  final double? height;
  final double? iconSize;
  final Widget Function()? placeHolderBuilder;
  final String? imageName;

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize = iconSize ?? defaultImageSize;
    return SizedBox(
      height: height,
      width: width,
      child: placeHolderBuilder?.call() ??
          Center(
            child: SvgPicture.asset(
              'assets/images/$imageName.svg',
              width: effectiveIconSize,
              height: effectiveIconSize,
            ),
          ),
    );
  }

  double get defaultImageSize => width != null &&
          width != double.infinity &&
          height != null &&
          height != double.infinity
      ? min(width!, height!) / 4
      : 24;
}
