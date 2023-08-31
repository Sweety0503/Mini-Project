import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ourapp/provider/internet.dart';
import 'package:ourapp/provider/signIn.dart';
import 'package:provider/provider.dart';
import 'package:ourapp/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => signIn()),
        ),
        ChangeNotifierProvider(create: ((context) => InternetProvider()))
      ],
      child: const MaterialApp(
        home: login(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
