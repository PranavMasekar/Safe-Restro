import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_project/Components/Button.dart';
import 'package:firestore_project/pages/VisitStore.dart';
import 'package:firestore_project/pages/waiting.dart';
// import 'package:firestore_project/pages/waiting.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../database.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  Future<void> addUser(context) async {
    getcurrent(context).then(
      (_) => {
        if (Data.currentpeople < Data.maxallowed)
          {
            FirebaseFirestore.instance
                .collection('Hotels')
                .doc(Data.hotelname)
                .update(
              {"count": ++Data.currentpeople},
            ).then((value) => {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Data.useremail)
                          .set(
                        {
                          "mail": Data.useremail,
                          "hotel": Data.hotelname,
                        },
                        SetOptions(merge: true),
                      ),
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => VisitStore()),
                      )
                    })
          }
        else
          {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WaitingPage(
                    store: Data.hotelname,
                  ),
                ),
              );
            })
          }
      },
    );
  }

  String qrcode = "";

  final Stream<QuerySnapshot> studentStream =
      FirebaseFirestore.instance.collection('Hotel Vista').snapshots();

  bool scanned = false;
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (mounted) {
        setState(() {
          Data.hotelname = qrCode;
          scanned = true;
        });
      }
    } on Error {
      qrcode = 'Failed To Scan';
    }
  }

  Future<void> getHotel(context) async {
    FirebaseFirestore.instance
        .collection("users")
        .where('mail', isEqualTo: Data.useremail)
        .get()
        .then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (result) {
            setState(
              () {
                Data.hotelname = result.data()['hotel'];
              },
            );
            if (Data.hotelname != "")
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => VisitStore(),
                ),
              );
          },
        );
      },
    );
  }

  Future<void> getcurrent(context) async {
    await FirebaseFirestore.instance
        .collection("Hotels")
        .where('name', isEqualTo: Data.hotelname)
        .get()
        .then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (result) {
            setState(
              () {
                Data.currentpeople = result.data()['count'];
                Data.maxallowed = result.data()['max'];
              },
            );
          },
        );
      },
    );
  }

  void initState() {
    super.initState();
    getHotel(context).then(
      (_) {
        // getcurrent(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(Data.name);
    return AdvancedDrawer(
      drawer: MyDrawer(),
      backdropColor: Colors.deepPurple[400],
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff372e4a),
          title: Text('Safe Restro'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: studentStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('ERROR');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              color: Color(0xff1e192e),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Image.asset('assets/4.png'),
                      ),
                      Center(
                        child: Button(
                          title: "Scan QR Code",
                          press: () => scanQRCode(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (scanned && qrcode != "-1")
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Store Name: " + Data.hotelname,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff0cecda),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  addUser(context);
                                                },
                                                child: Text(
                                                  "Visit The Store",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: Button(
                                                  title: 'Cancel',
                                                  press: () => {
                                                    setState(
                                                      () {
                                                        qrcode = "";
                                                        scanned = false;
                                                      },
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
