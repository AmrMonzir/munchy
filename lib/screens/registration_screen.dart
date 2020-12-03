import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/rounded_button.dart';
import 'package:munchy/model/user.dart';
import '../constants.dart';
import '../components/navbar_initiator.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  MasterBloc masterBloc;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

  bool showSpinner = false;
  String email;
  String password;
  String name;

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 300.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value.trim();
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  name = value.trim();
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your display name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Sign Up',
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      loggedInUser = user.user;
                      AppUser registeredUser = AppUser(
                          id: loggedInUser.uid,
                          isMain: false,
                          email: name,
                          image: "",
                          houseID: "");

                      await _firestore
                          .collection('users')
                          .doc(registeredUser.id)
                          .set({
                        "houseID": registeredUser.houseID,
                        "uid": registeredUser.id,
                        "email": loggedInUser.email,
                        "image": registeredUser.image,
                        "name": registeredUser.email,
                      });

                      masterBloc.storeUser(registeredUser);

                      Navigator.pushNamed(context, NavBarInitiator.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                  showSpinner = false;
                },
                color: Color(0xFFF44336),
              ),
              FlatButton(
                child: Text("Don't want to register? Access the app here."),
                onPressed: () {
                  Navigator.pushNamed(context, NavBarInitiator.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
