import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Adding_detilas.dart';

class Viewpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lead List'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu)),

          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => StudentDetailsPage(),
                ),
              );
              // Add your settings function here
              print('Settings button pressed');
            },
          ),
        ],
      ),
      body: StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final CollectionReference studentsCollection =
  FirebaseFirestore.instance.collection('student_images');
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 50,
            width: 350,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: studentsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No students available.'));
              }

              // Filter students based on name and age
              var filteredStudents = snapshot.data!.docs.where((studentDoc) {
                var studentData = studentDoc.data() as Map<String, dynamic>;

                // Perform filtering based on name
                var nameFilter =
                studentData['name'].toString().toLowerCase().contains(searchController.text.toLowerCase());

                // Perform filtering based on age
                var ageFilter =
                studentData['age'].toString().toLowerCase().contains(searchController.text.toLowerCase());

                return nameFilter || ageFilter;
              }).toList();

              return ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  var studentData = filteredStudents[index].data() as Map<String, dynamic>;


                  return Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            studentData['imageUrl'] ?? ''),
                      ),
                      title: Text('Name: ${studentData['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${studentData['age']}'),
                          Text('Created: ${studentData['dob']}'),
                          Text('Mobile Number: ${studentData['mobile']}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => BookingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.teal),
                        child: Text('Contact',
                        selectionColor: Colors.white,),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Page'),
      ),
      body: Center(
        child: Text('Contact Page'),
      ),
    );
  }
}

