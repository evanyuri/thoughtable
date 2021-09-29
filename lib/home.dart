import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thoughtable/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thoughtable/notes.dart';
import 'package:thoughtable/trends.dart';
import 'package:flutter/services.dart';




final FirebaseAuth _auth = FirebaseAuth.instance;
User userinfoz = FirebaseAuth.instance.currentUser;

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}
String _value = '';
List<String> selectedChoices = [];
int _selectedIndex;
String _note = "";
var _controller = TextEditingController();


class chipContent
{
  String label;
  String value;
  Color selectedColor;
  Color backgroundColor;
  chipContent(this.label, this.value, this.selectedColor, this.backgroundColor);
}

List<chipContent> _chipsList = [
  chipContent('happy \u{1F600}', 'happy', Colors.purple, Colors.black),
  chipContent("sad \u{1F60F}", 'sad', Colors.purple, Colors.black),
  chipContent("angry \u{1F611}", 'angry', Colors.purple, Colors.black),
  chipContent("disgusted \u{1F615}", 'disgusted', Colors.purple, Colors.black),
  chipContent("surprised \u{1F627}", 'surprised', Colors.purple, Colors.black),
  chipContent("fearful \u{1F630}", 'fearful', Colors.purple, Colors.black),
  chipContent("bad \u{1F622}", 'bad', Colors.purple, Colors.black),

];


class _homeState extends State<home> {


  @override
  Widget build(BuildContext context) {
    print({'user ID:', userinfoz.uid});
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(userinfoz.uid).get(),
        builder: (context, userSnap) {
          if (!userSnap.hasData)
            return Center(child: CircularProgressIndicator());
          if (userSnap == null) return CircularProgressIndicator();
          else
        return Scaffold(
          backgroundColor: Colors.deepPurple,
            appBar: new AppBar(
            backgroundColor: Colors.transparent,
                elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.logout) ,
              onPressed:() async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        }));
              }
              ,
            ),
             actions: <Widget>[
              IconButton(
                icon: Icon(Icons.auto_graph) ,
                onPressed:() async {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) {
                            return trends();
                          }));},),
               IconButton(
                 icon: Icon(Icons.note) ,
                 onPressed:() async {
                   Navigator.push(context,
                       MaterialPageRoute(
                           builder: (context) {
                             return notes();
                           }));},),
             ]
            ),

          body: Center(
            child: ListView(
              children:[
                Container(height:50),
                Wrap(
                  alignment: WrapAlignment.center,
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children:techChips()

                  //   <Widget>[
                  //     ...generate_tags()
                  // ]
                ),
                 Container(
                   padding: EdgeInsets.only(right:20, left:20),
                   child: Expanded(
                     child: TextFormField(
                       controller: _controller,
                       style: TextStyle(color: Colors.white),
                       inputFormatters: [
                         LengthLimitingTextInputFormatter(2000),
                       ],
                       initialValue: userSnap.data.data()['bio'],
                       onChanged: (note) =>
                           setState(() => _note = note),
                       maxLines: null,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.all(
                             const Radius.circular(12.0),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                  width: 60,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () async {
                          print('pressed');
                          print(selectedChoices);

                          if (selectedChoices.length > 0 || _note != "") {

                            _controller.clear();
                            FirebaseFirestore.instance.collection("users").doc(
                                userinfoz.uid).collection("thoughts").add(
                                {
                                  'note': _note,
                                  'feelings': selectedChoices,
                                  'time': DateTime
                                      .now()
                                      .millisecondsSinceEpoch});
                            setState(() {
                              selectedChoices = [];
                              _note = null;
                            });
                          } else {
                            print('forms incomplete');
                          }},
                        child: Icon(Icons.check),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                )
                            )
                        )
                    ),
                  ),
                )
              ]
            )
          ),
        );
      }
    );
  }

  List<Widget> techChips () {
    List<Widget> chips = [];
    for (int i=0; i< _chipsList.length; i++) {
      Widget item = Padding(
          padding: const EdgeInsets.only(left:0, right: 0),
      child: ChoiceChip(
          label: Text(_chipsList[i].label),
          labelStyle: TextStyle(color: Colors.white),
          backgroundColor: _chipsList[i].backgroundColor,
          selectedColor: _chipsList[i].selectedColor,
          selected: selectedChoices.contains(_chipsList[i].value),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(_chipsList[i].value)
                  ? selectedChoices.remove(_chipsList[i].value)
                  : selectedChoices.add(_chipsList[i].value);
                    }
                  );
            print(selectedChoices.toString());
          })
      );

      chips.add(item);
    }
    return chips;
  }


}



