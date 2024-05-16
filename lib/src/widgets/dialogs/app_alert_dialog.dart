import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';

class AppAlertDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? confirmTitle;
  final String? discardTitle;
  final void Function() onConfirmDialog;
  final void Function()? onCloseDialog;
  final void Function()? onDiscardDialog;
  final Widget? icon;
  final bool isDiscarding;
  final bool isConfirming;
  final bool popDialogOnConfirm;
  final TextAlign messageTextAlign;
  final EdgeInsetsGeometry? confirmButtonPadding;
  final EdgeInsetsGeometry? discardButtonPadding;

  const AppAlertDialog({
    required this.onConfirmDialog,
    this.onDiscardDialog,
    this.onCloseDialog,
    this.title,
    this.message,
    this.confirmTitle,
    this.discardTitle,
    this.icon,
    this.confirmButtonPadding,
    this.discardButtonPadding,
    this.isDiscarding = false,
    this.isConfirming = false,
    this.popDialogOnConfirm = true,
    this.messageTextAlign = TextAlign.start,
    super.key,
  });

  Future<void> _onConfirm(final BuildContext context) async {
    if (popDialogOnConfirm) {
      await Navigator.of(context).maybePop();
    }
    onConfirmDialog();
  }

  @override
  Widget build(final BuildContext context) => Dialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCloseDialog != null
                    ? onCloseDialog!
                    : Navigator.of(context).pop,
              ),
            ),
            _AppAlertDialogContentWidget(
              title: title,
              text: message,
              icon: icon,
              messageTextAlign: messageTextAlign,
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    AppButton.filled(
                      text: confirmTitle ??
                          FlyksoftUILocalization.of(context).save,
                      showLoading: isConfirming,
                      onPressed: () => _onConfirm(context),
                      style: ElevatedButtonTheme.of(context).style?.copyWith(
                            padding: MaterialStatePropertyAll(
                              confirmButtonPadding ??
                                  const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                            ),
                          ),
                    ),
                    AppButton.outlined(
                      text: discardTitle ??
                          FlyksoftUILocalization.of(context).cancel,
                      showLoading: isDiscarding,
                      onPressed: onDiscardDialog ?? Navigator.of(context).pop,
                      style: OutlinedButtonTheme.of(context).style?.copyWith(
                            padding: MaterialStatePropertyAll(
                              discardButtonPadding ??
                                  const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
}

class _AppAlertDialogContentWidget extends StatelessWidget {
  final String? title;
  final String? text;
  final Widget? icon;
  final TextAlign messageTextAlign;

  const _AppAlertDialogContentWidget({
    this.title,
    this.text,
    this.icon,
    this.messageTextAlign = TextAlign.start,
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 40,
          end: 40,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(
                height: 16,
              ),
            ],
            if (title != null && title!.isNotEmpty) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
            if (text != null && text!.isNotEmpty) ...[
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ],
        ),
      );
}
