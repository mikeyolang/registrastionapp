import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_bloc.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_event.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_state.dart';
import 'package:registrastionapp/Utilities/dialogs/error_dialog.dart';

import '../Utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              // ignore: use_build_context_synchronously
              context,
              "We could not process your request. Please make sure you are a registered user ",
            );
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const Text("Enter Your Email to recieve the password reset link"),
            TextField(
              autocorrect: false,
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your Email",
              ),
              enableSuggestions: false,
            ),
            TextButton(
              onPressed: () {
                final email = _controller.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventForgotPassword(email: email));
              },
              child: const Text("Send Password Reset Link"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text("Back To Log in"),
            )
          ],
        ),
      ),
    );
  }
}
