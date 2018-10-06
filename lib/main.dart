import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: _handleCurrentScreen()
    );
  }

  Widget _handleCurrentScreen () {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.only(left: 30.0),
                    child: Text('Loading...')
                  )
                ],
              ),
            )
          );
        } else {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Firebase Dev Day'),
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ClipOval(
                      child: Image.network(
                        snapshot.data.photoUrl,
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  MaterialButton(
                    child: Text('Logout'),
                    onPressed: () {
                      _auth.signOut();
                    }
                  )
                ],
              ),
              body: HomePage(user: snapshot.data)
            );
          } else {
            return Scaffold(
              body: LoginPage()
            );
          }
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: MaterialButton(
          child: Container(
            width: 160.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/google.png', width: 25.0),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text('Login With Google')
                ),
              ],
            ),
          ),
          onPressed: () {
            _handleSignIn();
          },
          color: Colors.white,
        ),
      )
    );
  }
}