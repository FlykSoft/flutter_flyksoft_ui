import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/widgets/svg_icon.dart';

class SvgIconButton extends StatelessWidget {
  final String name;
  final void Function()? onTap;
  final double? size;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final VisualDensity? visualDensity;
  final double? splashRadius;
  final ColorFilter? colorFilter;

  const SvgIconButton({
    required this.name,
    this.onTap,
    this.size,
    this.padding,
    this.constraints,
    this.visualDensity,
    this.splashRadius,
    this.colorFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        padding: padding,
        onPressed: onTap,
        constraints: constraints,
        visualDensity: visualDensity,
        iconSize: size,
        splashRadius: splashRadius,
        icon: SvgIcon(
          name: name,
          size: size,
          colorFilter: colorFilter,
        ),
      );
}
