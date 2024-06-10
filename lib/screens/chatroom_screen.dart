import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fullstack/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;
  ChatRoomScreen(
      {super.key, required this.chatroomName, required this.chatroomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();
  Future<void> sendMessage() async {
    //send message to chatroom
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp(),
    };
    messageText.clear();

    try {
      await db.collection("messages").add(messageToSend);
    } catch (e) {
      print(e);
    }
  }

  Widget singleChatItem(
      {required String senderName,
      required String text,
      required String senderId}) {
    return Column(
      crossAxisAlignment:
          senderId == Provider.of<UserProvider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Text(
            senderName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            decoration: BoxDecoration(
              color: senderId ==
                      Provider.of<UserProvider>(context, listen: false).userId
                  ? Colors.grey[300]
                  : Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: TextStyle(
                    color: senderId ==
                            Provider.of<UserProvider>(context, listen: false)
                                .userId
                        ? Colors.black
                        : Colors.white),
              ),
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: db
                    .collection("messages")
                    .where("chatroom_id", isEqualTo: widget.chatroomId)
                    // .limit(5)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  var allMessages = snapshot.data?.docs ?? [];
                  if (allMessages.length < 1) {
                    return Center(
                      child: Text("No messages Here"),
                    );
                  }
                  return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: singleChatItem(
                                senderName: allMessages[index]["sender_name"],
                                text: allMessages[index]["text"],
                                senderId: allMessages[index]["sender_id"]));
                      });
                }),
          ),
          Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageText,
                      decoration: InputDecoration(
                          hintText: "Write a message here....",
                          border: InputBorder.none),
                    )),
                    InkWell(onTap: sendMessage, child: Icon(Icons.send))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
