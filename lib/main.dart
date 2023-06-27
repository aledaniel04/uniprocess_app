import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniprocess_app/screens/userScreen/register_screen.dart';
import 'package:uniprocess_app/screens/HomeScreen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool hasUserData = await _checkUserData();

  runApp(MyApp(
    hasUserData: hasUserData,
  ));
}

Future<bool> _checkUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Verifica si existen datos guardados en el SharedPreferences
  final bool hasUserData =
      prefs.getString('selectedOption') != null && // Revisa una de las claves
          prefs.getString('name') != null &&
          prefs.getString('lastName') != null &&
          prefs.getString('email') != null &&
          prefs.getString('phoneNumber') != null;

  return hasUserData;
}

class MyApp extends StatelessWidget {
  final bool hasUserData;

  const MyApp({
    required this.hasUserData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: hasUserData ? HomeScreen() : RegisterScreen(),
    );
  }
}
