import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/member_card.dart';
import 'package:munchy/components/rounded_button.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/model/user.dart';
import '../constants.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

User loggedInUser;

class HouseScreen extends StatefulWidget {
  static String id = "profile_screen";
  @override
  _HouseScreenState createState() => _HouseScreenState();
}

class _HouseScreenState extends State<HouseScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller;
  TextEditingController _houseIdTextController;
  bool showSpinner = false;
  String userEnteredHouseId = "";
  MasterBloc masterBloc;
  AppUser currUser;
  List<MemberCard> members = [];
  FirebaseHelper firebaseHelper;

  @override
  void initState() {
    super.initState();
    firebaseHelper = FirebaseHelper();
    _controller = TextEditingController();
    _houseIdTextController = TextEditingController();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHouseMembers());
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
        title: Text(
          "House Members",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: loggedInUser == null
            ? Center(
                child: Text(
                "Please log in to be able to create and join houses!",
                style: TextStyle(fontFamily: "Poppins", fontSize: 16),
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  members.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                return members[index];
                              }),
                        )
                      : Expanded(
                          child: ModalProgressHUD(
                            inAsyncCall: showSpinner,
                            child: Center(
                              child: Column(
                                children: [
                                  RoundedButton(
                                    text: "Create house",
                                    color: kPrimaryColor,
                                    onPress: () async {
                                      var houseIdReference = await _firestore
                                          .collection('houses')
                                          .add({
                                        'admin_id': loggedInUser.uid,
                                        'admin_email': loggedInUser.email,
                                        'house_id': "",
                                      });
                                      print(
                                          "house id is: ${houseIdReference.id}");

                                      await _firestore
                                          .collection('houses')
                                          .doc("${houseIdReference.id}")
                                          .update({
                                        'admin_id': loggedInUser.uid,
                                        'admin_email': loggedInUser.email,
                                        'house_id': "${houseIdReference.id}",
                                      });

                                      AppUser userToStore = AppUser(
                                          id: loggedInUser.uid,
                                          name: loggedInUser.email,
                                          image: "",
                                          houseID: houseIdReference.id,
                                          isMain: true);
                                      await masterBloc.updateUser(userToStore);
                                      setState(() {
                                        currUser = userToStore;
                                      });

                                      await _firestore
                                          .collection('users')
                                          .doc(currUser.id)
                                          .update(
                                              {"houseID": currUser.houseID});
                                      firebaseHelper.listenerToNotifications();
                                      firebaseHelper
                                          .listenerToIngredientChanges();
                                      firebaseHelper.syncIngChangesToFirebase();
                                      await _loadHouseMembers();
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
                                              title: Text(
                                                  "Enter house id to join house"),
                                              content: TextField(
                                                controller:
                                                    _houseIdTextController,
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
                                                      DocumentSnapshot
                                                          snapshot =
                                                          await _firestore
                                                              .collection(
                                                                  'houses')
                                                              .doc(
                                                                  '$userEnteredHouseId')
                                                              .get();

                                                      int count = 0;
                                                      print(snapshot.data());
                                                      if (!snapshot
                                                          .data()
                                                          .keys
                                                          .contains("admin_id"))
                                                        return;

                                                      for (var key in snapshot
                                                          .data()
                                                          .keys) {
                                                        if (key.contains(
                                                                "admin_id") ||
                                                            key.contains(
                                                                "member_id")) {
                                                          count++;
                                                        }
                                                      }
                                                      await _firestore
                                                          .collection('houses')
                                                          .doc(
                                                              '$userEnteredHouseId')
                                                          .update({
                                                        count.toString() +
                                                                "member_id":
                                                            loggedInUser.uid,
                                                        count.toString() +
                                                                "member_email":
                                                            loggedInUser.email,
                                                      });
                                                      AppUser userToUpdate =
                                                          AppUser(
                                                              id: loggedInUser
                                                                  .uid,
                                                              name: loggedInUser
                                                                  .email,
                                                              image: "",
                                                              houseID:
                                                                  userEnteredHouseId,
                                                              isMain: false);
                                                      await masterBloc
                                                          .updateUser(
                                                              userToUpdate);

                                                      setState(() {
                                                        currUser = userToUpdate;
                                                      });

                                                      await _firestore
                                                          .collection('users')
                                                          .doc(currUser.id)
                                                          .update({
                                                        "houseID":
                                                            currUser.houseID
                                                      });
                                                      firebaseHelper
                                                          .listenerToNotifications();
                                                      firebaseHelper
                                                          .listenerToIngredientChanges();
                                                      firebaseHelper
                                                          .syncOnlineIngsToLocal(
                                                              context);

                                                      await _loadHouseMembers();
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                    showSpinner = false;
                                                    Navigator.of(context).pop();
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
                        ),
                  currUser?.houseID == null
                      ? Text(
                          "Create house to copy house id",
                          style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                        )
                      : Builder(
                          builder: (context) {
                            return RaisedButton(
                              child: Text(
                                "House id: ${currUser.houseID}",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: "Poppins"),
                              ),
                              color: kAccentColor,
                              onPressed: () {
                                ClipboardManager.copyToClipBoard(
                                        currUser.houseID)
                                    .then((result) {
                                  final snackBar = SnackBar(
                                    content: Text('Copied to Clipboard'),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              },
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }

  _loadHouseMembers() async {
    members = [];
    setState(() {
      showSpinner = true;
    });
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        var u = await masterBloc.getUser(loggedInUser.uid);
        if (u != null)
          setState(() {
            currUser = u;
          });
      }
    } catch (e) {
      loggedInUser = null;
      print(e);
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('houses')
          .where("house_id", isEqualTo: currUser.houseID)
          .get();
      //Should only retrieve one house here with the above query
      for (var houses in snapshot.docs) {
        houses.data().forEach((key, value) {
          print(key);
          print(value);
          if (key.contains("member_email") || key.contains("admin_email")) {
            setState(() {
              members.add(MemberCard(
                userName: value,
                isAllowedToDelete: currUser.isMain && currUser.name != value,
                onPress: (currUser.isMain && currUser.name != value)
                    ? () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    "Are you sure you want to delete user $value"),
                                actions: [
                                  RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text("Yes"),
                                    onPressed: () async {
                                      await _deleteThisUser(value);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    : () {},
              ));
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  Future<void> _deleteThisUser(String userEmail) async {
    //Have to delete him from house doc
    //And delete house id from his user doc

    setState(() {
      showSpinner = true;
    });
    var snapshotOfHouse =
        await _firestore.collection('houses').doc(currUser.houseID).get();

    var sData = snapshotOfHouse.data();

    var snapshotOfUser = await _firestore
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .get();

    String userId;
    Map<String, dynamic> user = snapshotOfUser.docs.first.data();
    user["houseID"] = "";

    for (var users in snapshotOfUser.docs) {
      users.data().forEach((key, value) {
        if (key == "uid") {
          userId = value;
        }
      });
    }

    sData.removeWhere((key, value) {
      return value == userId || value == userEmail;
    });

    await _firestore.collection('houses').doc(currUser.houseID).set(sData);
    await _firestore.collection('users').doc(userId).update(user);
    AppUser u = await masterBloc.getUser(userId);

    if (u != null) {
      await masterBloc.updateUser(AppUser(
        houseID: "",
        image: "",
        name: u.name,
        id: u.id,
        isMain: false,
      ));
    }

    await _loadHouseMembers();

    setState(() {
      showSpinner = false;
    });
  }
}
