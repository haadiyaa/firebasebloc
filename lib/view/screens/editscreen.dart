import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/model/user_model.dart';
import 'package:firebasebloc/view/widgets/custombutton.dart';
import 'package:firebasebloc/view/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScreenWrapper extends StatelessWidget {
  const EditScreenWrapper({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: EditScreen(
        user: user,
      ),
    );
  }
}

class EditScreen extends StatefulWidget {
  final UserModel user;
  EditScreen({super.key, required this.user});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController? _nameController;

  TextEditingController? _emailController;

  TextEditingController? _phoneController;

  TextEditingController? _ageController;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _ageController = TextEditingController(text: widget.user.age);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Details"),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is UpdateFieldState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (route) => false);
              });
            }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _nameController!, hintText: 'User Name'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: _emailController!, hintText: 'Email'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: _phoneController!,
                          hintText: 'Phone Number'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: _ageController!, hintText: 'Age'),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        function: () {
                          if (_key.currentState!.validate()) {
                            UserModel user = UserModel(
                              uid: widget.user.uid,
                              name: _nameController!.text,
                              email:_emailController!.text,
                              phone: _phoneController!.text,
                              age: _ageController!.text,
                            );
                            authBloc.add(UpdateFieldEvent(user: user));
                          }
                        },
                        text: "Update",
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
