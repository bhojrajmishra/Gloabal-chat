import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullstack/providers/user_provider.dart';
import 'package:fullstack/screens/chatroom_screen.dart';
import 'package:fullstack/screens/profile_screen.dart';
import 'package:fullstack/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatroomsIds = [];
  void getChatRooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatRoomData in dataSnapshot.docs) {
        chatroomsList.add(singleChatRoomData.data());
        chatroomsIds.add(singleChatRoomData.id.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        key: ScaffoldKey,
        appBar: AppBar(
            title: const Text("Global Chat"),
            leading: InkWell(
              onTap: () => ScaffoldKey.currentState!.openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  child: Text(userProvider.userName[0]),
                ),
              ),
            )),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }));
                  },
                  leading: CircleAvatar(
                    child: Text(userProvider.userName[0]),
                  ),
                  title: Text(
                    userProvider.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userProvider.userEmail),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }));
                  },
                  leading: Icon(Icons.people),
                  title: Text("Profile"),
                ),
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SplashScreen();
                      }),
                      (route) {
                        return false;
                      },
                    );
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                )
              ],
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: chatroomsList.length,
            itemBuilder: (BuildContext context, int index) {
              String chatroomName = chatroomsList[index]["chatroom_name"] ?? "";
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChatRoomScreen(
                        chatroomName: chatroomName,
                        chatroomId: chatroomsIds[index],
                      );
                    }),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey[900],
                  child: Text(
                    chatroomName[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chatroomName),
                subtitle: Text(chatroomsList[index]["desc"] ?? ""),
              );
            }));
  }
}
