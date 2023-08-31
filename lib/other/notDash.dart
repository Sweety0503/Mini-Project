import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference notList =
      FirebaseFirestore.instance.collection('Notification');

  Future<void> createUserData(String not1) async {
    return await notList.doc(not1).set({'Notification': not1});
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await notList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
