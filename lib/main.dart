import 'package:chatbot/screen/chat_screen.dart';
import 'package:chatbot/screen/greeting_screen.dart';
import 'package:chatbot/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/screen/sign_in_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Khởi tạo SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Kiểm tra giá trị của biến boolean được lưu trữ trong SharedPreferences
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  if (isFirstTime) {
    // Đây là lần đầu tiên ứng dụng được mở
    await prefs.setBool('first_time', false);
    runApp(HomePageFirst());
  } else {
    // Ứng dụng đã được mở trước đó
    runApp(HomePage());
  }
}

class HomePageFirst extends StatefulWidget {
  @override
  _HomePageStateFirst createState() => _HomePageStateFirst();
}

class _HomePageStateFirst extends State<HomePageFirst> {
  String? initialRoute;
  bool? check;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      home: Greeting(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? initialRoute;
  bool? check;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      home: Login(),
    );
  }
}


