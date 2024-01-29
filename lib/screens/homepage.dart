import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/views/login_view.dart';
import 'package:registrastionapp/views/notes/notesview.dart';
import 'package:registrastionapp/views/verifyemail.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                }
                return const VerifyEmailView();
              } else {
                return const LoginView();
              }
            // if (user?.emailVerified ?? false) {
            //   return const Text("Done");
            // } else {
            //   const VerifyEmailView();
            // }
            // return const Text("Done");

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
