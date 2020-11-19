import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/member_card.dart';
import 'package:munchy/components/rounded_button.dart';
import 'package:munchy/model/user.dart';
import '../constants.dart';

User loggedInUser;

class ProfileScreen extends StatefulWidget {
  static String id = "profile_screen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller;
  TextEditingController _houseIdTextController;
  bool showSpinner = false;
  bool hasHouse = false;
  String userEnteredHouseId = "";
  MasterBloc masterBloc;
  AppUser currUser;

  List<Widget> _getMembers() {
    List<Widget> list = [];
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadHouseMembers();
    _controller = TextEditingController();
    _houseIdTextController = TextEditingController();
    masterBloc = BlocProvider.of<MasterBloc>(context);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      loggedInUser = null;
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("House Members"),
        centerTitle: true,
      ),
      body: hasHouse
          ? Text("User has house")
          : ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Center(
                child: Column(
                  children: [
                    RoundedButton(
                      text: "Create house",
                      color: kPrimaryColor,
                      onPress: () async {
                        showSpinner = true;
                        AppUser user = AppUser(
                            id: loggedInUser.uid, name: loggedInUser.email);
                        var houseId =
                            await _firestore.collection('houses').add({
                          'admin_user': loggedInUser.uid,
                          'admin_email': loggedInUser.email,
                          'house_id': "",
                        });
                        print("house id is: ${houseId.id}");
                        user.houseID = houseId.id;
                        await _firestore
                            .collection('houses')
                            .doc("${houseId.id}")
                            .update({
                          'admin_user': loggedInUser.uid,
                          'admin_email': loggedInUser.email,
                          'house_id': "${houseId.id}",
                        });
                        setState(() {
                          hasHouse = true;
                        });
                        AppUser userToStore = AppUser(
                            id: loggedInUser.uid,
                            name: loggedInUser.email,
                            image: "",
                            houseID: houseId.id,
                            isMain: true);
                        await masterBloc.storeUser(userToStore);
                        _firestore.collection('users').add({
                          "uid": loggedInUser.uid,
                          "name": loggedInUser.email,
                          "image": "",
                          "houseID": houseId.id,
                        });
                        currUser = userToStore;
                        _loadHouseMembers();
                        showSpinner = false;
                      },
                    ),
                    RoundedButton(
                      text: "Join House",
                      color: kPrimaryColor,
                      onPress: () {
                        showDialog(
                            context: (context),
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Enter house id to join house"),
                                content: TextField(
                                  controller: _houseIdTextController,
                                  onChanged: (value) {
                                    setState(() {
                                      userEnteredHouseId = value;
                                    });
                                  },
                                ),
                                actions: [
                                  RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text("Join house"),
                                    onPressed: () async {
                                      showSpinner = true;
                                      try {
                                        DocumentSnapshot snapshot =
                                            await _firestore
                                                .collection('houses')
                                                .doc('$userEnteredHouseId')
                                                .get();
                                        int count = 0;
                                        print(snapshot.data());
                                        for (var key in snapshot.data().keys) {
                                          if (key.contains("admin") ||
                                              key.contains("member_id")) {
                                            count++;
                                          }
                                        }
                                        await _firestore
                                            .collection('houses')
                                            .doc('$userEnteredHouseId')
                                            .update({
                                          count.toString() + "member_id":
                                              loggedInUser.uid,
                                          count.toString() + "member_email":
                                              loggedInUser.email,
                                        });
                                        AppUser userToStore = AppUser(
                                            id: loggedInUser.uid,
                                            name: loggedInUser.email,
                                            image: "",
                                            houseID: userEnteredHouseId,
                                            isMain: false);
                                        await masterBloc.storeUser(userToStore);
                                        _firestore.collection('users').add({
                                          "uid": loggedInUser.uid,
                                          "name": loggedInUser.email,
                                          "image": "",
                                          "houseID": userEnteredHouseId,
                                        });
                                        currUser = userToStore;
                                        _loadHouseMembers();
                                        setState(() {
                                          hasHouse = true;
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                      showSpinner = false;
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _loadHouseMembers() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where("houseID", isEqualTo: currUser.houseID)
        .get();
    for (var user in snapshot.docs) {}
  }
}
// appBar: AppBar(
// title: Text("House Members"),
// centerTitle: true,
// ),
// body: Padding(
// padding: const EdgeInsets.only(top: 10.0),
// child: ListView(
// children: [
// MemberCard(
// userImage: AssetImage("images/Amr Monzir.jpg"),
// userName: "Amr Monzir",
// onPress: () {
// //do nothing if main user is the clicker
// },
// ),
// MemberCard(
// userImage: AssetImage("images/Nour Adawi.jpg"),
// userName: "Nour Adawi",
// onPress: () {},
// ),
// Center(
// child: RoundedButton(
// color: kPrimaryColor,
// text: "Invite members",
// onPress: () {
// showDialog(
// context: context,
// child: AlertDialog(
// title: Text("Invite members",
// style: TextStyle(fontSize: 18)),
// content: TextField(
// decoration: kTextFieldDecoration.copyWith(
// hintText: "Enter an email",
// errorText: "Please enter a valid Email",
// focusedBorder: OutlineInputBorder(
// borderSide:
// BorderSide(color: kAccentColor, width: 2.0),
// borderRadius:
// BorderRadius.all(Radius.circular(32.0)),
// ),
// ),
// controller: _controller,
// autocorrect: false,
// keyboardType: TextInputType.emailAddress,
// onChanged: (value) {
// _emailOfAddedMember = value;
// },
// ),
// actions: [
// RaisedButton(
// child: Text("Send request"),
// color: kAccentColor,
// textColor: Colors.white,
// onPressed: () {
// //send request to given email to join house
// },
// ),
// RaisedButton(
// child: Text("Cancel"),
// color: kAccentColor,
// textColor: Colors.white,
// onPressed: () {
// Navigator.of(context, rootNavigator: true).pop();
// },
// ),
// ],
// ),
// );
// },
// ),
// )
// ],
// ),
// ),

/*RoundedButton(
          color: kPrimaryColor,
          text: "Add new house member",
        ),*/
