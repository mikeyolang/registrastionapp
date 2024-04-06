import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registrastionapp/Helpers/loading/loading_screen.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_bloc.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_event.dart';
import 'package:registrastionapp/Services/Auth/bloc/bloc/auth_state.dart';
import 'package:registrastionapp/views/forgot_password_view.dart';
import 'package:registrastionapp/views/login_view.dart';
import 'package:registrastionapp/views/notes/notesview.dart';
import 'package:registrastionapp/views/registerview.dart';
import 'package:registrastionapp/views/verifyemail.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: "Please Wait a Momment",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );

    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final user = AuthService.firebase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             return const NotesView();
    //           }
    //           return const VerifyEmailView();
    //         } else {
    //           return const LoginView();
    //         }
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );
  }
}
