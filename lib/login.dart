import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'createAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'passwordReset.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
              padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30),
              children: <Widget>[
                Image.asset('images/Logo.png', height: 90, width: 90),
                Center(
                    child: Text(
                      'Thoughtable',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        TextFormField(
                            validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => _email = val);
                            },
                            style: TextStyle(
                              decorationColor: Colors.white,
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'email',
                              labelText: null,
                            )),
                        Form(
                            child: TextFormField(
                                obscureText: true,
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null,
                                onChanged: (val) {
                                  setState(() => _password = val);
                                },
                                style: TextStyle(
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'password',
                                  labelText: null,
                                ))),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ButtonTheme(
                        minWidth: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.purple,
                          child: Text('Login'),
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {

                              final FirebaseAuth _auth = FirebaseAuth.instance;

                              User user;
                              String errorMessage;

                              try {
                                UserCredential result = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
                                user = result.user;
                                if (user != null) {
                                Navigator.push(context,
                                MaterialPageRoute(
                                builder: (context) {
                                  return home();}));
                                }
                              } catch (error) {

                                switch (error) {
                                  case "invalid-email":
                                    setState(() => _errorMessage = "Invalid email or password");
                                    break;
                                  case "wrong-password":
                                    setState(() => _errorMessage = "Invalid email or password");
                                    break;
                                  case "user-not-found":
                                    setState(() => _errorMessage = "Invalid email or password");
                                    break;
                                  case "user-disabled":
                                    setState(() => _errorMessage = "User with this email has been disabled.");
                                    break;
                                  default:
                                    setState(() => _errorMessage = "An undefined Error happened.");
                                }
                                print(_errorMessage);
                                print(error);
                              }

                            }




                          },
                        ))),
                Container(
                  margin: EdgeInsets.only(top: 2.0),
                  child: ButtonTheme(
                      minWidth: 200,
                      child: FlatButton(
                        color: Colors.transparent,
                        child: Text('Create Account'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return CreateAccountScreen();
                                  }));                    },
                      )),
                ),

                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(top: 100.0),
                      child: ButtonTheme(
                        minWidth: 200,
                        child: FlatButton(
                            color: Colors.transparent,
                            child: Text('Forgot Password'),
                            onPressed: () {
                              // Navigate to the second screen using a named route.
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return passwordResetScreen();
                                      }));
                            }),
                      )),
                ),

              ]),
        ));
  }
}
