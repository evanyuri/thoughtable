import 'package:flutter/material.dart';
import 'dart:math' as math;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}
String _value = '';
List<String> selectedChoices = [];

var tags = [
  'happy \u{1F600}',
  "laughy \u{1F602}",
  "embarrassed \u{1F633}",
  "blessed \u{1F607}",
  "\u{1F609}",
  "pleasant \u{1F60A}",
  "relaxed \u{1F60C}",
  "jealous \u{1F60F}",
  "frustrated \u{1F611}",
  "upset \u{1F615}",
  "confident \u{1F60E}",
  "depressed \u{1F61E}",
  "romantic \u{1F618}",
  "angry \u{1F621}",
  "alone \u{1F622}",
  "shocked \u{1F627}",
  "tired \u{1F634}",
  "scared \u{1F630}",
  "brokenhearted \u{1F494}",
  "silly \u{1F92A}",
  "inlove \u{1F61D}",
  "unheard \u{1F636}",
  "annoyed \u{1F644}",
  "lusting \u{1F924}",
  "fake \u{1F925}",
  "enlightened \u{1F92F}",
  "suspicious \u{1F9D0}",
  "sad \u{1F622}",
  "confused \u{1F635}",
  "anxious \u{1F62C}",
];

var selected_tags = ["love", "me", "summer"];
class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: Center(
        child: ListView(
          children:[
            Container(height:100),
            Wrap(
              alignment: WrapAlignment.center,
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children:<Widget>[
                  ...generate_tags()
              ]
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 30),
              width: 60,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {print('pressed');},
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

  generate_tags() {
    return tags.map((tag) => get_chip(tag)).toList();
  }

  get_chip(index) {
    return
        ChoiceChip(
          label:Text("$index"),
          backgroundColor: Colors.grey[200],
          selectedColor: Colors.purple[200],
          selected: selectedChoices.contains(index),
          onSelected: (selected) {
          setState(() {
            selectedChoices.contains(index)
                ? selectedChoices.remove(index)
                : selectedChoices.add(index);    });
          print(selectedChoices.toString());
          }
    );
  }
}



