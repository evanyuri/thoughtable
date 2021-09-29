import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';


User currentFirebaseUser = FirebaseAuth.instance.currentUser;


class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  @override


  @override
  Widget build(BuildContext context) {
    return Text("...");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error loading app');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'MyApp',
              theme: ThemeData(
                textTheme: TextTheme(subtitle1: TextStyle(color: Colors.teal)),
                primaryColor: Colors.teal,
                accentColor: Colors.teal,
                brightness: Brightness.dark,
              ),
              home: currentFirebaseUser == null ? LoginScreen() : home()
            );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

