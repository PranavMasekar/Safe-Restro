import 'package:firestore_project/Authentication/auth.dart';
import 'package:firestore_project/pages/Store.dart';
import 'package:flutter/material.dart';
import 'package:firestore_project/pages/login.dart';
import '../Components/Button.dart';

class MyDrawer extends StatelessWidget {
  signOutMethod(context) async {
    await signout();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Color(0xff372e4a),
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imgurl),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$name ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$email ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Button2(title: "Logout", press: () => signOutMethod(context)),
              Button2(title: "My Hotel or Store", push : Store())
            ],
          ),
        ),
      ),
    );
  }
}
