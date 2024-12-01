// Import necessary packages
import 'package:eventmanager/EventManagerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './EventManagerScreen.dart'; // Ensure this path is correct

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void navigateToEventManager(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EventManagerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser ;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome, ${user.email ?? "User "}!"),
                  SizedBox(height: 20),
                  Text("You are now logged in."),
                  ElevatedButton(
                    onPressed: () => navigateToEventManager(context),
                    child: Text("Go to Event Manager"),
                  ),
                ],
              ),
      ),
    );
  }
}