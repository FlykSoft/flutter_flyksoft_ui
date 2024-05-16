import 'package:flutter/cupertino.dart';

sealed class ImageClip {
  const ImageClip();
}

class ImageClipRRect extends ImageClip {
  final BorderRadiusGeometry borderRadius;

  const ImageClipRRect({
    required this.borderRadius,
  });
}

class ImageClipOval extends ImageClip {
  const ImageClipOval();
}

class ImageNoClip extends ImageClip {
  const ImageNoClip();
}
