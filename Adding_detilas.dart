import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'contact_details_view_screen.dart';

class StudentDetailsPage extends StatefulWidget {
  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    try {
      // Check for valid data
      if (_nameController.text.isEmpty ||
          _ageController.text.isEmpty ||
          _dobController.text.isEmpty ||
          _mobileController.text.isEmpty) {
        print('Please fill in all details');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      final studentData = {
        'name': _nameController.text,
        'age': _ageController.text,
        'dob': _dobController.text,
        'mobile': _mobileController.text,
      };

      final docRef = await FirebaseFirestore.instance
          .collection('student_images')
          .add(studentData);

      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('student_images')
            .child(docRef.id + '.png');

        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();
        await docRef.update({'imageUrl': imageUrl});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student details saved successfully!'),
        ),
      );

      // Navigate to another page conditionally
      // For example, let's navigate to a hypothetical SuccessPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Viewpage(),
        ),
      );
    } catch (e) {
      print('Firebase Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Student Details Entry'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'created date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              SizedBox(height: 10),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 2),
                        Text('Image from Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 3),
                        Text('Camera'),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
                child: Row(
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 5),
                    Text('Save'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              _image != null
                  ? Image.file(
                _image!,
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              )
                  : Container(),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

