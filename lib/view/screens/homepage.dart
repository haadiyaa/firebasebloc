import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasebloc/view/widgets/textbox.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // late User user;

  final userCollection = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(
            height: 20,
          ),
          // Center(
          //   child: StreamBuilder<QuerySnapshot>(
          //       stream: FirebaseFirestore.instance
          //           .collection("Users")
          //           .where("email", isEqualTo: user!.email)
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         if (!snapshot.hasData) {
          //           return const CircleAvatar(
          //             radius: 55,
          //             child: Icon(
          //               Icons.person,
          //               size: 50,
          //             ),
          //           );
          //         }
          //         var userr = snapshot.data?.docs.isNotEmpty ?? false
          //             ? snapshot.data!.docs[0].data()
          //             : null;
          //         var imageUrl = (userr as Map<String, dynamic>?)?["image"];

          //         return ClipRRect(
          //           borderRadius: const BorderRadius.all(Radius.circular(100)),
          //           child: imageUrl == null
          //               ? const CircleAvatar(
          //                   radius: 50,
          //                   child: Icon(
          //                     Icons.person,
          //                     size: 55,
          //                   ),
          //                 )
          //               : Image(
          //                   width: 90,
          //                   height: 90,
          //                   fit: BoxFit.cover,
          //                   image: NetworkImage(imageUrl),
          //                 ),
          //         );
          //       }),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Center(
          //   child: TextButton(
          //       onPressed: () {
          //         
          //       },
          //       child: const Text("change profile image")),
          // ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "My Details",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextBox(
                            text: userData['name'] ?? '',
                            sectionName: "User Name",
                            onPressed: () {} 
                            ),
                        TextBox(
                            text: userData['email'] ?? '',
                            sectionName: "Email",
                            onPressed: () {} 
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
