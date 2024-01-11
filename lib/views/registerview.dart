// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:registrastionapp/Services/Auth/auth_exceptions.dart';
import 'package:registrastionapp/Services/Auth/auth_services.dart';
import 'package:registrastionapp/Utilities/show_error.dart';
import 'package:registrastionapp/constants/routes.dart';

import 'dart:developer' as devtools show log;

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
                  final userCredentials =
                      await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  // Sending the Verification Email Directly after registration

                  await AuthService.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  devtools.log(userCredentials.toString());
                } on WeakPasswordException {
                  showErrorDialog(
                    context,
                    "Weak Password",
                  );
                } on EmailAlreadyInUseException {
                  showErrorDialog(
                    context,
                    "The account already exists for that email.",
                  );
                } on InvalidEmailException {
                  showErrorDialog(
                    context,
                    "Invalid Email",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    "Failed to register, Please Try Again",
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
