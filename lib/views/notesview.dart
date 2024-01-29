import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/Services/crud/notes_service.dart';
import 'package:registrastionapp/constants/routes.dart';

import '../Enums/menu_action.dart';
import '../Utilities/logout_alert.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  String userEmail = AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    _noteService = NoteService();
    _noteService.openDb();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log Out"),
              ),
            ];
          })
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text("Waiting for All Notes...");

                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
