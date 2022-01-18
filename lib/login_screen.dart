import 'package:Allergy_Crosser/main_screen.dart';
import 'package:Allergy_Crosser/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  bool obscureselect = true;
  bool loggedIn = false;
  String nameFouund = '';
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.22,
                width: screenWidth * 1,
                color: Color(0XFF3a67d7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.70,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      'Sign In Now',
                      style: TextStyle(
                        color: Color(0XFF3a67d7),
                        fontSize: 22.0,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0XFF3a67d7),
                        ),
                        labelText: 'User Name',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: null,
                      obscureText: obscureselect,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0XFF3a67d7),
                        ),
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureselect = !obscureselect;
                              });
                            },
                            child: Icon(Icons.remove_red_eye_outlined)),
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .get();
                        for (int i = 0; i < querySnapshot.docs.length; i++) {
                          if ((querySnapshot.docs[i].data()
                                      as dynamic)['User Name'] ==
                                  username &&
                              (querySnapshot.docs[i].data()
                                      as dynamic)['Password'] ==
                                  password) {
                            setState(() {
                              nameFouund = (querySnapshot.docs[i].data()
                                  as dynamic)['First Name'];
                              loggedIn = true;
                            });
                          }
                        }
                        if (loggedIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreenMyAllergies(
                                      name: nameFouund,
                                    )),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    "Create account or check password/user name"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFF3a67d7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: screenWidth * 0.9,
                        height: 50,
                        child: Center(
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up ',
                            style: TextStyle(
                                color: Color(0XFF3a67d7),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
