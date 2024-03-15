import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/model/user_model.dart';
import 'package:firebasebloc/view/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPageWrapper extends StatelessWidget {
  const RegisterPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: RegisterPage(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/login", (route) => false);
          });
        }
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 248, 215, 215),
          body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
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
                            controller: _emailController,
                            hintText: "Enter email",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            validator: (value) {
                              final paswd = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (value!.isEmpty) {
                                return 'please enter the password';
                              } else if (!paswd.hasMatch(value)) {
                                return 'Password should contain at least one upper case, one lower case, one digit, one special character and must be 8 characters in length';
                              }
                            },
                            obscureText: true,
                            controller: _passwordController,
                            hintText: "Enter password",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            validator: (value) {
                              final name = RegExp(r'^[A-Za-z\s]+$');
                              if (value!.isEmpty) {
                                return 'User name can\'t be empty';
                              } else if (!name.hasMatch(value)) {
                                return "Enter a valid name";
                              }
                            },
                            controller: _nameController,
                            hintText: "Enter Username",
                          ),
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
                            controller: _phoneController,
                            hintText: "Enter Phone Number",
                          ),
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
                            controller: _ageController,
                            hintText: "Enter Age",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                UserModel user = UserModel(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phone: _phoneController.text,
                                  age: _ageController.text,
                                );
                                authBloc.add(SignUpEvent(user: user));
                              }
                            },
                            child: Container(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? "),
                                Text(
                                  "Log In",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
