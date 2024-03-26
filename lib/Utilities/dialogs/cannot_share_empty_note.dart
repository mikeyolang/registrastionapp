import 'package:flutter/material.dart';
import 'package:registrastionapp/Utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericErrorDialog(
    context: context,
    title: "Sharing ",
    content: "You can not share an empty note ",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
