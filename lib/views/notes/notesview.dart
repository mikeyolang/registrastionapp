import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_bloc.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_event.dart';
import 'package:registrastionapp/Services/Cloud/cloud_note.dart';
import 'package:registrastionapp/Services/Cloud/firebase_cloud_storage.dart';
import 'package:registrastionapp/constants/routes.dart';
import 'package:registrastionapp/views/notes/notes_list_view.dart';

import '../../Enums/menu_action.dart';
import '../../Utilities/logout_alert.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String userId = AuthService.firebase().currentUser!.id!;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    // _noteService.openDb();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _noteService.closeDb();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Notes"),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(creatOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                    // await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
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
        body: StreamBuilder(
          stream: _noteService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                      notes: allNotes,
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          creatOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                      onDeleteNote: (note) async {
                        await _noteService.deleteNote(
                          documentId: note.documentId,
                        );
                      });
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
