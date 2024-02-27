import 'package:flutter/material.dart';
import 'package:registrastionapp/Utilities/dialogs/generic_dialog.dart';

Future<bool> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericErrorDialog(
    context: context,
    title: "An Error Occurred ",
    content: text,
    optionBuilder: () => {
      "Ok": null,
    },
  ).then(
    (value) => value ?? false,
  );
}
