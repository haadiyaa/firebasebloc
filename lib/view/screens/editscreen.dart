import 'dart:typed_data';

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
    String? image;

  TextEditingController? _nameController;

  TextEditingController? _emailController;

  TextEditingController? _phoneController;

  TextEditingController? _ageController;
  TextEditingController? _locationController;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _ageController = TextEditingController(text: widget.user.age);
    _locationController = TextEditingController(text: widget.user.location);
    image=widget.user.image;
    print(widget.user.location);
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
                          validator: (value) {
                            final name = RegExp(r'^[A-Za-z\s]+$');
                            if (value!.isEmpty) {
                              return 'User name can\'t be empty';
                            } else if (!name.hasMatch(value)) {
                              return "Enter a valid name";
                            }
                          },
                          controller: _nameController!,
                          hintText: 'User Name'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            final emailReg = RegExp(
                                r"^[a-zA-Z0-9_\-\.\S]{4,}[@][a-z]+[\.][a-z]{2,3}$");
                            if (!emailReg.hasMatch(value)) {
                              return 'Invalid email address!';
                            }
                          },
                          controller: _emailController!,
                          hintText: 'Email'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          validator: (value) {
                            final reg2 = RegExp(r"^[6789]\d{9}$");
                            if (value!.isEmpty) {
                              return 'Number can\'t be empty';
                            } else if (value.length > 10) {
                              return "number exact 10";
                            } else if (!reg2.hasMatch(value)) {
                              return 'Enter a valid phone number';
                            }
                          },
                          controller: _phoneController!,
                          hintText: 'Phone Number'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          validator: (value) {
                            final agee = RegExp(r"^[0-9]{1,2}$");
                            if (value!.isEmpty) {
                              return 'Age can\'t be empty';
                            } else if (value.length > 2) {
                              return "Enter valid age";
                            } else if (!agee.hasMatch(value)) {
                              return 'Invalid age!';
                            } else if (int.parse(value) < 18) {
                              return 'Age must be greater than 18';
                            }
                          },
                          controller: _ageController!,
                          hintText: 'Age'),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        validator: (value) {
                              final location = RegExp(r'^[A-Za-z0-9\s\.\,\-]+$');
                              if (value!.isEmpty) {
                                return 'Address name can\'t be empty';
                              } else if (!location.hasMatch(value)) {
                                return "Enter a valid Address";
                              }
                            },
                          controller: _locationController!,
                          hintText: 'Location'),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        function: () {
                          if (_key.currentState!.validate()) {
                            UserModel user = UserModel(
                              uid: widget.user.uid,
                              name: _nameController!.text,
                              email: _emailController!.text,
                              phone: _phoneController!.text,
                              age: _ageController!.text,
                              location: _locationController!.text,
                              image:image,
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
