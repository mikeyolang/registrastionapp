import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registrastionapp/firebase_options.dart';
import 'package:registrastionapp/views/login_view.dart';
import 'package:registrastionapp/views/notesview.dart';
import 'package:registrastionapp/views/verifyemail.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
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
