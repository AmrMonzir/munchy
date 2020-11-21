import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/model/user.dart';
import 'package:munchy/screens/fridge_screen.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:munchy/screens/house_screen.dart';
import 'package:munchy/screens/rec_categories_screen.dart';
import 'package:munchy/screens/settings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavBarInitiator extends StatefulWidget {
  static String id = "navbar_initiator";
  final BuildContext menuScreenContext;
  const NavBarInitiator({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _NavBarInitiatorState createState() => _NavBarInitiatorState();
}

class _NavBarInitiatorState extends State<NavBarInitiator> {
  PersistentTabController _controller;
  bool _hideNavBar;
  FirebaseHelper firebaseHelper;
  MasterBloc masterBloc;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    initNotificationStuff();
    checkUserHasHouseBeforeListening();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  void checkUserHasHouseBeforeListening() async {
    firebaseHelper = FirebaseHelper();
    var userId = firebaseHelper.loggedInUser.uid;
    AppUser appUser = await masterBloc.getUser(userId);
    if (appUser == null) {
      appUser = AppUser(
          houseID: "",
          id: userId,
          image: "",
          name: firebaseHelper.loggedInUser.email,
          isMain: false);
      await masterBloc.storeUser(appUser);
    }
    String houseId = await firebaseHelper.checkUserHasHouseId(appUser);
    bool isHouseLead = false;
    if (houseId != "") {
      isHouseLead = await firebaseHelper.checkUserIsHouseLead(houseId, appUser);
    }
    await masterBloc.updateUser(AppUser(
      houseID: houseId,
      isMain: isHouseLead,
      name: firebaseHelper.loggedInUser.email,
      image: "",
      id: userId,
    ));
    if (houseId != "") {
      firebaseHelper.listenerToNotifications();
      firebaseHelper.listenerToIngredientChanges();
    } else {
      //delete only local ings
      masterBloc.deleteLocalIngs();
    }
    firebaseHelper.syncOnlineRecipesToLocal(context);
  }

  void initNotificationStuff() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      FridgeScreen(),
      RecipesCategoriesScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> fillBottomNavigationBarContents() {
    List<PersistentBottomNavBarItem> itemList = [];
    kBottomNavigationBarIconsAndStrings.forEach((key, value) {
      PersistentBottomNavBarItem item;
      if (key == "My fridge") {
        item = PersistentBottomNavBarItem(
          title: key,
          icon: Image(
              width: 30, height: 35, image: AssetImage("images/fridge.png")),
          activeColor: kAccentColor,
          activeContentColor: Colors.white,
          inactiveColor: Colors.grey,
        );
      } else {
        item = PersistentBottomNavBarItem(
          title: key,
          activeContentColor: Colors.white,
          icon: Icon(
            kBottomNavigationBarIconsAndStrings[key],
          ),
          activeColor: kAccentColor,
          inactiveColor: Colors.grey,
        );
      }
      itemList.add(item);
    });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: fillBottomNavigationBarContents(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      navBarHeight: kBottomNavigationBarHeight,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      hideNavigationBar: _hideNavBar,
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style7, // Choose the nav bar style with this property
    );
  }
}
