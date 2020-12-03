import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/rec_dao.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/model/user.dart';
import 'package:munchy/model/user_dao.dart';

class FirebaseHelper {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  User loggedInUser;
  UserDao userDao = UserDao();
  IngredientsDao ingredientsDao = IngredientsDao();
  RecipesDao recipesDao = RecipesDao();
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
    if (us == null) return;
    if (us.houseID == "") return;
    var response = await _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('ingredients')
        .get();
    response.docs.forEach((ingDoc) async {
      try {
        if ((await ingredientsDao.getIng(int.parse(ingDoc.id))) == null)
          ingredientsDao.createIng(Ingredient.fromDatabaseJson(ingDoc.data()));
        else {
          Ingredient ing = Ingredient.fromDatabaseJson(ingDoc.data());
          ingredientsDao.updateIng(ing);
          //to send update event for listeners
          masterBloc.updateIng(ing, false);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> sendNotification(List<String> ids, String ingName) async {
    AppUser us = await userDao.getUser(loggedInUser.uid);

    //make sure notification hasn't been sent already
    var resp = await _firestore
        .collection('houses')
        .doc(us.houseID)
        .collection('notifications')
        .where("text", isEqualTo: "You are almost out of: $ingName")
        .get();

    if (resp.docs.isEmpty) {
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
      return;
    }
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
          if (snapshot.data() != null) {
            snapshot.data().forEach((key, value) {
              if (value == 0) {
                countOfFalseIds++;
              }
            });
          }
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

  syncUserRecipesToFirebase() async {
    AppUser us = await userDao.getUser(loggedInUser.uid);
    List<Recipe> allFavRecs = await recipesDao.getFavoriteRecs();

    for (var rec in allFavRecs) {
      bool recIsLocal = false;
      if (rec.spoonacularSourceUrl != null) {
        if (rec.spoonacularSourceUrl == "") recIsLocal = true;
      } else {
        recIsLocal = true;
      }
      DateTime now = DateTime.now();
      String nowCurrTimestamp = now.millisecondsSinceEpoch.toString();

      TaskSnapshot task;
      if (recIsLocal) {
        task =
            await _storage.ref('${us.id}/${rec.id}').putFile(File(rec.image));

        var myJson = rec.toJson();
        myJson["imageURL"] = await task.ref.getDownloadURL();

        _firestore
            .collection('users')
            .doc(us.id)
            .collection('favourite_recipes')
            .doc(rec.id.toString() + nowCurrTimestamp)
            .set(myJson, SetOptions(merge: true));
      } else {
        _firestore
            .collection('users')
            .doc(us.id)
            .collection('favourite_recipes')
            .doc(rec.id.toString())
            .set(rec.toJson());
      }
    }
  }

  syncOnlineRecipesToLocal(BuildContext context) async {
    AppUser us = await userDao.getUser(loggedInUser.uid);
    masterBloc = BlocProvider.of<MasterBloc>(context);

    masterBloc.deleteAllRecs();

    var response = await _firestore
        .collection('users')
        .doc(us.id)
        .collection('favourite_recipes')
        .get();
    response.docs.forEach((recDoc) async {
      try {
        if ((await recipesDao.getRec(int.parse(recDoc.id))) == null) {
          Recipe rec = Recipe.fromJson(recDoc.data(), 0);
          if (recDoc.data()["imageURL"] != null)
            rec.image = recDoc.data()["imageURL"];
          recipesDao.createRec(rec);
        } else {
          Recipe rec = Recipe.fromJson(recDoc.data(), 0);
          if (recDoc.data()["imageURL"] != null)
            rec.image = recDoc.data()["imageURL"];
          recipesDao.updateRec(rec);
          //to send update event for listeners
          masterBloc.addRec(rec, false);
        }
      } catch (e) {
        print(e);
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

  void deleteThisRecipeFromFirebase(Recipe recipe) async {
    AppUser us = await userDao.getUser(loggedInUser.uid);
    var items = await _firestore
        .collection('users')
        .doc(us.id)
        .collection('favourite_recipes')
        .where("imageURL", isEqualTo: recipe.image)
        .get();
    for (var item in items.docs) {
      _firestore
          .collection('users')
          .doc(us.id)
          .collection('favourite_recipes')
          .doc(item.id)
          .delete();
    }
    _storage.refFromURL(recipe.image).delete();
  }
}
