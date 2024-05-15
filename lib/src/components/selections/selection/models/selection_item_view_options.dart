import 'package:flutter/material.dart';

class SelectionItemViewOptions<T> {
  final String? Function(T item)? itemAsString;
  final Widget Function(T item)? itemBuilder;

  SelectionItemViewOptions({
    this.itemBuilder,
    this.itemAsString,
  }) : assert(
          itemAsString != null || itemBuilder != null,
          'Either item as string or item builder must be provided',
        );
}
