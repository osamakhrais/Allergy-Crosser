import 'package:Allergy_Crosser/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final auth = FirebaseAuth.instance;
  List getUserType = [];
  bool obscureselect = true;
  String _email = '';
  String _password = '';
  String confirmpassword = '';
  String _firstname = '';
  String _lastname = '';
  String _username = '';
  final firestoreInstance = FirebaseFirestore.instance;

  bool isPasswordCompliant(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r"[a-z]"))) return false;
    if (!password.contains(RegExp(r"[A-Z]"))) return false;
    if (!password.contains(RegExp(r"[0-9]"))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
              height: screenHeight * 0.80,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      'Create Account',
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
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _firstname = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _lastname = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'User Name',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _username = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: null,
                      obscureText: obscureselect,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Enter Password',
                        errorText: isPasswordCompliant(_password)
                            ? null
                            : 'Atleast one uppercase, one number and one special character',
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
                          _password = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: obscureselect,
                      controller: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0XFF3a67d7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Confirm Password',
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
                          confirmpassword = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          UserCredential userEnter =
                              await auth.createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          if (userEnter != (null)) {
                            firestoreInstance
                                .collection("users")
                                .doc(_firstname)
                                .set({
                              'First Name': _firstname,
                              'Last Name': _lastname,
                              'User Name': _username,
                              'Email': _email,
                              'Password': _password,
                              'Allergies': getUserType,
                            }).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$e'),
                            ),
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
                            'Sign Up',
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
                      children: [
                        Text(
                          "Already have an account?",
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
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
