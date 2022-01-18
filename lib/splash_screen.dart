import 'dart:async';
import 'package:Allergy_Crosser/main_screen.dart';
import 'package:Allergy_Crosser/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation<double> controller1;
  final _auth = FirebaseAuth.instance;
  bool userFound = false;
  Animation? animation;
  double? value = 0.0;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    controller!.forward();
    controller!.addListener(() {
      setState(() {
        value = controller!.value;
      });
    });
    Future.delayed(const Duration(milliseconds: 5000), () async {

      if (_auth.currentUser != null) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("users").get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          if ((querySnapshot.docs[i].data() as dynamic)['Email'] ==
              _auth.currentUser!.email) {
            setState(() {
              userFound = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreenMyAllergies(
                      name: (querySnapshot.docs[i].data()
                          as dynamic)['First Name'])),
            );
          }
        }
      }

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StartScreen()),
            (route) => false);

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Opacity(
                      opacity: value!.toDouble(),
                      child: Image(
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
