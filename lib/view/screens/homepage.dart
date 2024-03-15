import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/blocs/picture_bloc/picture_bloc.dart';
import 'package:firebasebloc/model/user_model.dart';
import 'package:firebasebloc/services/location.dart';
import 'package:firebasebloc/view/screens/editscreen.dart';
import 'package:firebasebloc/view/widgets/custombutton.dart';
import 'package:firebasebloc/view/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasebloc/view/widgets/textbox.dart';
import 'package:geolocator/geolocator.dart';

class HomePageWrapper extends StatelessWidget {
  HomePageWrapper({super.key, this.pos, this.address, this.user});
  Position? pos;
  String? address;
  final User? user;


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => PictureBloc(),
        )
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return HomePage(
            user: user,
            pos: pos,
            address: address,
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, this.pos, this.address, this.user});
  Position? pos;
  String? address;

  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userCollection = FirebaseFirestore.instance.collection("users");

  dynamic _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser= FirebaseAuth.instance.currentUser !;
  }

  @override
  Widget build(BuildContext context) {
    String? image;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is UnAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/login", (route) => false);
          });
        }
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 233, 233, 233),
          appBar: AppBar(
            title: Text("home"),
            actions: [
              IconButton(
                onPressed: () {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(LogOutEvent());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Column(
            children: [
              BlocBuilder<PictureBloc, PictureState>(
                builder: (context, state) {
                  if (state is UploadPictureSuccess) {
                    image = state.userImage;
                  }
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: userCollection
                              .where('email', isEqualTo: _currentUser.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircleAvatar(
                                  radius: 55,
                                  child: Icon(Icons.person),
                                ),
                              );
                            }
                            var user = snapshot.data?.docs.isNotEmpty ?? false
                                ? snapshot.data!.docs[0].data()
                                : null;
                            var _imageUrl =
                                (user as Map<String, dynamic>?)?['image'];
                            return Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: _imageUrl == null
                                    ? const CircleAvatar(
                                        radius: 55,
                                        child: Icon(Icons.person),
                                      )
                                    : CircleAvatar(
                                        radius: 55,
                                        backgroundImage:
                                            NetworkImage(_imageUrl),
                                      ),
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: CustomButton(
                              fsize: 15,
                              height: 25,
                                function: () {
                                  BlocProvider.of<PictureBloc>(context).add(
                                      SelectPictureEvent(_currentUser.email!));
                                },
                                text: "Change profile picture")),
                      )
                    ],
                  );
                },
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(_currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>?;

                    if (userData != null) {
                      return Expanded(
                        child: ListView(
                          children: [
                            TextBox(
                              text: userData['name'] ?? '',
                              sectionName: "User Name",
                              onPressed: () {
                                // _editTask(context, userData['name'], 'name');
                              },
                            ),
                            TextBox(
                              text: userData['email'] ?? '',
                              sectionName: "Email",
                              onPressed: () {},
                            ),
                            TextBox(
                              text: userData["phone"] ?? '',
                              sectionName: "Phone number",
                              onPressed: () {},
                            ),
                            TextBox(
                              text: userData["age"] ?? '',
                              sectionName: "Age",
                              onPressed: () {},
                            ),
                            TextBox(
                              text: userData['location'] ?? widget.address,
                              sectionName: 'Location',
                              onPressed: () {},
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: CustomButton(
                                function: () {
                                  Navigator.pushNamed(context, '/delete');
                                },
                                text: "Delete Account",
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: CustomButton(
                                function: () {
                                  final user = UserModel(
                                    uid: userData['uid'],
                                    email: userData['email'],
                                    name: userData['name'],
                                    phone: userData['phone'],
                                    age: userData['age'],
                                    location: userData['location'],
                                    image: userData['image'],
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreenWrapper(user: user),
                                      ));
                                },
                                text: 'Edit Profile',
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text("null"),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            "Error fetching user data: ${snapshot.error}"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
