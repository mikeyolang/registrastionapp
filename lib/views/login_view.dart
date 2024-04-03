// ignore_for_file: use_build_context_synchronously, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registrastionapp/Services/Auth/auth_exceptions.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_bloc.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_event.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_state.dart';
import 'package:registrastionapp/Utilities/dialogs/leading_dialog.dart';
import 'package:registrastionapp/constants/routes.dart';
// import 'dart:developer' as devtools show log;

import '../Utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
            showErrorDialog(
              context,
              "User Not found",
            );
          } else if (state.exception is WrongPasswordException) {
            showErrorDialog(
              context,
              "Wrong Credentials",
            );
          } else if (state.exception is GenericAuthException) {
            showErrorDialog(
              context,
              "Authentication Error",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Log In"),
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
                  context.read<AuthBloc>().add(AuthEventLogIn(
                        email: email,
                        password: password,
                      ));
                },
                child: const Text("Log In"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text("Not Registered Yet, Sign up her!!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
