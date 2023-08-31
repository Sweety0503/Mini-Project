import 'package:flutter/material.dart';
import 'package:ourapp/screens/faq.dart';
import 'package:url_launcher/url_launcher.dart';

class help extends StatelessWidget {
  final String phoneNumber = '+91 8078737134';

  void callPhoneNumber() async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: SizedBox(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'HELP',
              style: TextStyle(color: Colors.white),
            ),
          ]),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: callPhoneNumber,
              child: Container(
                width: 300,
                height: 120,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        //   width: 10,
                        // ),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          phoneNumber,
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
              child: Container(
                width: 300,
                height: 120,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.question_answer,
                                color: Colors.white)),
                        SizedBox(height: 8.0),
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
