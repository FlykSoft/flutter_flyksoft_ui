import 'package:flutter/material.dart';

import '../models/auto_size_draggable_scrollable_sheet_options.dart';

class AutoSizeDraggableScrollableSheet extends StatelessWidget {
  const AutoSizeDraggableScrollableSheet({
    required this.options,
    required this.builder,
    super.key,
  });

  final AutoSizeDraggableScrollableSheetOptions options;
  final ScrollableWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final double min = _minChildSize();
    final double max = _maxChildSize();
    return DraggableScrollableSheet(
      initialChildSize: min,
      maxChildSize: max,
      minChildSize: min,
      snap: true,
      expand: false,
      snapSizes: [
        min,
        if (min != max) max,
      ],
      builder: builder,
    );
  }

  double _maxChildSize() {
    final size = (options.itemLength * options.itemSize) +
        options.headerSize +
        options.footerSize;
    return _checkMaxAndMinSizes(size);
  }

  double _minChildSize() {
    final size = ((options.itemLength > options.maxInitialItemsInMinSize
                ? options.maxInitialItemsInMinSize
                : options.itemLength) *
            options.itemSize) +
        options.headerSize +
        options.footerSize;
    return _checkMaxAndMinSizes(size);
  }

  double _checkMaxAndMinSizes(final double size) {
    if (size > options.maxSize) {
      return options.maxSize;
    } else if (size < options.minSize) {
      return options.minSize;
    } else {
      return size;
    }
  }
}
