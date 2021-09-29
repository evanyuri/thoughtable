import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';



class passwordResetScreen extends StatefulWidget {

  @override
  _passwordResetScreenState createState() => _passwordResetScreenState();
}

class _passwordResetScreenState extends State<passwordResetScreen> {
  String email = '';
  String error = '';
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          body: SafeArea(
            child: Center(
              child: ListView(
                  padding: EdgeInsets.only(top: 50.0, left: 30, right: 30),
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Password Reset',
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key:_formkey,
                      child: Column(
                          children: <Widget>[
                            Text(error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                            TextFormField(
                                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {setState(() => email = val);},
                                style: TextStyle(
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '',
                                  labelText: 'email:',
                                )),

                            Container(
                                margin: EdgeInsets.only(top: 2.0),
                                child: ButtonTheme(
                                    minWidth: 200,
                                    child: FlatButton(
                                        color: Colors.purple,
                                        child:
                                        Text('Send Reset Password Link'),
                                        onPressed: () async {
                                          await _firebaseAuth.sendPasswordResetEmail(email: email);

                                          AlertDialog alert = AlertDialog(
                                            title: Text("Password Reset Link Sent"),
                                            content: Text("Check your email to reset your password"),
                                            actions: [
                                              FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    // Navigate to the second screen using a named route.
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                              return LoginScreen();
                                                            }));
                                                  }),

                                            ],
                                          );

// show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        }


                                    ))),
                            Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: ButtonTheme(
                                    minWidth: 200,
                                    child: FlatButton(
                                        color: Colors.transparent,
                                        child: Text('Return to Login'),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return LoginScreen();
                                                  }));
                                        }))),]),
                    )]),),
          )



      ),
    );

  }
}

