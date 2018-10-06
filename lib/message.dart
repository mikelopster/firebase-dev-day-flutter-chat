import 'package:flutter/material.dart';

class Message extends StatelessWidget {

  final String name;
  final String text;
  final String photoUrl;

  Message({ this.name, this.photoUrl, this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Image.network(
                photoUrl,
                height: 50.0
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text)
              )
            ],
          )
        ]
      ),
    );
  }
}


