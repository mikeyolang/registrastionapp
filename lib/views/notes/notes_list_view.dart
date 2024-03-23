import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Cloud/cloud_note.dart';
import 'package:registrastionapp/Services/crud/notes_service.dart';
import 'package:registrastionapp/Utilities/dialogs/error_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () => onTap(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async {
              final shoulDelete = await showErrorDialog(
                context,
                "Are you sure you want to delete this note?",
              );
              if (shoulDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
