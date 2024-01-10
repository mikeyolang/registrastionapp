import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registrastionapp/constants/routes.dart';
import 'package:registrastionapp/views/login_view.dart';
import 'package:registrastionapp/views/notesview.dart';
import 'package:registrastionapp/views/registerview.dart';
import 'package:registrastionapp/views/verifyemail.dart';
// import '';
import 'firebase_options.dart';

// import 'package:registrastionapp/views/registerview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Registration App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 115, 207)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView()
      },
    );
  }
}
