import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/ing_dao.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ingredientDao = IngredientsDao();
  MasterBloc masterBloc;
  String welcomeText = "Have you had breakfast yet?";
  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
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
            child: Text("Click here to delete all from database"),
            onPressed: () async {
              await ingredientDao.deleteAllIngs();
            },
          ),
        ],
      ),
    );
  }
}
