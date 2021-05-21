import 'package:chat_app/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{


  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.collection("users").
    where("name",isEqualTo: username).get();
  }

  getUserByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("users").
    where("email",isEqualTo: email).get();
  }

uploadUserInfo(userMap){
  FirebaseFirestore.instance.collection("users")
      .add(userMap);
}

  createChatRoom(String chatroomID,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomID).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }


  addConversationMessages(chatroomID,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomID)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(chatroomID) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomID)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
        
  }



  getChatRooms(String username)async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: username)
        .snapshots();
  }






}