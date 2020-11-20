import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/model/user_dao.dart';
import 'package:munchy/screens/login_screen.dart';

User loggedInUser;

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final ingredientDao = IngredientsDao();
  MasterBloc masterBloc;
  String welcomeText = "Have you had breakfast yet?";
  FirebaseHelper firebaseHelper;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    firebaseHelper = FirebaseHelper();
    firebaseHelper.syncOnlineIngsToLocal(context);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    //TODO sync fridge here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Image.asset(
                'images/appBarLogo.png',
                height: 60,
                width: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Munchy"),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                welcomeText,
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          RaisedButton(
            child: Text("Click here to delete all recs in database"),
            onPressed: () async {
              await masterBloc.deleteAllRecs();
            },
          ),
          RaisedButton(
            child: Text("Click here to insert ings in database"),
            onPressed: () async {
              await ingredientDao.insertIngsInDB();
            },
          ),
          RaisedButton(
            child: Text("Click here to delete all ings from database"),
            onPressed: () async {
              await ingredientDao.deleteAllIngs();
            },
          ),
          RaisedButton(
            child: Text("Click here to logout"),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          RaisedButton(
            child: Text("Click here to delete all users"),
            onPressed: () async {
              UserDao ud = UserDao();
              await ud.deleteAllUsers();
            },
          )
        ],
      ),
    );
  }
}
