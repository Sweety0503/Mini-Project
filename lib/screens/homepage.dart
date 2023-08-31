import 'package:flutter/material.dart';

import 'package:ourapp/screens/bookappo.dart';

import 'package:ourapp/screens/help.dart';
import 'package:ourapp/screens/inhomeservices.dart';
import 'package:ourapp/provider/signIn.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourapp/screens/login.dart';
import 'package:ourapp/screens/profile.dart';
import 'package:ourapp/screens/status.dart';
import 'package:ourapp/utils/nextScreen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getData() async {
    final sp = context.read<signIn>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<signIn>();

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          child: Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/phclogo.png",
                    scale: 6,
                    fit: BoxFit.fitHeight,
                  ),
                  Column(
                    children: [
                      Text(
                        "P H C",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20),
                      ),
                      Text("Live,Love,Care",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: 'option1',
                    child: ElevatedButton(
                        onPressed: () {
                          sp.userSignOut();
                          nextScreenReplace(context, const login());
                        },
                        child: Text("Sign Out",
                            style: TextStyle(
                              color: Colors.black,
                            )))),
                PopupMenuItem<String>(
                    value: 'option1',
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Status()),
                          );
                        },
                        child: Text(" Status",
                            style: TextStyle(
                              color: Colors.black,
                            )))),
              ];
            },
            onSelected: (String value) {
              // Perform action when an option is selected
              print('Selected: $value');
            },
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 25,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.home),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notification()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.notifications),
              ),
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person),
              ),
            ),
            label: 'Account',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/homedoc1.png",
            fit: BoxFit.cover,
            width: 400,
            height: 400,
          ),
          Text("\n\n\n"),
          // Text(
          //   '      What do you need?\n',
          //   style: TextStyle(
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.blue),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Text("\n"),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.calendar_month_outlined),
                        ),
                        Text("       Book\n Appointment",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return InHomeServices();
                      }));
                    },
                    child: Column(
                      children: [
                        Text("\n"),
                        CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.house_rounded)),
                        Text(
                          "Inhome\nServices",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return help();
                      }));
                    },
                    child: Column(
                      children: [
                        Text("\n"),
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: const Icon(Icons.help_center)),
                        Text("Help",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class Notification extends StatelessWidget {
  final CollectionReference detailsCollection =
      FirebaseFirestore.instance.collection('notifications');

  Notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PHC'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: detailsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No details found.');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];

              String not = doc['text'] ?? '';

              return Container(
                width: 180,
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 25,
                          child: const Icon(Icons.circle_notifications)),
                      Text(not,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
