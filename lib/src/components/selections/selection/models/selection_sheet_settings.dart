import 'package:flutter/material.dart';

import '../../../../models/auto_size_draggable_scrollable_sheet_options.dart';

class SelectionSheetSettings {
  const SelectionSheetSettings({
    this.title,
    this.autoSizeOptions,
    this.itemName,
    this.scrollController,
    this.footerBuilder,
    double? footerHeightFraction,
    this.showCloseIcon = true,
    this.showSearch = false,
  }) : footerHeightFraction =
            footerBuilder != null ? (footerHeightFraction ?? 0.11) : 0;

  ///The text that shows as the title of the selection sheet.
  final String? title;
  final bool showCloseIcon;
  final bool showSearch;
  final AutoSizeDraggableScrollableSheetOptions? autoSizeOptions;

  ///The text that would have been shown in case of no item found, it will show no [itemName] found
  final String? itemName;

  final ScrollController? scrollController;

  ///A widget that displays on the bottom of the sheet if not null.
  final Widget Function(BuildContext context)? footerBuilder;

  ///A number between 0 and 1 which indicates how much of screen height should the footer occupy.
  final double footerHeightFraction;

  SelectionSheetSettings copyWithScrollController(
    ScrollController scrollController,
  ) =>
      SelectionSheetSettings(
        scrollController: scrollController,
        showSearch: showSearch,
        itemName: itemName,
        title: title,
        autoSizeOptions: autoSizeOptions,
        showCloseIcon: showCloseIcon,
      );
}
