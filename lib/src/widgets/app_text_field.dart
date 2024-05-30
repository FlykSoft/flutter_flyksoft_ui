import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    this.controller,
    this.labelText,
    this.hintText,
    this.contentPadding,
    this.keyboardType,
    this.fillColor,
    this.suffixIcon,
    this.prefix,
    this.textInputAction,
    this.validator,
    this.maxLength,
    this.shadowColor,
    this.maxLines,
    this.borderRadius,
    this.showCounter = true,
    this.obscureText = false,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.textStyle,
    this.focusNode,
    this.inputFormatters,
    this.minLines,
    this.border,
    this.prefixIcon,
    this.focusedBorder,
    this.errorBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.prefixIconConstraints,
    this.onFieldSubmitted,
    this.hintStyle,
    this.showClearIcon = true,
    this.autoFocus,
    this.suffixIconSpacing,
    super.key,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefix;
  final TextInputAction? textInputAction;
  final String? Function(String? value)? validator;
  final bool showCounter;
  final int? maxLength;
  final int? maxLines;
  final Color? shadowColor;
  final double? borderRadius;
  final bool enabled;
  final bool? autoFocus;
  final String? initialValue;
  final void Function(String? value)? onChanged;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Widget? prefixIcon;
  final bool showClearIcon;
  final BoxConstraints? prefixIconConstraints;
  final void Function(String value)? onFieldSubmitted;
  final double? suffixIconSpacing;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _showClearIcon = false;

  @override
  void initState() {
    _showClearIcon = _shouldShowClearIcon();
    if (widget.controller != null) {
      widget.controller!.addListener(_showClearIconListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_showClearIconListener);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    if (widget.controller != null &&
        widget.controller != oldWidget.controller) {
      widget.controller!.removeListener(_showClearIconListener);
      widget.controller!.addListener(_showClearIconListener);
      setState(() {
        _showClearIcon = _shouldShowClearIconByController();
      });
    } else if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _showClearIcon = _shouldShowClearIconByInitialValue();
      });
    } else if (widget.showClearIcon != oldWidget.showClearIcon) {
      setState(() {
        _showClearIcon = widget.showClearIcon;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _showClearIconListener() {
    final bool value = _shouldShowClearIconByController();
    if (value != _showClearIcon && mounted) {
      setState(() {
        _showClearIcon = value;
      });
    }
  }

  bool _shouldShowClearIcon() {
    if (widget.controller != null) {
      return _shouldShowClearIconByController();
    } else if (widget.initialValue != null) {
      return _shouldShowClearIconByInitialValue();
    } else {
      return widget.showClearIcon;
    }
  }

  bool _shouldShowClearIconByController() =>
      widget.showClearIcon &&
      (widget.controller != null && widget.controller!.text.isNotEmpty);

  bool _shouldShowClearIconByInitialValue() =>
      widget.showClearIcon &&
      (widget.initialValue != null && widget.initialValue!.isNotEmpty);

  InputBorder? get _border =>
      widget.border ?? Theme.of(context).inputDecorationTheme.border;

  @override
  Widget build(final BuildContext context) {
    final border = _border;
    return TextFormField(
      autofocus: widget.autoFocus ?? false,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      maxLines: widget.maxLines ?? 1,
      controller: widget.controller,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onTap: widget.onTap,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      minLines: widget.minLines,
      decoration: InputDecoration(
        prefixIconConstraints: widget.prefixIconConstraints,
        counterText: widget.showCounter ? null : '',
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        labelText: widget.labelText,
        fillColor: widget.fillColor,
        suffixIcon: _showClearIcon
            ? _SuffixIconWithClearButton(
                onClear: () {
                  widget.controller?.clear();
                  widget.onChanged?.call('');
                },
                showClearIcon: _showClearIcon,
                suffixIcon: widget.suffixIcon,
                suffixIconSpacing: widget.suffixIconSpacing,
              )
            : widget.suffixIcon,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        enabled: widget.enabled,
        border: border,
        focusedBorder: widget.focusedBorder ?? border,
        enabledBorder: widget.enabledBorder ?? border,
        errorBorder: widget.errorBorder ?? border,
        disabledBorder: widget.disabledBorder ?? border,
        contentPadding: widget.contentPadding,
      ),
    );
  }
}

class _SuffixIconWithClearButton extends StatelessWidget {
  const _SuffixIconWithClearButton({
    required this.onClear,
    required this.showClearIcon,
    this.suffixIcon,
    this.suffixIconSpacing,
    super.key,
  });

  final VoidCallback onClear;
  final Widget? suffixIcon;
  final bool showClearIcon;
  final double? suffixIconSpacing;

  @override
  Widget build(BuildContext context) => suffixIcon == null
      ? _ClearIconButton(
          onPressed: onClear,
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ClearIconButton(
              onPressed: onClear,
            ),
            SizedBox(
              width: suffixIconSpacing ?? defaultSuffixIconSpacing,
            ),
            suffixIcon!,
          ],
        );

  final double defaultSuffixIconSpacing = 20;
}

class _ClearIconButton extends StatelessWidget {
  const _ClearIconButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        visualDensity: VisualDensity.compact,
        splashRadius: 16,
        padding: EdgeInsets.zero,
        iconSize: 16,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(
          Icons.clear_outlined,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}
