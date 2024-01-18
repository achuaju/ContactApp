import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/_login.dart';
import 'package:contact_app/contact_details_view_screen.dart';
import 'package:contact_app/Adding_detilas.dart';

class PROJECT extends StatefulWidget {
  @override
  State<PROJECT> createState() => _PROJECTState();
}

class _PROJECTState extends State<PROJECT> {
  CollectionReference fire = FirebaseFirestore.instance.collection('userdetails');

  var anamecnt = TextEditingController();
  var banamecnt = TextEditingController();
  var cnamecnt = TextEditingController();
  var dnamecnt = TextEditingController();
  var enamecnt = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize your controllers here
    anamecnt = TextEditingController();
    banamecnt = TextEditingController();
    cnamecnt = TextEditingController();
    dnamecnt = TextEditingController();
    enamecnt = TextEditingController();
  }

  void add() async {
    try {
      await fire.add({
        "name": anamecnt.text,
        "mobilenumber": banamecnt.text,
        "password": dnamecnt.text,
        "email": cnamecnt.text,
      }).then((value) {
        print("Data added");

        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Data added successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> authenticate() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: cnamecnt.text,
        password: dnamecnt.text,
      );
      // User registered successfully
      print('User registered: ${userCredential.user!.uid}');
      // You can add additional logic here, such as navigating to a new screen.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
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
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  const Text("         Hello!\nWelcome back"),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {},
                        controller: anamecnt,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "Name",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {},
                        controller: dnamecnt,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        controller: banamecnt,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "Mobile Number",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: cnamecnt,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Check if all text fields are filled
                          if (anamecnt.text.isNotEmpty &&
                              dnamecnt.text.isNotEmpty &&
                              banamecnt.text.isNotEmpty &&
                              cnamecnt.text.isNotEmpty) {
                            // Add data and authenticate
                            add();
                            authenticate();

                            // Navigate to CarListScreen and replace the current page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => StudentDetailsPage(),
                              ),
                            );
                          } else {
                            // Show an error message if any text field is empty
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please fill in all details.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text("Sign in "
                        ),

                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => PROJEC(),
                            ),
                          );
                        },
                        child: Text(" Already have an account? Sign in"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
