import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/getMemberDetails.dart';

class FacilitiesPage extends StatefulWidget {
  @override
  _FacilitiesPageState createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  List<String> docIDs = [];

  Future<void> getDocId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Facilities').get();

    docIDs = snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facilities'),
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
                                // Handle the tap event, for example, navigate to facility details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FacilityDetailsPage(
                                      facilityId: docIDs[index],
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

class FacilityDetailsPage extends StatelessWidget {
  final String facilityId;

  FacilityDetailsPage({required this.facilityId});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for facility details, similar to the FacilitiesPage
    // You can use another FutureBuilder to fetch and display details based on facilityId
    return Scaffold(
      appBar: AppBar(
        title: Text('Facility Details'),
      ),
      body: Center(
        child: FutureBuilder(
          // Fetch facility details based on facilityId
          future: getFacilityDetails(facilityId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              // Implement UI to display facility details
              // Example: Text(snapshot.data['facilityName'])
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getFacilityDetails(String facilityId) async {
    // Implement the logic to fetch facility details based on facilityId
    // For example, use Firestore to get document data
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Facilities')
        .doc(facilityId)
        .get();

    return document.data() as Map<String, dynamic>;
  }
}
