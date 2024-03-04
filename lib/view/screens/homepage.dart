import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/blocs/picture_bloc/picture_bloc.dart';
import 'package:firebasebloc/services/location.dart';
import 'package:firebasebloc/view/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasebloc/view/widgets/textbox.dart';
import 'package:geolocator/geolocator.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

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
          return HomePage();
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // final User user;
  final CurrentLocation currentLocation = CurrentLocation();

  final userCollection = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  @override
  Widget build(BuildContext context) {
    Uint8List? image;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text("home"),
        actions: [
          IconButton(
            onPressed: () {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              authBloc.add(LogOutEvent());
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
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
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: state is UploadPictureSuccess
                          ? CircleAvatar(
                              radius: 55,
                              backgroundImage:
                                  Image.memory(state.userImage).image,
                            )
                          : const CircleAvatar(
                              radius: 55,
                              child: Icon(Icons.person),
                            ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      child: const Text("select"),
                      onPressed: () {
                        BlocProvider.of<PictureBloc>(context)
                            .add(SelectPictureEvent(currentUser.email!));
                      },
                    ),
                  )
                ],
              );
            },
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                if (userData != null) {
                  return Expanded(
                    child: ListView(
                      children: [
                        TextBox(
                            text: userData['name'] ?? '',
                            sectionName: "User Name",
                            onPressed: () {}),
                        TextBox(
                            text: userData['email'] ?? '',
                            sectionName: "Email",
                            onPressed: () {}),
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
                          text: 'text',
                          sectionName: 'Location',
                          onPressed: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 30,
                          ),
                          child: CustomButton(
                            function: () {
                              Navigator.pushNamed(context, '/delete');
                            },
                            text: "Delete Account",
                            color: Colors.red,
                          ),
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
                    child: Text("Error fetching user data: ${snapshot.error}"));
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
  }
}
