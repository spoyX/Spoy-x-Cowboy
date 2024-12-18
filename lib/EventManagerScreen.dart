import 'package:flutter/material.dart';
import 'package:eventmanager/services/FirestoreService.dart';
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
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  DateTime? _eventDate;

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _eventDate) {
      setState(() {
        _eventDate = selectedDate;
      });
    }
  }

  void _addEvent() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _eventDate == null ||
        _eventTypeController.text.trim().isEmpty ||
        _organizerController.text.trim().isEmpty ||
        _capacityController.text.trim().isEmpty ||
        _tagsController.text.trim().isEmpty ||
        _statusController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    try {
      await _firestoreService.addEvent(
        _titleController.text,
        _descriptionController.text,
        _eventDate!,
        _locationController.text,
        _eventTypeController.text,
        _organizerController.text,
        int.parse(_capacityController.text),
        _tagsController.text.split(','),
        _statusController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event added successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Event Title')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location')),
            TextField(controller: _eventTypeController, decoration: InputDecoration(labelText: 'Event Type')),
            TextField(controller: _organizerController, decoration: InputDecoration(labelText: 'Organizer')),
            TextField(controller: _capacityController, decoration: InputDecoration(labelText: 'Capacity'), keyboardType: TextInputType.number),
            TextField(controller: _tagsController, decoration: InputDecoration(labelText: 'Tags (comma separated)')),
            TextField(controller: _statusController, decoration: InputDecoration(labelText: 'Status')),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    hintText: _eventDate == null ? 'No date selected' : DateFormat('yyyy-MM-dd').format(_eventDate!),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addEvent,
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
