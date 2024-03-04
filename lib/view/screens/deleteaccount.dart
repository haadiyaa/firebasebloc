import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/view/widgets/custombutton.dart';
import 'package:firebasebloc/view/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountWrapper extends StatelessWidget {
  const DeleteAccountWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: DeleteAccount(),
    );
  }
}

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc=BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is DeleteState) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/login", (route) => false);
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: email,
                    hintText: "Email",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: pass,
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    function: () {
                      authBloc.add(DeleteAccountEvent(email: email.text.trim(), password: pass.text.trim()));
                    },
                    text: "Delete",
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
