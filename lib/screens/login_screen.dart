import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/rounded_button.dart';
import 'package:munchy/model/user.dart';
import 'package:munchy/screens/registration_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../constants.dart';
import '../components/navbar_initiator.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  MasterBloc masterBloc;

  bool showSpinner = false;
  String email;
  String password;

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
            mainAxisAlignment: MainAxisAlignment.end,
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
                text: 'Log In',
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      // masterBloc.storeUser(AppUser(
                      //     id: user.user.uid,
                      //     isMain: false,
                      //     name: user.user.email,
                      //     image: "",
                      //     houseID: "mCzz1QxDT7oXY3xGOIuA"));
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
                child: Text("New to the app? Register here."),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
              FlatButton(
                child: Text("Don't want to login? Access the app here."),
                onPressed: () {
                  pushNewScreen(context,
                      screen: NavBarInitiator(
                        menuScreenContext: context,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
