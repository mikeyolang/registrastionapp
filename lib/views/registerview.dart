// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registrastionapp/Utilities/show_error.dart';
import 'package:registrastionapp/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter Your Email",
            ),
          ),
          TextField(
            controller: _password,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter Your Password",
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredentials = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Sending the Verification Email Directly after registration
                  final user = FirebaseAuth.instance.currentUser;
                 await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  print(userCredentials);
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                  if (e.code == 'weak-password') {
                    showErrorDialog(
                      context,
                      "Weak Password",
                    );
                  } else if (e.code == 'email-already-in-use') {
                    showErrorDialog(
                      context,
                      "The account already exists for that email.",
                    );
                  } else if (e.code == "invalid-email") {
                    showErrorDialog(
                      context,
                      "Invalid Email",
                    );
                  } else {
                    await showErrorDialog(context, "Error : ${e.code}");
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
              child: const Text("Register"),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already Registered? Log in Here"),
          ),
        ],
      ),
    );
  }
}
