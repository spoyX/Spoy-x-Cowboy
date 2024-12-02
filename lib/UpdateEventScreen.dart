import 'package:eventmanager/services/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateEventScreen extends StatefulWidget {
  final String eventId;
  final String currentTitle;
  final String currentDescription;
  final DateTime currentDate;
  final String currentLocation;
  final String currentEventType;
  final String currentOrganizer;
  final int currentCapacity;
  final List<String> currentTags;
  final String currentStatus;

  UpdateEventScreen({
    required this.eventId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentDate,
    required this.currentLocation,
    required this.currentEventType,
    required this.currentOrganizer,
    required this.currentCapacity,
    required this.currentTags,
    required this.currentStatus,
  });

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTitle;
    _descriptionController.text = widget.currentDescription;
    _locationController.text = widget.currentLocation;
    _eventTypeController.text = widget.currentEventType;
    _organizerController.text = widget.currentOrganizer;
    _capacityController.text = widget.currentCapacity.toString();
    _tagsController.text = widget.currentTags.join(', ');
    _statusController.text = widget.currentStatus;
    _eventDate = widget.currentDate;
  }

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

  void _updateEvent() async {
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
      await _firestoreService.updateEvent(
        widget.eventId,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event updated successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Event'), backgroundColor: Colors.grey[600]), // Dark grey app bar
      body: SingleChildScrollView(  // Wrap the entire body in a SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[300]!, Colors.grey[200]!], // Light grey gradient
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
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

                // Event Type
                TextField(
                  controller: _eventTypeController,
                  style: TextStyle(color: Colors.grey[800]),
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
                    labelText: 'Tags (comma separated)',
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

                // Status
                TextField(
                  controller: _statusController,
                  style: TextStyle(color: Colors.grey[800]),
                  decoration: InputDecoration(
                    labelText: 'Status',
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
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Event Date',
                        hintText: _eventDate == null ? 'No date selected' : DateFormat('yyyy-MM-dd').format(_eventDate!),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Update Event Button
                ElevatedButton(
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700], // Dark grey color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Update Event', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
