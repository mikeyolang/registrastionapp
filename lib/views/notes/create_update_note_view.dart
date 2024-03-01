import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/Services/crud/notes_service.dart';
import 'package:registrastionapp/Utilities/generics/get_arguments.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _notes;

  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
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
      note: note,
      text: text,
    );
  }

  void _setupControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOfGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArguments()<DatabaseNote>();

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
    final email = currentUser.email!;
    final owner = await _noteService.getUser(email: email);
    final newNote = await _noteService.createNote(owner: owner!);
    _notes = newNote;
    return newNote;
  }

// Deleting the note if it is empty
  void _deleteNoteIfTextIsEmpty() {
    final note = _notes;
    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  // Save note if text is not empty
  void _saveNoteIfTextIsNotEmoty() async {
    final note = _notes;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
        note: note,
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
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
        future: createOfGetExistingNote(context),
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
