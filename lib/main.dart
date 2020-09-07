import 'package:flutter/material.dart';
import 'package:munchy/screens/login_screen.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:munchy/screens/recipes_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        RecipesScreen.id: (context) => RecipesScreen(),
        RecipeScreen.id: (context) => RecipeScreen(),
      },
    );
  }
}
