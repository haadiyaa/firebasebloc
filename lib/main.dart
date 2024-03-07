  import 'package:firebase_core/firebase_core.dart';
import 'package:firebasebloc/firebase_options.dart';
import 'package:firebasebloc/services/notification.dart';
import 'package:firebasebloc/view/screens/deleteaccount.dart';
import 'package:firebasebloc/view/screens/editscreen.dart';
import 'package:firebasebloc/view/screens/homepage.dart';
import 'package:firebasebloc/view/screens/loginpage.dart';
import 'package:firebasebloc/view/screens/registerpage.dart';
import 'package:firebasebloc/view/screens/splashscreen.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotification().initNotification();
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
        '/':(context)=>const SplashScreenWrapper(),
        '/login':(context)=>const LoginPageWrapper(),
        '/home':(context)=>const HomePageWrapper(),
        '/register':(context)=>const RegisterPageWrapper(),
        '/delete':(context)=> const DeleteAccountWrapper(),
        // '/edit':(context)=>  EditScreen(),
      },
    );
  }
  
}
