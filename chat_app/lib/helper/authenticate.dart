

import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/cupertino.dart';

class Autheticate extends StatefulWidget {
  @override
  _AutheticateState createState() => _AutheticateState();
}

class _AutheticateState extends State<Autheticate> {




  bool showSignedIn = true;

  void toggleView(){
    setState(() {
      showSignedIn = !showSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignedIn){
      return SignIn(toggleView);
    }else{
      return SignUp(toggleView);
    }
  }
}
