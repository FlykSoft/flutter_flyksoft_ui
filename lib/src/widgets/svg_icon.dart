import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.name,
    this.size,
    this.colorFilter,
    super.key,
  });

  final String name;
  final double? size;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        'assets/images/$name.svg',
        width: size,
        height: size,
        colorFilter: colorFilter,
      );
}
