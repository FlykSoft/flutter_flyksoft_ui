import 'package:flutter/material.dart';

abstract class AppStatefulFormWidget<T> extends StatefulWidget {
  const AppStatefulFormWidget({
    this.value,
    super.key,
  });

  final T? value;
}

///W is widget type
///S is data type
abstract class AppFormState<W extends AppStatefulFormWidget<T>, T>
    extends State<W> {
  final GlobalKey<FormFieldState<T>> formFieldKey = GlobalKey();

  @override
  void initState() {
    updateForm(validate: false);
    super.initState();
  }

  @override
  void didUpdateWidget(W oldWidget) {
    if (widget.value != oldWidget.value) {
      updateForm();
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateForm({final bool validate = true}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final FormFieldState<T>? state = formFieldKey.currentState;
        if (state != null) {
          state.didChange(widget.value);
          if (validate) {
            state.validate();
          }
        }
      },
    );
  }

  void validate() => formFieldKey.currentState?.validate();
}
