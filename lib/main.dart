import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/navbar_initiator.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/screens/fridge_screen.dart';
import 'package:munchy/screens/login_screen.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:munchy/screens/house_screen.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:munchy/screens/rec_categories_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:munchy/screens/registration_screen.dart';
import 'package:munchy/screens/settings_screen.dart';

import 'helpers/push_notification_service.dart';

void main() async {
  MasterBloc masterBloc = MasterBloc();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BlocProvider<MasterBloc>(bloc: masterBloc, child: MyApp()));
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();

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
        RecipesCategoriesScreen.id: (context) => RecipesCategoriesScreen(),
        RecipeScreen.id: (context) => RecipeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        FridgeScreen.id: (context) => FridgeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        NavBarInitiator.id: (context) => NavBarInitiator(),
        // MainMenu.id: (context) => MainMenu(),
      },
    );
  }
}
