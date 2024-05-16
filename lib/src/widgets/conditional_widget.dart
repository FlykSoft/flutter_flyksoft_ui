import 'package:flutter/cupertino.dart';

class ConditionalWidget<T extends Widget, S extends Widget>
    extends StatelessWidget {
  final T Function(S child) conditionBuilder;
  final S child;
  final bool condition;

  const ConditionalWidget({
    required this.conditionBuilder,
    required this.condition,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      condition ? conditionBuilder(child) : child;
}
