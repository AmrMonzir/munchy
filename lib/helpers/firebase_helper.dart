import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/user.dart';
import 'package:munchy/model/user_dao.dart';

class FirebaseHelper {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  UserDao userDao = UserDao();
  IngredientsDao ingredientsDao = IngredientsDao();
  MasterBloc masterBloc;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseHelper() {
    loggedInUser = _auth.currentUser;
  }

  Future<List<String>> getFellowUsers() async {
    AppUser us = await userDao.getUser(loggedInUser.uid);
    List<String> ids = [];
    var houseIdCollection =
        await _firestore.collection('houses').doc(us.houseID).get();
    houseIdCollection.data().forEach((key, value) {
      if (key.contains("admin_id") || key.contains("member_id")) {
        ids.add(value);
      }
    });
    return ids;
  }

  Future<void> syncIngChangesToFirebase({List<Ingredient> ings}) async {
    AppUser us = await userDao.getUser(loggedInUser.uid);

    if (ings == null) {
      ings = [];
      ings = await ingredientsDao.getLocalIngs();
    }
    for (var ing in ings) {
      _firestore
          .collection('houses')
          .doc(us.houseID)
          .collection('ingredients')
          .doc(ing.id.toString())
          .set(ing.toDatabaseJson());
    }
  }

  Future<void> syncOnlineIngsToLocal(BuildContext context) async {
    masterBloc = BlocProvider.of<MasterBloc>(context);

    AppUser us = await userDao.getUser(loggedInUser.uid);

    var response = await _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('ingredients')
        .get();
    response.docs.forEach((ingDoc) async {
      if ((await ingredientsDao.getIng(int.parse(ingDoc.id))) == null)
        ingredientsDao.createIng(Ingredient.fromDatabaseJson(ingDoc.data()));
      else {
        Ingredient ing = Ingredient.fromDatabaseJson(ingDoc.data());
        ingredientsDao.updateIng(ing);
        masterBloc.updateIng(ing);
      }
    });
  }

  Future<void> sendNotification(List<String> ids, String ingName) async {
    AppUser us = await userDao.getUser(loggedInUser.uid);

    Map<String, dynamic> notificationMap = {};
    for (int i = 0; i < ids.length; i++) {
      notificationMap["${ids[i]}"] = 0;
    }
    notificationMap["text"] = "You are almost out of: $ingName";

    _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('notifications')
        .add(notificationMap);
  }

  listenerToNotifications() async {
    AppUser us = await userDao.getUser(loggedInUser.uid);
    String notificationText;
    String notificationDocId;
    if (us.houseID == null || us.houseID == "") return;
    _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('notifications')
        .snapshots()
        .listen((event) async {
      for (var doc in event.docs) {
        if (doc.data()[us.id] != null) if (doc.data()[us.id] == 0) {
          notificationText = doc.data()["text"];
          notificationDocId = doc.id;
          _showNotification("You need to buy an ingredient!", notificationText);
          //Now edit yourself to "true" meaning you got the notification then check if every user also finished
          _firestore
              .collection('houses')
              .doc(us.houseID)
              .collection('notifications')
              .doc(notificationDocId)
              .update({
            us.id: 1,
          });
          //Now check if all are true and if so delete notification
          var snapshot = await _firestore
              .collection('houses')
              .doc(us.houseID)
              .collection('notifications')
              .doc(notificationDocId)
              .get();
          int countOfFalseIds = 0;
          snapshot.data().forEach((key, value) {
            if (value == 0) {
              countOfFalseIds++;
            }
          });
          if (countOfFalseIds == 0) {
            _firestore
                .collection('houses')
                .doc(us.houseID)
                .collection('notifications')
                .doc(notificationDocId)
                .delete();
          }
        }
      }
    });
  }

  Future<String> checkUserHasHouseId(AppUser user) async {
    String userHouseId = "";
    var data = await _firestore.collection('users').doc(user.id).get();
    userHouseId = data.data()['houseID'];
    return userHouseId;
  }

  Future<bool> checkUserIsHouseLead(String houseId, AppUser user) async {
    bool userIsAdmin = false;
    var data = await _firestore.collection('houses').doc(houseId).get();
    if (data.data()["admin_id"] == user.id) {
      userIsAdmin = true;
    }
    return userIsAdmin;
  }

  void listenerToIngredientChanges() async {
    AppUser us = await userDao.getUser(loggedInUser.uid);

    _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('ingredients')
        .snapshots()
        .listen((event) async {
      for (var doc in event.docs) {
        try {
          if ((await ingredientsDao.getIng(int.parse(doc.id))) == null)
            ingredientsDao.createIng(Ingredient.fromDatabaseJson(doc.data()));
          else {
            Ingredient ing = Ingredient.fromDatabaseJson(doc.data());
            ingredientsDao.updateIng(ing);
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }
}
