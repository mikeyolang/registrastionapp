import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/Services/Cloud/cloud_note.dart';
import 'package:registrastionapp/Services/Cloud/firebase_cloud_storage.dart';
import 'package:registrastionapp/Utilities/dialogs/cannot_share_empty_note.dart';
import 'package:registrastionapp/Utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  // DatabaseNote? _notes;
  CloudNote? _notes;

  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _notes;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArguments()<CloudNote>();

    if (widgetNote != null) {
      _notes = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    if (widgetNote != null) {
      _notes = widgetNote;
    }

    // Checking if we have an existing note
    final existingNote = _notes;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;

    final userId = currentUser.id;
    final newNote = await _noteService.createNewNote(ownerUserId: userId!);
    _notes = newNote;
    return newNote;
  }

// Deleting the note if it is empty
  void _deleteNoteIfTextIsEmpty() {
    final note = _notes;
    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  // Save note if text is not empty
  void _saveNoteIfTextIsNotEmoty() async {
    final note = _notes;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _saveNoteIfTextIsNotEmoty();
    _deleteNoteIfTextIsEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Note"), actions: [
        IconButton(
          onPressed: () async {
            final text = _textController.text;
            if (_notes == null || text.isEmpty) {
              await showCannotShareEmptyNoteDialog(context);
            } else {
              Share.share(text);
            }
          },
          icon: const Icon(
            Icons.share,
          ),
        ),
      ]),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.done:
              _setupControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Write your Notes",
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
