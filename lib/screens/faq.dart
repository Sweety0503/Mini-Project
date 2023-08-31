import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  TextEditingController textFieldController = TextEditingController();
  CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('faq_ans'); // Replace with your collection name

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: SizedBox(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'F A Q',
              style: TextStyle(color: Colors.white),
            ),
          ]),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: dataCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }

                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> data =
                          documents[index].data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          title: Text(data[
                              'query']), // Replace with your document field name
                          subtitle: Text(data[
                              'answer']), // Replace with your document field name
                        ),
                      );
                    },
                  );
                }

                return Text('No data found.');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                labelText: 'Enter query',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String text = textFieldController.text;

              // Send text to a different collection
              CollectionReference textCollection = FirebaseFirestore.instance
                  .collection(
                      'FAQ'); // Replace with your different collection name

              textCollection.add({
                'query': text,
              }).then((value) {
                textFieldController.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Text sent successfully.'),
                ));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to send text.'),
                ));
              });
            },
            child: Text('Send Query'),
          ),
        ],
      ),
    );
  }
}
