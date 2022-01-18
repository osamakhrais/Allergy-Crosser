import 'package:Allergy_Crosser/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewPasswordScreen extends StatefulWidget {
  String namecalled;
  String passcalled;
  NewPasswordScreen(
      {Key? key, required this.namecalled, required this.passcalled})
      : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool obscureselect = true;
  String previouspassword = '';

  late String _password;
  String previousemail = '';

  bool passwordmatched(String datasent) {
    if (datasent == widget.passcalled) {
      return true;
    } else {
      return false;
    }
  }

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
                height: screenHeight * 0.2,
                width: screenWidth * 1,
                color: Color(0xffedf1fa),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Create New Password to continue Login',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    )
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                          labelText: 'Previous Password',
                          errorText: passwordmatched(previouspassword)
                              ? null
                              : 'Password does not match',
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
                            previouspassword = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                            _password = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.namecalled)
                              .update({
                            'Password': _password,
                          }).then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0XFF3a67d7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: screenWidth * 0.9,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Update',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
