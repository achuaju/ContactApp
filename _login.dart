import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'contact_details_view_screen.dart';
import '_sign_page_in.dart';

class PROJEC extends StatefulWidget {
  @override
  State<PROJEC> createState() => _PROJECState();
}

class _PROJECState extends State<PROJEC> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Viewpage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect password'),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Viewpage()),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  // Image at the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "https://media.istockphoto.com/id/1178515839/photo/social-connection-backgrounds.jpg?s=2048x2048&w=is&k=20&c=NOqCw-Q1C63y2vcCRvkqJGCzUurl4GxbWd-Tu8rnN7U=",  // Replace with the actual image URL
                            width: 350,
                            height: 300,

                          ),
                          SizedBox(width: 8),

                        ],
                      ),


                    ],
                  ),

                  SizedBox(
                    height: 50,

                    child: Row(
                      children: [
                        Text("Sign in ",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.blue,
                        fontSize: 20),),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("welcome back ! please enter your credentials to login",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  // Email TextField
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {},
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade400)),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Email",
                        ),
                      ),
                    ),
                  ),
                  // Password TextField
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {},
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey)),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Password",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Login Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 260,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        child: Text("Sign In"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          primary: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  // Google Sign-In Button with Image
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          primary: Colors.white,
                        ),
                        child: Image.asset(
                          "assets/download.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  // Don't have an account TextButton
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PROJECT()),
                      );
                    },
                    child: Text("Don't have an account"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


