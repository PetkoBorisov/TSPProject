
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();




  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {

          searchSnapshot = val;
          print(FirebaseAuth.instance.currentUser);
      });
    });
  }

  createChatRoomAndStartConversation({String userName}){

    print(Constants.myName);
    if(userName != Constants.myName)
      {

        String chatRoomID = getChatRoomID(userName,Constants.myName);
        List<String> users = [userName,Constants.myName];
        Map<String,dynamic> chatRoomMap = {
          "chatRoomID" : chatRoomID,
          "users" : users,
        };
        databaseMethods.createChatRoom(chatRoomID,chatRoomMap);
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ConversationScreen(chatRoomID)));

      }
    else{
      print("You cannot send message to yourself");
    }
  }








  Widget SearchTile({String userName,
    String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: mediumTextStyle(),),
              Text(userEmail,style: mediumTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){

                createChatRoomAndStartConversation(userName: userName);


            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(13)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: Text("Message",style: mediumTextStyle(),)
            ),
          )
        ],
      ),
    );
  }

  getChatRoomID(String a,String b)
  {

    if(a.compareTo(b) == 1){
      return"$b\_$a";
    }else{
      return "$a\_$b";
    }
  }




  Widget searchList() {

    return searchSnapshot == null ? Container():ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if(searchSnapshot.docs[0].get("name") == "")
          {
            return Container();
          }
          else{
            return SearchTile(
              userName: searchSnapshot.docs[index].get("name"),
              userEmail: searchSnapshot.docs[index].get("email"),
            );
          }


        });

  }



  @override
  void initState() {
    initiateSearch();
    super.initState();
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBarMain(context),
        body: Container(

          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Search Username...",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/search_white.png")),
                    ),

                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ),
      );
    }





  }








