import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

final Firestore db = Firestore.instance;

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = new TextEditingController();
  List<Message> _messages = <Message>[];

  void _handleSubmit(String text) {
    _textController.clear();
    db.runTransaction((transaction) async {
      final DocumentSnapshot ds = await transaction.get(db.collection('chats').document());
      Map<String, dynamic> newMessage = new Map<String, dynamic>();
      newMessage['name'] = widget.user.displayName;
      newMessage['photoUrl'] = widget.user.photoUrl;
      newMessage['text'] = text;
      newMessage['createdDate'] = DateTime.now();

      await transaction.set(ds.reference, newMessage);
    });
  }

  Widget _textComposerWidget() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: <Widget>[
          Flexible(
              child: TextField(
            decoration: InputDecoration.collapsed(hintText: 'Message...'),
            controller: _textController,
            onSubmitted: _handleSubmit,
          )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _handleSubmit(_textController.text);
                  }))
        ]));
  }

  @override
  void initState() {
    super.initState();

    Stream<QuerySnapshot> snapshots = db.collection('chats').orderBy('createdDate', descending: true).snapshots();
    snapshots.listen((data) {
      List<Message> _loadMessages = data.documents
                                      .map((doc) => Message(
                                        name: doc.data['name'],
                                        photoUrl: doc.data['photoUrl'],
                                        text: doc.data['text']
                                      )).toList();
      setState(() {
        _messages = _loadMessages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        ),
      ),
      Divider(height: 1.0),
      _textComposerWidget()
    ]));
  }
}
