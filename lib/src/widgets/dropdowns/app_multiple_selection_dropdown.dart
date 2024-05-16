import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';

class AppMultipleSelectionDropdown<T> extends StatefulWidget {
  const AppMultipleSelectionDropdown({
    required this.onChanged,
    required this.dataSource,
    required this.itemAsString,
    this.values,
    this.selectionItemBuilder,
    this.textStyle,
    this.validator,
    this.padding,
    this.flexFit = FlexFit.tight,
    this.borderRadius,
    this.hintText,
    this.itemPluralName,
    this.mainAxisSize = MainAxisSize.max,
    this.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final SelectionDataSource<T> dataSource;
  final List<T>? values;
  final void Function(List<T> item) onChanged;
  final String Function(T item) itemAsString;
  final TextStyle? textStyle;
  final String? Function(String? value)? validator;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final FlexFit flexFit;
  final String? itemPluralName;
  final SelectionSheetSettings selectionSettings;
  final Widget Function(T item)? selectionItemBuilder;
  final BorderRadius? borderRadius;

  @override
  State<AppMultipleSelectionDropdown<T>> createState() =>
      _AppMultipleSelectionDropdownState<T>();
}

class _AppMultipleSelectionDropdownState<T>
    extends State<AppMultipleSelectionDropdown<T>> {
  final GlobalKey<FormFieldState<T>> _formFieldKey = GlobalKey();

  void _showSelectionBottomSheet(final BuildContext context) =>
      MultipleSelectionSheet<T>(
        dataSource: widget.dataSource,
        onChanged: (items) {
          widget.onChanged(items);
          final FormFieldState<T>? state = _formFieldKey.currentState;
          if (state != null) {
            state.didChange(items.first);
            state.validate();
          }
        },
        itemViewOptions: SelectionItemViewOptions(
          itemBuilder: widget.selectionItemBuilder,
          itemAsString: widget.itemAsString,
        ),
        selectionSettings: widget.selectionSettings,
        values: widget.values ?? [],
      ).show(context);

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: () => _showSelectionBottomSheet(context),
        borderRadius: widget.borderRadius ??
            const BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
        child: _DropdownForm<T>(
          itemAsString: widget.itemAsString,
          validator: widget.validator,
          mainAxisSize: widget.mainAxisSize,
          padding: widget.padding,
          hintText: widget.hintText,
          textStyle: widget.textStyle,
          values: widget.values,
          key: _formFieldKey,
          itemPluralName: widget.itemPluralName,
          borderRadius: widget.borderRadius,
        ),
      );
}

class _DropdownForm<T> extends FormField<T> {
  final List<T>? values;
  final String Function(T item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final String? itemPluralName;
  final BorderRadius? borderRadius;

  _DropdownForm({
    required this.itemAsString,
    this.values,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.itemPluralName,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    final String? Function(String? value)? validator,
    super.initialValue,
    super.onSaved,
    super.autovalidateMode,
    super.key,
  }) : super(
          validator: validator != null
              ? (item) => validator(item != null ? itemAsString(item) : '')
              : null,
          builder: (field) => validator == null
              ? _NormalDropdown(
                  itemAsString: itemAsString,
                  values: values,
                  padding: padding,
                  hintText: hintText,
                  mainAxisSize: mainAxisSize,
                  textStyle: textStyle,
                  itemPluralName: itemPluralName,
                  borderRadius: borderRadius,
                )
              : _NormalFormDropdown(
                  itemAsString: itemAsString,
                  values: values,
                  padding: padding,
                  hintText: hintText,
                  mainAxisSize: mainAxisSize,
                  textStyle: textStyle,
                  errorText: field.errorText,
                  hasError: field.hasError,
                  itemPluralName: itemPluralName,
                  borderRadius: borderRadius,
                ),
        );
}

class _NormalFormDropdown<T> extends StatefulWidget {
  const _NormalFormDropdown({
    required this.itemAsString,
    this.values,
    this.textStyle,
    this.padding,
    this.hasError = false,
    this.errorText,
    this.borderRadius,
    this.itemPluralName,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final List<T>? values;
  final String Function(T item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final bool hasError;
  final String? errorText;
  final String? itemPluralName;
  final BorderRadius? borderRadius;

  @override
  State<_NormalFormDropdown<T>> createState() => _NormalFormDropdownState<T>();
}

class _NormalFormDropdownState<T> extends State<_NormalFormDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 167),
      vsync: this,
    );
    if (_hasError) {
      _controller.value = 1.0;
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NormalFormDropdown<T> old) {
    super.didUpdateWidget(old);

    final String? newErrorText = widget.errorText;
    final String? oldErrorText = old.errorText;

    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);

    if (errorTextStateChanged) {
      if (newErrorText != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  bool get _hasError => widget.errorText != null && widget.hasError;

  void _handleChange() {
    setState(() {
      // The _controller's value has changed.
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NormalDropdown(
            itemAsString: widget.itemAsString,
            values: widget.values,
            padding: widget.padding,
            hintText: widget.hintText,
            mainAxisSize: widget.mainAxisSize,
            textStyle: widget.textStyle,
            itemPluralName: widget.itemPluralName,
            borderRadius: widget.borderRadius,
          ),
          if (_hasError)
            Semantics(
              container: true,
              child: FadeTransition(
                opacity: _controller,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: const Offset(0.0, -0.25),
                    end: Offset.zero,
                  ).evaluate(_controller.view),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 8,
                      start: widget.padding?.horizontal ?? 10,
                      end: widget.padding?.horizontal ?? 10,
                    ),
                    child: Text(
                      widget.errorText!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
}

class _NormalDropdown<T> extends StatelessWidget {
  const _NormalDropdown({
    required this.itemAsString,
    this.values,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.itemPluralName,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final List<T>? values;
  final String Function(T item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final String? itemPluralName;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(
                  8,
                ),
              ),
          border: const Border.fromBorderSide(
            BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 10,
            ),
        child: Row(
          mainAxisSize: mainAxisSize,
          children: [
            Expanded(
              child: AppText(
                values != null && values!.isNotEmpty
                    ? values!.length == 1
                        ? itemAsString(values!.first)
                        : '${values!.length} ${itemPluralName ?? FlyksoftUILocalization.of(context).items}'
                    : hintText ?? FlyksoftUILocalization.of(context).select,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: textStyle ??
                    (values != null && values!.isNotEmpty
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.normal,
                            )),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
}
