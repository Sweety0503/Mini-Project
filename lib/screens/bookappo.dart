import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String specialization;
  final String qualification;
  final String workingTime;

  Doctor(this.name, this.specialization, this.qualification, this.workingTime);
}

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('doctors').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occurred'));
          } else {
            final cardIds = snapshot.data!.docs.map((doc) => doc.id).toList();

            return ListView.builder(
              itemCount: cardIds.length,
              itemBuilder: (context, index) {
                final cardId = cardIds[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(cardId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error occurred'));
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text('Card not found'));
                    } else {
                      final cardData =
                          snapshot.data?.data() as Map<String, dynamic>;
                      final doctor = Doctor(
                        cardData['name'] as String,
                        cardData['specialization'] as String,
                        cardData['qualification'] as String,
                        cardData['workingTime'] as String,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDataPage(doctor),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(doctor.name),
                            leading: CircleAvatar(child: Icon(Icons.person_3)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Specialization: ${doctor.specialization}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Qualification: ${doctor.qualification}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Available Time: ${doctor.workingTime}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class UserData {
  String name;
  String gmail;
  int age; // Change the type to int
  String gender;
  String address;

  UserData(this.name, this.gmail, this.age, this.gender, this.address);
}

class UserDataPage extends StatefulWidget {
  final Doctor doctor;

  UserDataPage(this.doctor);

  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final _formKey = GlobalKey<FormState>();
  UserData userData = UserData('', '', 0, '', '');

  @override
  void initState() {
    super.initState();
    userData = UserData('', '', 0, '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  userData.name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gmail'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Gmail';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  userData.gmail = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  int? age = int.tryParse(value);
                  if (age == null || age > 101) {
                    return 'Please enter a valid age ';
                  }
                  return null;
                },
                onSaved: (value) {
                  int? age = int.tryParse(value!);
                  if (age != null) {
                    userData.age = age;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your gender';
                  }
                  if (value.toLowerCase() != 'm' &&
                      value.toLowerCase() != 'f' &&
                      value.toLowerCase() != 'male' &&
                      value.toLowerCase() != 'female' &&
                      value.toLowerCase() != 'other') {
                    return 'Please enter a valid gender (M/F/Other)';
                  }
                  return null;
                },
                onSaved: (value) {
                  userData.gender = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  userData.address = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    sendDetailsToFirebase();
                  }
                },
                child: Text('Send Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // A simple regex pattern to match email addresses
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void sendDetailsToFirebase() {
    final combinedDetails = {
      'Doctor name': widget.doctor.name,
      'Name': userData.name,
      'Age': userData.age,
      'Gender': userData.gender,
      'Address': userData.address,
      'Email': userData.gmail,
    };

    // Send combined details to Firebase
    FirebaseFirestore.instance
        .collection('combinedDetails')
        .add(combinedDetails)
        .then((value) {
      // Clear form fields
      _formKey.currentState?.reset();

      // Display a snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details sent successfully!'),
        ),
      );
    });
  }
}
