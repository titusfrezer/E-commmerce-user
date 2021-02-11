import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:random_string/random_string.dart';
import 'package:vendor/variables/vars.dart';

var Generatedcode;
class Nati extends StatefulWidget {
  @override
  _NatiState createState() => _NatiState();
}

class _NatiState extends State<Nati> {


  DatabaseReference cartRef = FirebaseDatabase.instance.reference().child("cart");
  DatabaseReference reqRef =
  FirebaseDatabase.instance.reference().child("NatiRequests");
  FirebaseAuth _auth;
  FirebaseUser user;
  String userPhone;
  String userName;
  var connectivity;
  String date;
  bool buttonColor = false;

  getCurrentUser() async {
    user = await _auth.currentUser();

    print(user.email.toString());
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
    date=DateTime.now().day.toString()+DateTime.now().month.toString()+DateTime.now().year.toString();
    print(date);
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .once()
        .then((DataSnapshot snapshot) {
      var key = snapshot.value.keys;
      var DATA = snapshot.value;
      for (var individualkey in key) {
        if (user.email == DATA[individualkey]['email']) {
          userPhone = DATA[individualkey]['identity'];
          userName =DATA[individualkey]['userName'];
          print(userPhone);
          print(userName);
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              child: RaisedButton(
                onPressed: () async {
                  Generatedcode = randomAlphaNumeric(5);
                    List check;
                    bool isChecked = false;
                    await reqRef.once().then((DataSnapshot snap) {
                      if (snap.value != null) {
                        isChecked = true;
                        var key = snap.value.keys;
                        var DATA = snap.value;
                        Map<dynamic, dynamic> map = snap.value;
                        check = map.values.toList();
                      }
                    });
                    if (isChecked) {
                      for (int i = 0; i < check.length; i++) {
                        if (check[i]['confirmationCode'].toString() == Generatedcode) {
                          Generatedcode = randomAlphaNumeric(5);
                          check.add(Generatedcode);
                          i = 0;
                        }
                      }
                    }

                    await reqRef.push().set(<dynamic, dynamic>{
                      'confirmationCode': Generatedcode,
                      'email':user.email,
                      'requestedFrom':userPhone,
                      'userName':userName,
                      'date':date,
                    });

                    print(Generatedcode);
                    print("user Phone $userPhone");

                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InsertCode(
                          )));

                },
                child: Center(
                  child: Text(
                        "Request Code",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),

                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }
}
class InsertCode extends StatefulWidget {
  @override
  _InsertCodeState createState() => _InsertCodeState();
}

class _InsertCodeState extends State<InsertCode> {
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(0, 0, 0, 5),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: 200,
            margin: EdgeInsets.only(left: 50, right: 50),
            child: PinPut(
              keyboardType: TextInputType.text,
              fieldsCount: 5,
              autofocus: true,
              withCursor: true,
              textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              onSubmit: (value) async {
                if (Generatedcode == value) {
                  print("equal with Generated code ie${Generatedcode}");
                  if (counter == 0) {
                    print("added to cart");
                    // await cartRef.push().set(<dynamic, dynamic>{
                    //   'productName': widget.productTitle,
                    //   'productPrice': widget.productPrice,
                    //   'productImage': widget.productImage_1,
                    //   'email': widget.userEmail,
                    // });
                  }
                  print("confirmed");
                  await Navigator.popAndPushNamed(context, '/confirm');
                } else {
                  print("Error confirmation code");
                }
              },
              controller: controller,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              submittedFieldDecoration:
              pinPutDecoration.copyWith(color: Colors.white),
              eachFieldHeight: 40,
              eachFieldWidth: 40,
              pinAnimationType: PinAnimationType.scale,
              onChanged: (value) {
                setState(() {
                  currentText = value;
                });
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                controller.clear();
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(color: fontWhite),
            ),
            color: background_2,
          ),
          Image.asset("assets/images/download.jpg"),
        ],
      ),
    );

  }
}
