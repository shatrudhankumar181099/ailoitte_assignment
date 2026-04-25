import 'package:cloud_firestore/cloud_firestore.dart';

class NoteRemoteDS {
  final _firestore = FirebaseFirestore.instance;

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }

  Future<void> upsertNote(Map<String, dynamic> data) async {
    final id = data['id'];
    await _firestore.collection('notes').doc(id).set(data, SetOptions(merge: true));
  }
}