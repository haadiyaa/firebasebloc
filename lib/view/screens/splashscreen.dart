import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/view/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
      child: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {

        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, "/home");
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePageWrapper(user: state.user ,pos: state.position!, address: state.address!)));
        }
        else if(state is UnAuthenticated){
          Navigator.pushReplacementNamed(context, "/login");
        }

      },
      child:const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/flutterlogo.jpg"),
                width: 200,
                height: 200,
              ),
              Text(
                "Firebase BLoC",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 33, 68, 129),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
