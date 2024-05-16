import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';

class ReadMoreDialog extends StatelessWidget {
  const ReadMoreDialog({
    required this.data,
    super.key,
  });

  final String data;

  @override
  Widget build(final BuildContext context) => Dialog(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: AppText.bodyMedium(
                data,
              ),
            ),
          ),
        ),
      );
}
