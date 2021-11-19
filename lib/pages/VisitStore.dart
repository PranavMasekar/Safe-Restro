import 'package:flutter/material.dart';
import '../Components/Button.dart';
import '../database.dart';

class VisitStore extends StatefulWidget {
  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  final count = 5;
  final waiting = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1e192e),
      appBar: AppBar(
        backgroundColor: Color(0xff372e4a),
        title: Text(
          "Waiting Room",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Current Store Member Count is $count",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Current Waiting People : $waiting",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Store Name : ${Data.hotelname}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(title: "Stay in Queue"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff0cecda),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(
                        context,
                        "/home",
                      );
                    });
                  },
                  child: Text(
                    'Leave the queue',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
