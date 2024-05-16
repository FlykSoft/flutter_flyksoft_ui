import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flyksoft_ui/flyksoft_ui.dart';

import 'dialogs/read_more_dialog.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(
    this.data, {
    this.colorClickableText,
    this.trimConfiguration,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.semanticsLabel,
    this.seeMoreInDialog = false,
    super.key,
  });

  final String data;
  final Color? colorClickableText;
  final TrimConfiguration? trimConfiguration;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final String? semanticsLabel;
  final bool seeMoreInDialog;

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

const String _kEllipsis = '\u2026';

const String _kLineSeparator = '\u2028';

class ReadMoreTextState extends State<ReadMoreText> {
  bool _isCollapsed = true;
  TextStyle? effectiveTextStyle;
  late final TrimConfiguration _trimConfiguration;

  @override
  void initState() {
    _trimConfiguration = widget.trimConfiguration ?? TrimConfiguration();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    _initEffectiveTextStyle(defaultTextStyle);

    if (_trimConfiguration.trimMode == TrimMode.none) {
      _isCollapsed = false;

      return RichText(
        text: TextSpan(
          style: effectiveTextStyle,
          text: widget.data,
        ),
        textAlign: _textAlign(defaultTextStyle),
        textDirection: _textDirection,
        textScaleFactor: _textScaleFactor,
      );
    }

    final TextSpan link = TextSpan(
      text: _isCollapsed ? _trimCollapsedText : _trimExpandedText,
      style: _clickableTextStyle(),
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    Widget result = LayoutBuilder(
      builder: (
        final context,
        final constraints,
      ) {
        assert(
          constraints.hasBoundedWidth,
          'Read more text requires bounded width',
        );

        final TextSpan textSpan;
        switch (_trimConfiguration.trimMode) {
          case TrimMode.none:
            textSpan = const TextSpan();
            break;
          case TrimMode.length:
            if (_trimConfiguration.trimLength < widget.data.length) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: _isCollapsed
                    ? widget.data.substring(0, _trimConfiguration.trimLength)
                    : widget.data,
                children: <TextSpan>[link],
              );
            } else {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              );
            }
            break;
          case TrimMode.line:
            final double maxWidth = constraints.maxWidth;

            // Create a TextSpan with data
            final text = TextSpan(
              style: effectiveTextStyle,
              text: widget.data,
            );

            // Layout and measure link
            final TextPainter textPainter = TextPainter(
              text: link,
              textAlign: _textAlign(defaultTextStyle),
              textDirection: _textDirection,
              textScaleFactor: _textScaleFactor,
              maxLines: _trimConfiguration.trimLines,
              ellipsis: defaultTextStyle.overflow == TextOverflow.ellipsis
                  ? _kEllipsis
                  : null,
              locale: _locale,
            );
            textPainter.layout(
              minWidth: constraints.minWidth,
              maxWidth: maxWidth,
            );
            final linkSize = textPainter.size;

            // Layout and measure text
            textPainter.text = text;
            textPainter.layout(
              minWidth: constraints.minWidth,
              maxWidth: maxWidth,
            );
            final textSize = textPainter.size;

            // Get the endIndex of data
            bool linkLongerThanLine = false;
            int? endIndex;

            if (linkSize.width < maxWidth) {
              final pos = textPainter.getPositionForOffset(
                Offset(
                  textSize.width - linkSize.width,
                  textSize.height,
                ),
              );
              endIndex = textPainter.getOffsetBefore(pos.offset);
            } else {
              final pos = textPainter.getPositionForOffset(
                textSize.bottomLeft(Offset.zero),
              );
              endIndex = pos.offset;
              linkLongerThanLine = true;
            }

            if (textPainter.didExceedMaxLines) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: _isCollapsed
                    ? widget.data.substring(0, endIndex) +
                        (linkLongerThanLine ? _kLineSeparator : '')
                    : widget.data,
                children: <TextSpan>[link],
              );
            } else {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              );
            }
            break;
        }

        return RichText(
          text: textSpan,
          textAlign: _textAlign(defaultTextStyle),
          textDirection: _textDirection,
          textScaleFactor: _textScaleFactor,
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }

  void _onTapLink() {
    if (widget.seeMoreInDialog) {
      showDialog(
        context: context,
        builder: (final context) => ReadMoreDialog(
          data: widget.data,
        ),
      );
    } else {
      setState(() => _isCollapsed = !_isCollapsed);
    }
  }

  void _initEffectiveTextStyle(DefaultTextStyle defaultTextStyle) {
    effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
  }

  TextStyle? _clickableTextStyle() => effectiveTextStyle?.copyWith(
        color: _colorClickableText,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      );

  double get _textScaleFactor =>
      widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);

  Locale? get _locale => widget.locale ?? Localizations.maybeLocaleOf(context);

  TextDirection get _textDirection =>
      widget.textDirection ?? Directionality.of(context);

  TextAlign _textAlign(DefaultTextStyle defaultTextStyle) =>
      widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;

  Color get _colorClickableText =>
      widget.colorClickableText ?? Theme.of(context).colorScheme.primary;

  String get _trimExpandedText =>
      ' ${FlyksoftUILocalization.of(context).seeLess}';

  String get _trimCollapsedText =>
      ' ...${FlyksoftUILocalization.of(context).seeMore}';
}

class TrimConfiguration {
  final TrimMode trimMode;
  final int trimLines;
  final int trimLength;

  TrimConfiguration({
    this.trimMode = TrimMode.line,
    this.trimLines = 5,
    this.trimLength = 240,
  }) : assert(
          trimMode != TrimMode.line || trimLines > 0,
          'If trim mode is line, trimLines should greater than zero',
        );
}

enum TrimMode {
  length,
  line,
  none,
}
