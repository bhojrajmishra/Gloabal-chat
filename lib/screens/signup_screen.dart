import 'package:flutter/material.dart';
import 'package:fullstack/controllers/signup_controller.dart';
import 'package:fullstack/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var userForm = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginScreen();
            })); // Navigate back to previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: userForm,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/logo.png")),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is Required";
                          }
                        },
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      SizedBox(height: 23),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "password is Required";
                          }
                        },
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(labelText: "password"),
                      ),
                      SizedBox(height: 23),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is Required";
                          }
                        },
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      SizedBox(height: 23),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: country,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Country is Required";
                          }
                        },
                        decoration: InputDecoration(labelText: "Country"),
                      ),
                      SizedBox(height: 23),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0, 50),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.deepPurpleAccent),
                              onPressed: () async {
                                if (userForm.currentState!.validate()) {
                                  isLoading = true;
                                  setState(() {});
                                  await SignUpController.createAccount(
                                      context: context,
                                      email: email.text,
                                      password: password.text,
                                      name: name.text,
                                      country: country.text);
                                  //save to firebase
                                }
                                isLoading = false;
                              },
                              child: isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text("Create account"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
