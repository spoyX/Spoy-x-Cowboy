import 'package:eventmanager/services/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DateTime? _eventDate;
  String? _eventType = "Online";
  String? _eventStatus = "Active";

  void _addEvent() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String location = _locationController.text.trim();
    final String organizer = _organizerController.text.trim();
    final int? capacity = int.tryParse(_capacityController.text.trim());
    final List<String> tags = _tagsController.text.trim().split(',');

    if (title.isEmpty || description.isEmpty || location.isEmpty || _eventDate == null || capacity == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    try {
      await _firestoreService.addEvent(
          title, description, _eventDate!, location, _eventType!, organizer, capacity, tags, _eventStatus!);
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _organizerController.clear();
    _capacityController.clear();
    _tagsController.clear();
    _eventDate = null;
    setState(() {
      _eventType = "Online";
      _eventStatus = "Active";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        backgroundColor: Colors.grey[600], // Darker grey for the app bar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[300]!, Colors.grey[200]!], // Light grey gradient
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Event Title
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Description
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Location
                TextField(
                  controller: _locationController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Organizer
                TextField(
                  controller: _organizerController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Organizer',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Capacity
                TextField(
                  controller: _capacityController,
                  style: TextStyle(color: Colors.grey[800]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Capacity',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Tags
                TextField(
                  controller: _tagsController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Tags (comma-separated)',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Event Type Dropdown
                DropdownButtonFormField<String>(
                  value: _eventType,
                  onChanged: (value) => setState(() => _eventType = value),
                  items: ["Online", "In-person"]
                      .map((type) => DropdownMenuItem(value: type, child: Text(type, style: TextStyle(color: Colors.grey[800]))))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Event Type',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Event Status Dropdown
                DropdownButtonFormField<String>(
                  value: _eventStatus,
                  onChanged: (value) => setState(() => _eventStatus = value),
                  items: ["Active", "Canceled", "Completed"]
                      .map((status) => DropdownMenuItem(value: status, child: Text(status, style: TextStyle(color: Colors.grey[800]))))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Event Status',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Date Picker
                Text(
                  _eventDate == null
                      ? 'No date selected'
                      : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_eventDate!)}',
                  style: TextStyle(color: Colors.grey[800]),
                ),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[350]), // Button color
                ),
                SizedBox(height: 20),

                // Add Event Button
                ElevatedButton(
                  onPressed: _addEvent,
                  child: Text('Add Event'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[350]), // Button color
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
