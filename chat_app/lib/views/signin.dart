




import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);




  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();




  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn(){


    if(formKey.currentState.validate()){
      databaseMethods.getUserByEmail(emailTextEditingController.text)
          .then((val){
        snapshotUserInfo = val;
        HelperFunctions.
        saveUserNameSharedPreference(snapshotUserInfo.docs[0].get("name"));
      });

      setState(() {
        isLoading = true;

        print(Constants.myName);

      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text
          , passwordTextEditingController.text).then((value){
            if(value!=null)
              {
                HelperFunctions.saveUserLoggedInSharedPreference(true);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=>ChatRoom()
                ));
              }
      });



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min  ,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val))
                          {
                            return"Please provide a valid email.";
                          }
                          else
                          {
                            return null;
                          }
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        validator: (val){
                          if(val.length<6)
                          {
                            return"Please enter a password 6+ characters.";
                          }
                          else
                          {
                            return null;
                          }
                        },
                        controller: passwordTextEditingController,
                        style:simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child:Text("Forgot Password?",style:simpleTextStyle(),),
                  ),
                ),
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007Ef4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child:Text("Sign in",style: mediumTextStyle(),),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:Text("Sign in with Google",style: TextStyle(
                      color:Colors.black87,
                      fontSize: 17
                  ),
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account?",style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register now", style: TextStyle(
                            color:Colors.white,
                            fontSize: 17,
                          decoration: TextDecoration.underline
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),

    );
  }
}
