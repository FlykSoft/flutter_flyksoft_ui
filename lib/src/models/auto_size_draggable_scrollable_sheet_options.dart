class AutoSizeDraggableScrollableSheetOptions {
  final int itemLength;
  final double itemSize;
  final double headerSize;
  final double footerSize;
  final double minSize;
  final double maxSize;
  final bool snap;
  final bool expand;
  final int maxInitialItemsInMinSize;

  const AutoSizeDraggableScrollableSheetOptions({
    required this.itemLength,
    required this.itemSize,
    this.minSize = 0.28,
    this.maxSize = 0.92,
    this.headerSize = 0,
    this.footerSize = 0,
    this.maxInitialItemsInMinSize = 3,
    this.expand = true,
    this.snap = false,
  });
}
