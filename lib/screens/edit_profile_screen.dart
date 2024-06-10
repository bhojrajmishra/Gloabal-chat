import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fullstack/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userData = {};

  //initialize database

  var db = FirebaseFirestore.instance;

  TextEditingController nameText = TextEditingController();

  var editProfileForm = GlobalKey<FormState>();

  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text, //update name
    };
    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);

    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          InkWell(
            onTap: () {
              if (editProfileForm.currentState!.validate()) {
                //update user profile
                updateData();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileForm,
            child: Column(children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name Cannot be Empty";
                  }
                },
                controller: nameText,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: userProvider.userName,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
