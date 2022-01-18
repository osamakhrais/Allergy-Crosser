import 'package:Allergy_Crosser/login_screen.dart';
import 'package:Allergy_Crosser/new_email.dart';
import 'package:Allergy_Crosser/new_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  final String nameofusermatching;
  const ForgetPassword({Key? key, required this.nameofusermatching})
      : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late String _email = '';
  bool userFound = false;
  String nameofuser = '';

  Future<void> nameFinding() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if ((querySnapshot.docs[i].data() as dynamic)['First Name'] ==
          widget.nameofusermatching) {
        if ((querySnapshot.docs[i].data() as dynamic)['Allergies'] != null) {
          setState(() {
            _email = (querySnapshot.docs[i].data() as dynamic)['User Name'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    nameFinding();
    super.initState();
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
                      'Profile',
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
                      'Change Your Email And Password',
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
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
                              _email) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailChange(
                                  namecalled: (querySnapshot.docs[i].data()
                                      as dynamic)['First Name'],
                                  emailcalled: (querySnapshot.docs[i].data()
                                      as dynamic)['Email'],
                                ),
                              ),
                            );
                          }
                        }
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
                            'Change Email',
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
                      height: 50,
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
                              _email) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPasswordScreen(
                                  namecalled: (querySnapshot.docs[i].data()
                                      as dynamic)['First Name'],
                                  passcalled: (querySnapshot.docs[i].data()
                                      as dynamic)['Password'],
                                ),
                              ),
                            );
                          }
                        }
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
                            'Change Password',
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
                      height: 50,
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
                              _email) {
                            userFound = true;
                            nameofuser = (querySnapshot.docs[i].data()
                                as dynamic)['First Name'];
                          }
                        }
                        if (userFound) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(nameofuser)
                              .delete()
                              .then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User Not Found'),
                            ),
                          );
                        }
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
                            'Delete Account',
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
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
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
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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
