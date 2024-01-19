import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/getMemberDetails.dart';

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
                                // Handle the tap event, for example, navigate to committee details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommitteeDetailsPage(
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

class CommitteeDetailsPage extends StatelessWidget {
  final String committeeId;

  CommitteeDetailsPage({required this.committeeId});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for committee details, similar to the CommitteePage
    // You can use another FutureBuilder to fetch and display details based on committeeId
    return Scaffold(
      appBar: AppBar(
        title: Text('Committee Details'),
      ),
      body: Center(
        child: FutureBuilder(
          // Fetch committee details based on committeeId
          future: getCommitteeDetails(committeeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              // Implement UI to display committee details
              // Example: Text(snapshot.data['committeeName'])
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getCommitteeDetails(String committeeId) async {
    // Implement the logic to fetch committee details based on committeeId
    // For example, use Firestore to get document data
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Committees')
        .doc(committeeId)
        .get();

    return document.data() as Map<String, dynamic>;
  }
}
