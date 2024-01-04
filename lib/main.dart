import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registrastionapp/views/login_view.dart';
import 'package:registrastionapp/views/registerview.dart';
// import '';
import 'firebase_options.dart';

// import 'package:registrastionapp/views/registerview.dart';

void main() async{
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
      title: 'Flutter Registration App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const RegisterView(),
      routes: {
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
      },
    );
  }
}
