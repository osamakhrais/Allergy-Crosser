import 'package:Allergy_Crosser/login_screen.dart';
import 'package:Allergy_Crosser/signup_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenHeight * 1,
        height: screenHeight * 1,
        color: Color(0XFF3a67d7),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.12,
            ),
            Text(
              'Welcome to Allergy Crosser',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90.0),
              child: Text(
                'Start your journey buying with now fear',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 220,
              height: 220,
              child: Image(
                width: 200,
                height: 200,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(
                          50.0) //                 <--- border radius here
                      ),
                ),
                width: screenWidth * 0.8,
                height: 45,
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0XFF3a67d7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
