  import 'package:firebase_core/firebase_core.dart';
import 'package:firebasebloc/firebase_options.dart';
import 'package:firebasebloc/view/screens/homepage.dart';
import 'package:firebasebloc/view/screens/loginpage.dart';
import 'package:firebasebloc/view/screens/registerpage.dart';
import 'package:firebasebloc/view/screens/splashscreen.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context)=>SplashScreenWrapper(),
        '/login':(context)=>LoginPageWrapper(),
        '/home':(context)=>HomePageWrapper(),
        '/register':(context)=>RegisterPageWrapper(),
      },
    );
  }
  
}
