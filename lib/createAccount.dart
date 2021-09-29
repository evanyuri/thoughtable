import 'package:flutter/material.dart';
import 'package:thoughtable/home.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateAccountScreen extends StatefulWidget {

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String accountType = '';
bool accountActive;
  bool _pressed = false ;
  bool _termsCheck = false;
bool _validator;
  String email = '';
  String password = '';
  String passwordConfirm ='';
  String _error = '';

  final _formkey = GlobalKey<FormState>();
  bool showProgress = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Scaffold(
                body: SafeArea(
                  child: Center(
                    child: ListView(
                        padding: EdgeInsets.only(top: 50.0, left: 30, right: 30),
                        children: <Widget>[
                          Form(
                            key:_formkey,
                            child: Column(
                                children: <Widget>[
                                  Container(height:20),
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
                                  TextFormField(
                                      obscureText: true,
                                      validator: (val) => val.length < 6  ? 'Enter a password 6+ chars long' : null,
                                      onChanged: (val) {setState(() => password = val);},
                                      style: TextStyle(
                                        decorationColor: Colors.white,
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: '',
                                        labelText: 'new password:',
                                      )),
                                  TextFormField(
                                      obscureText: true,
                                      validator: (val) => val.length < 6  ? 'Enter a password 6+ chars long' : null,
                                      onChanged: (val) {setState(() => passwordConfirm = val);},
                                      style: TextStyle(
                                        decorationColor: Colors.white,
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: '',
                                        labelText: 'confirm password:',
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 0.0),
                                    child: ButtonTheme(
                                        minWidth: 200,
                                        child: FlatButton(
                                          color: Colors.transparent,
                                          child: Text('Terms and Conditions',
                                              style: TextStyle(color: Colors.purpleAccent)),
                                          onPressed: () {
                                            launch("https://www.netbor.org");
                                          },
                                        )),
                                  ),
                                  CheckboxListTile(
                                    title: Text("I have read and agree to Thoughtable's terms and conditions",
                                        style: TextStyle(color: Colors.purpleAccent)),
                                    value: _termsCheck,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _termsCheck = value;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 2.0),
                                      child: ButtonTheme(
                                          minWidth: 200,
                                          child: Stack(
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                ),
                                                Center(
                                                  child: FlatButton(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0),
                                                      ),
                                                      color: Colors.purple,
                                                      child:
                                                      Text('Create Account'),
                                                      onPressed: _pressed
                                                          ? null : () async {
                                                        setState(() => _pressed = true); // dissable button double press

                                                        accountType = 'ind';
                                                        accountActive = true;

                                                        _validator = true;
                                                        print("init validator: " + _validator.toString());

                                                        print(_termsCheck);

                                                        if (_termsCheck == false) {setState(() => {
                                                          _error = 'Must agree to terms and conditions',
                                                          _validator = false});}
                                                        print("terms validator: " + _validator.toString());

                                                        if (password != passwordConfirm) {setState(() => {
                                                          _error = 'passwords do not match',
                                                          _validator = false});}
                                                        print("password validator: " + _validator.toString());

                                                        if (_validator == true) {
                                                          if (_formkey.currentState.validate()) {
    setState(() {
    showProgress = true;
    });

    UserCredential result = await _auth.createUserWithEmailAndPassword(
    email: email, password: password);
    User user = result.user;
    final userid = user.uid;
    final CollectionReference userCollection = FirebaseFirestore.instance.collection(
        'users');
    userCollection.doc(user.uid).set({
      'name': 'test',
    });

    setState(() {
      // set the progress indicator to true so it would not be visible
      showProgress = false;
    });


    print("end validator: " + _validator.toString());
    print(_error);

    setState(() => _pressed = false); //re-enable button press

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) {
              return home();
            }));


    }}}),
                                                ),
                                              ]))),
                                  Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    height: 40,
                                    child: Text(_error,
                                      style: TextStyle(color: Colors.orange, fontSize: 18.0),
                                    ),),
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
                                                      }));                    },
                                          ))),]),
                          )]),),
                )



            )
      );

  }
}

