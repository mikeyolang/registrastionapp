import 'package:flutter/widgets.dart';
import 'package:registrastionapp/Utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericErrorDialog(
    context: context,
    title: "Password Reset",
    content: "We have Sent you a password reset link in your email",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
