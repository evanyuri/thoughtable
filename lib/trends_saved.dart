import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


User userinfoz = FirebaseAuth.instance.currentUser;

class trends extends StatefulWidget {
  const trends({Key key}) : super(key: key);

  @override
  _trendsState createState() => _trendsState();
}

class _trendsState extends State<trends> {
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
    return Container(
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

  MessageTile({this.feelings, this.timestamp});


  @override
  Widget build(BuildContext context) {
    feelings.sort();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('MM/dd hh:mm').format(date); // Apr 8, 2020

    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for ( var i in feelings )
            Tooltip(
              message: i.toString(),
              child: Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                  color:Colorizer(i),
                  borderRadius: columnRadius(i, feelings)),
                  alignment: Alignment.center,
                padding: EdgeInsets.only(
                        top: 3,
                        bottom: 3,
                        left: 3,
                        right: 3),
                  // child: Text(i.toString(),
                  //   overflow: TextOverflow.fade,
                  //   maxLines: 1,
                  //   softWrap: false,
                  // )
              ),
            )
        ],
      );
  }
}


Colorizer(feeling) {
  if (feeling == 'happy') { var color = Colors.blue; return color;}
  if (feeling == 'surprised') {var color = Colors.purple;return color;}
  if (feeling == 'sad') {var color = Colors.red; return color;}
  if (feeling == 'disgusted') {var color = Colors.orange;return color;}
  if (feeling == 'angry') {var color = Colors.yellow;return color;}
  if (feeling == 'fearful') {var color = Colors.green;return color;}
  if (feeling == 'bad') {var color = Colors.pinkAccent;return color;}


  else {
    var color = Colors.grey;
    return color;}

}

columnRadius(i, feeling) {
  print(feeling.length);


  if (feeling.length == 1) {
    var radius = BorderRadius.all(Radius.circular(10));
    return radius;
  }
  if (i == feeling.last) {
    var radius = BorderRadius.only(
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10),);
    return radius;
  }
  if (i == feeling.first) {
    var radius = BorderRadius.only(
      bottomLeft: Radius.circular(10),
      topLeft: Radius.circular(10),);
    return radius;
  }
  else {
    var radius = BorderRadius.all(Radius.circular(0));
    return radius;
  }
}
