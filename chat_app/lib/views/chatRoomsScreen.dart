


import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/Profile.dart';

class ChatRoom extends StatefulWidget {


  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context,snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return ChatRoomsTile(snapshot.data.docs[index].get("chatRoomID")
                .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index].get("chatRoomID"));
              }):Center(child: CircularProgressIndicator());
        });
  }



  getUserInfo()async
  {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName)
        .then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {
    });
  }


  void _onItemTapped() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/SocialForestLogoNew2.png",height: 25,),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> Autheticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      backgroundColor: Colors.white10,

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add_comment_rounded),
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(
      //         builder: (context) => SearchScreen()
      //     ));
      //   },
      // ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.add_comment_rounded),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SearchScreen()
                  ));
                },
            ),
            FloatingActionButton(
              child: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProfileApp()
                ));
              },
            ),
          ],
        ),
      ),



      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_rounded),
      //       label: 'Home',
      //       backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_a_photo_rounded),
      //       label: 'Photo',
      //
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_rounded),
      //       label: 'Profile',
      //
      //
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //
      //     ),
      //   ],
      //
      // ),
    );
  }
}


class ChatRoomsTile extends StatelessWidget {
  final String chatRoomID;
  final String userName;
  ChatRoomsTile(this.userName,this.chatRoomID);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ConversationScreen(chatRoomID)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blue,
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName,style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
