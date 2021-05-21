



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/logo.png"
    ,height: 60, width: 200),

  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.white54
      ),
      focusedBorder:UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),

      ),
      enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );

}

TextStyle simpleTextStyle()
{
  return TextStyle(
    color:Colors.white,
        fontSize: 16
  );
}

TextStyle mediumTextStyle()
{
  return TextStyle(
      color:Colors.white,
      fontSize: 17
  );
}


