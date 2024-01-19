import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommitteePage extends StatefulWidget {
  @override
  _CommitteePageState createState() => _CommitteePageState();
}

class _CommitteePageState extends State<CommitteePage> {
  List<String> docIDs = [];

  Future<void> getDocId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Committees').get();

    docIDs = snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Committees'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                docIDs[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                // Handle the tap event
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MembersPage(
                                      committeeId: docIDs[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MembersPage extends StatelessWidget {
  final String committeeId;

  MembersPage({required this.committeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$committeeId'),
      ),
      body: Center(
        child: FutureBuilder(
          future: getMembers(committeeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Member> members = snapshot.data as List<Member>;
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  Member member = members[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 1), // Set the desired background color
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Add a subtle shadow
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
                      child: ListTile(
                      
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(member.photoUrl),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  member.designation,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Contact Number: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launch('tel:${member.phoneNumber}');
                                      },
                                      child: Text(
                                        member.phoneNumber,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Member>> getMembers(String committeeId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Committees')
      .doc(committeeId)
      .collection('Members')
      .orderBy('position')
      .get();

  List<Member> members = snapshot.docs
      .map((doc) => Member.fromMap(doc.data() as Map<String, dynamic>))
      .toList();

  return members;
}
}

class Member {
  final String name;
  final String designation;
  final String phoneNumber;
  final String photoUrl;

  Member({
    required this.name,
    required this.designation,
    required this.phoneNumber,
    required this.photoUrl,
  });

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'] ?? '',
      designation: map['designation'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}
