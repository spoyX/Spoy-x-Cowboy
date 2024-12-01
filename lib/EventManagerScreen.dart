import 'package:eventmanager/services/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventManagerScreen extends StatefulWidget {
  @override
  _EventManagerScreenState createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _eventDate;

  void _addEvent() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String location = _locationController.text.trim();

    if (title.isEmpty || description.isEmpty || location.isEmpty || _eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    try {
      await _firestoreService.addEvent(title, description, _eventDate!, location);
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _updateEvent(String id, String currentTitle, String currentDescription, DateTime currentDate, String currentLocation) {
    _titleController.text = currentTitle;
    _descriptionController.text = currentDescription;
    _locationController.text = currentLocation;
    _eventDate = currentDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
              TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location')),
              SizedBox(height: 10),
              Text(_eventDate == null ? 'No date selected' : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_eventDate!)}'),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _eventDate ?? DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _eventDate = selectedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _firestoreService.updateEvent(
                      id, _titleController.text, _descriptionController.text, _eventDate!, _locationController.text);
                  Navigator.pop(context);
                  _clearFields();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event updated successfully!')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
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

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _eventDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Manager')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Event Title')),
                TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
                TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location')),
                SizedBox(height: 10),
                Text(_eventDate == null ? 'No date selected' : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_eventDate!)}'),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _eventDate ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _eventDate = selectedDate;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
                ElevatedButton(onPressed: _addEvent, child: Text('Add Event')),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>( // Listening for real-time updates
              stream: _firestoreService.getEvents(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final id = event['id'] ?? ''; // Use the document ID for updates/deletes
                    final title = event['title'] ?? '';
                    final description = event['description'] ?? '';
                    final date = (event['date'] as Timestamp).toDate();
                    final location = event['location'] ?? '';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('$description\nLocation: $location\nDate: ${DateFormat('yyyy-MM-dd').format(date)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateEvent(id, title, description, date, location),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteEvent(id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}