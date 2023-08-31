import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  String _name = '';
  String _address = '';
  int _age = 0;
  int _phoneNumber = 0;

  CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _profileCollection.doc('user_profile').set({
        'name': _name,
        'address': _address,
        'age': _age,
        'phoneNumber': _phoneNumber,
      });

      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _name = '';
        _address = '';
        _age = 0;
        _phoneNumber = 0;
      });
      Navigator.pop(context);
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Edit your profile"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    initialValue: _name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    initialValue: _address,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Age'),
                    initialValue: _age.toString(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Age';
                      } else if (value.length > 2 ||
                          int.tryParse(value) == null) {
                        return 'Enter valid age';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _age = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    initialValue: _phoneNumber.toString(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10 ||
                          int.tryParse(value) == null) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phoneNumber = int.parse(value!);
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PROFILE'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 500,
                height: 100,
                child: Card(
                  color: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 10,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: _profileCollection.doc('user_profile').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data() as Map<String, dynamic>?;

                    return Column(
                      children: [
                        Container(
                          width: 500,
                          height: 60,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Name:${data?['name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 500,
                          height: 60,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Address:${data?['address'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 500,
                          height: 60,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Age:${data?['age'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 500,
                          height: 60,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Phone Number:${data?['phoneNumber'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Container(
                width: 500,
                height: 100,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _showEditProfileDialog,
                  child: Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
