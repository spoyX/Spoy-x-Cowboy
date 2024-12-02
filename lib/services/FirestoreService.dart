import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create Event
  Future<void> addEvent(
      String title,
      String description,
      DateTime date,
      String location,
      String eventType,
      String organizer,
      int capacity,
      List<String> tags,
      String status) async {
    try {
      await _db.collection('events').add({
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'eventType': eventType,
        'organizer': organizer,
        'capacity': capacity,
        'tags': tags,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  // Read Events
  Stream<List<Map<String, dynamic>>> getEvents() {
    return _db.collection('events').orderBy('date', descending: false).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Adding the document ID to the data
        return data;
      }).toList();
    });
  }

  // Update Event
  Future<void> updateEvent(
      String id,
      String title,
      String description,
      DateTime date,
      String location,
      String eventType,
      String organizer,
      int capacity,
      List<String> tags,
      String status) async {
    try {
      await _db.collection('events').doc(id).update({
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'eventType': eventType,
        'organizer': organizer,
        'capacity': capacity,
        'tags': tags,
        'status': status,
      });
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  // Delete Event
  Future<void> deleteEvent(String id) async {
    try {
      await _db.collection('events').doc(id).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
