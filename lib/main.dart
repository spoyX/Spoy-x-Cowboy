import 'package:eventmanager/EventManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (_) => LoginPage(),
            '/signup': (_) => SignupScreen(),
            '/home': (_) => HomeScreen(),
            '/add_event': (_) => EventManagerScreen(),
            // Removed separate route for Update EventScreen as it is navigated directly
          },
        );
      },
    );
  }
}