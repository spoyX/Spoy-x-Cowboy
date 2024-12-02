import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanager/services/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/EventDetailScreen.dart'; // Import the new screen
import 'package:intl/intl.dart';

import 'AddEventScreen.dart';
import 'UpdateEventScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToEventManager(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
  }

  void _deleteEvent(String id) async {
    try {
      await _firestoreService.deleteEvent(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _updateEvent(String id, String title, String description, DateTime date, String location, String eventType, String organizer, int capacity, List<String> tags, String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEventScreen(
          eventId: id,
          currentTitle: title,
          currentDescription: description,
          currentDate: date,
          currentLocation: location,
          currentEventType: eventType,
          currentOrganizer: organizer,
          currentCapacity: capacity,
          currentTags: tags,
          currentStatus: status,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        backgroundColor: Colors.grey[320],  // Dark gray color for AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.blueAccent),  // Accent blue color
            onPressed: () => _navigateToEventManager(context),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),  // Accent red color
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final id = event['id'] ?? '';
                final title = event['title'] ?? '';
                final description = event['description'] ?? '';
                final date = (event['date'] as Timestamp).toDate();
                final location = event['location'] ?? '';
                final eventType = event['eventType'] ?? '';
                final organizer = event['organizer'] ?? '';
                final capacity = event['capacity'] ?? 0;
                final tags = List<String>.from(event['tags'] ?? []);
                final status = event['status'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          title: title,
                          description: description,
                          date: date,
                          location: location,
                          eventType: eventType,
                          organizer: organizer,
                          capacity: capacity,
                          tags: tags,
                          status: status,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[800],  // Dark gray for the cards
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,  // White for the title
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(color: Colors.grey[300]),  // Light gray for description
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location: $location',
                            style: TextStyle(color: Colors.grey[400]),  // Slightly lighter gray
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                            style: TextStyle(color: Colors.grey[400]),  // Light gray date text
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),  // Accent blue for edit icon
                            onPressed: () => _updateEvent(id, title, description, date, location, eventType, organizer, capacity, tags, status),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),  // Accent red for delete icon
                            onPressed: () => _deleteEvent(id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
