import 'package:flutter/material.dart';
import 'package:munchy/components/member_card.dart';
import 'package:munchy/components/rounded_button.dart';
import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "profile_screen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _emailOfAddedMember = "";
  TextEditingController _controller;

  List<Widget> _getMembers() {
    List<Widget> list = [];
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            MemberCard(
              userImage: AssetImage("images/Amr Monzir.jpg"),
              userName: "Amr Monzir",
              onPress: () {
                //do nothing if main user is the clicker
              },
            ),
            MemberCard(
              userImage: AssetImage("images/Nour Adawi.jpg"),
              userName: "Nour Adawi",
              onPress: () {},
            ),
            Center(
              child: RoundedButton(
                color: kPrimaryColor,
                text: "Invite members",
                onPress: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Invite members",
                          style: TextStyle(fontSize: 18)),
                      content: TextField(
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter an email",
                          errorText: "Please enter a valid Email",
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kAccentColor, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        controller: _controller,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          _emailOfAddedMember = value;
                        },
                      ),
                      actions: [
                        RaisedButton(
                          child: Text("Send request"),
                          color: kAccentColor,
                          textColor: Colors.white,
                          onPressed: () {
                            //send request to given email to join house
                          },
                        ),
                        RaisedButton(
                          child: Text("Cancel"),
                          color: kAccentColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*RoundedButton(
          color: kPrimaryColor,
          text: "Add new house member",
        ),*/
