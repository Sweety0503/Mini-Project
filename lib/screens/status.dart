import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('STATUS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentStatusPage()),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text('Book Appointment Status'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServicesStatusPage()),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text('In-Home Services Status'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentStatusPage extends StatefulWidget {
  @override
  _AppointmentStatusPageState createState() => _AppointmentStatusPageState();
}

class _AppointmentStatusPageState extends State<AppointmentStatusPage> {
  CollectionReference _collection1 =
      FirebaseFirestore.instance.collection('combinedDetails');
  CollectionReference _collection2 =
      FirebaseFirestore.instance.collection('BookedAppointments');

  List<Map<String, dynamic>> fetchedData = [];

  Future<void> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot = await _collection1.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot document in documents) {
      String? fieldValue = document['Email'] as String?;

      if (fieldValue != null) {
        QuerySnapshot matchingSnapshot =
            await _collection2.where('Email', isEqualTo: fieldValue).get();
        List<QueryDocumentSnapshot> matchingDocuments = matchingSnapshot.docs;

        for (QueryDocumentSnapshot matchingDocument in matchingDocuments) {
          Map<String, dynamic> matchingData =
              matchingDocument.data() as Map<String, dynamic>;
          fetchedData.add(matchingData);
        }
      }
    }

    setState(() {}); // Update the UI after fetching the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchDataFromFirebase,
              child: Text('Check Status'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                // Wrap with SingleChildScrollView
                child: ListView.builder(
                  shrinkWrap: true, // Set shrinkWrap to true
                  itemCount: fetchedData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = fetchedData[index];
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Appointment Time:'),
                              Text(data['AppointmentTime']),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Doctor:'),
                              Text(data['Doctor Name']),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Google Pay Number:'),
                              Text(data['GPayLink'])
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesStatusPage extends StatefulWidget {
  @override
  _ServicesStatusPageState createState() => _ServicesStatusPageState();
}

class _ServicesStatusPageState extends State<ServicesStatusPage> {
  CollectionReference _collection1 =
      FirebaseFirestore.instance.collection('inhome');
  CollectionReference _collection2 =
      FirebaseFirestore.instance.collection('Appointments');

  List<Map<String, dynamic>> fetchedData = [];

  Future<void> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot = await _collection1.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot document in documents) {
      String? fieldValue = document['Email'] as String?;

      if (fieldValue != null) {
        QuerySnapshot matchingSnapshot =
            await _collection2.where('Email', isEqualTo: fieldValue).get();
        List<QueryDocumentSnapshot> matchingDocuments = matchingSnapshot.docs;

        for (QueryDocumentSnapshot matchingDocument in matchingDocuments) {
          Map<String, dynamic> matchingData =
              matchingDocument.data() as Map<String, dynamic>;
          fetchedData.add(matchingData);
        }
      }
    }

    setState(() {}); // Update the UI after fetching the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('In home Services Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchDataFromFirebase,
              child: Text('Check Status'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                // Wrap with SingleChildScrollView
                child: ListView.builder(
                  shrinkWrap: true, // Set shrinkWrap to true
                  itemCount: fetchedData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = fetchedData[index];
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Appointment Time:'),
                              Text(data['AppointmentTime']),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Appointment Date:'),
                              Text(data['AppointmentDate']),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Service:'),
                              Text(data['Selected Service'])
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
