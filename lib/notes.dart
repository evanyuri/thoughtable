import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


User userinfoz = FirebaseAuth.instance.currentUser;

class notes extends StatefulWidget {
  const notes({Key key}) : super(key: key);

  @override
  _notesState createState() => _notesState();
}

class _notesState extends State<notes> {
  @override
  Widget build(BuildContext context) {
    print(userinfoz.uid);
    return

      Scaffold(
          body:
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(userinfoz.uid)
                  .collection("thoughts")
                  .orderBy('time', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                if(snapshot.hasData) {
                  return

                    Container(
                      padding: EdgeInsets.only(bottom: 80),
                      child: ListView.builder(
                          reverse: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index){

                            List feelings = snapshot.data.docs[index]["feelings"];


                            return MessageTile(
                              feelings: feelings,
                              timestamp: snapshot.data.docs[index]["time"],
                              note: snapshot.data.docs[index]["note"],
                            );
                          })

                  );
                }
                return const Center(child: CircularProgressIndicator());

              }));
  }
}


class MessageTile extends StatelessWidget {
  final List feelings;
  final int timestamp;
  final String note;

  MessageTile({this.feelings, this.timestamp, this.note});


  @override
  Widget build(BuildContext context) {
    feelings.sort();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('MM/dd hh:mm').format(date);

      String formattedString = feelings.toString()
          .replaceAll(",", " ") //remove the commas
          .replaceAll("[", "") //remove the right bracket
          .replaceAll("]", "") //remove the left bracket
          .trim();


    return
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        SizedBox(
        height: 5,
      ),
      Container(
          width: 300,
          decoration: BoxDecoration(
              color:Colors.deepPurple[600],
              borderRadius: BorderRadius.all(Radius.circular(30))),
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                formattedString != "" ? Text(formattedString,
                    style: TextStyle(fontWeight: FontWeight.bold)) : Container(),
                SizedBox(
                  height:5
                ),
                note != null ? Text(note != null ? note : '') : Container(),
                Text(formattedDate,
                  style: TextStyle(
                    color: Colors.deepOrange,
                  ),)
              ])
      )]);
  }
}
