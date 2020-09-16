import 'package:flutter/material.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/screens/fridge_screen.dart';
import 'package:munchy/screens/login_screen.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:munchy/screens/profile_screen.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:munchy/screens/recipes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:munchy/screens/registration_screen.dart';
import 'package:munchy/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
/*MultiProvider(
      child: MyApp(),
      providers: <ChangeNotifierProvider<ChangeNotifier>>[],
    ),*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: kAccentColor,
        primaryColor: kPrimaryColor,
        primaryColorDark: kPrimaryColorDark,
        primaryColorLight: kPrimaryColorLight,
        dividerColor: kDividerColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        RecipesScreen.id: (context) => RecipesScreen(),
        RecipeScreen.id: (context) => RecipeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        FridgeScreen.id: (context) => FridgeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        // MainMenu.id: (context) => MainMenu(),
      },
    );
  }
}
