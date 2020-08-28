import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/painting.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:random_string/random_string.dart';
import 'package:vendor/LogInUI.dart';
import 'package:vendor/LoginScreen.dart';
import 'package:vendor/variables/cart.dart';
import 'package:vendor/variables/vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

DatabaseReference cartRef = FirebaseDatabase.instance.reference().child("cart");
DatabaseReference reqRef =
FirebaseDatabase.instance.reference().child("Requests");
var Generatedcode;
String userPhone;
String userName;
int counter = 0;
int counter2 = 0;
int counter3 = 0;
String date;
class SingleProductDetail extends StatefulWidget {
  final String productImage_1;
  final String productImage_2;
  final String productImage_3;
  final String productTitle;
  final String productDescription;
  final String productCategory;
  final int productPrice;
  final String vendorPhone;

  SingleProductDetail(
      this.productTitle,
      this.productDescription,
      this.productPrice,
      this.productCategory,
      this.productImage_1,
      this.productImage_2,
      this.productImage_3,
      this.vendorPhone
      // this.productImage_4,
      );

  @override
  _SingleProductDetailState createState() => _SingleProductDetailState();
}

class _SingleProductDetailState extends State<SingleProductDetail> {
  DatabaseReference reqRef =
      FirebaseDatabase.instance.reference().child("Requests");
  DatabaseReference reqWish =
      FirebaseDatabase.instance.reference().child("WishList");
  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;

  bool buttonColor = false;

  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await (Connectivity().checkConnectivity());

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
    return SafeArea(
        child: Scaffold(
      // key: _scaffoldkey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: carouselHeight,
              child: Container(
                height: carouselHeight,
                child: Carousel(
                    borderRadius: true,
                    animationDuration: Duration(seconds: 3),
                    dotSize: 3,
                    dotColor: background_2,
                    boxFit: BoxFit.cover,
                    images: [
                      FadeInImage(
                        placeholder: AssetImage('assets/images/men1.jpeg'),
                        image: NetworkImage(widget.productImage_1),
                        fit: BoxFit.cover,
                      ),
                      FadeInImage(
                        placeholder: AssetImage('assets/images/men1.jpeg'),
                        image: NetworkImage(widget.productImage_2),
                        fit: BoxFit.cover,
                      ),
                      FadeInImage(
                        placeholder: AssetImage('assets/images/men1.jpeg'),
                        image: NetworkImage(widget.productImage_3),
                        fit: BoxFit.cover,
                      ),
//                        FadeInImage(
//                          placeholder: AssetImage('assets/images/men1.jpeg'),
//                          image: NetworkImage(widget.productImage_4),
//                          fit: BoxFit.cover,
//                        )
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          widget.productTitle,
                          style: TextStyle(
                              fontSize: fontHeader,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.productPrice.toString()} ETB',
                          style: TextStyle(
                              fontSize: fontHeader,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "Product Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontHeader,
                                color: background_2),
                          ),
                        ),
                        Container(
                          child: signedIn
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color:
                                        buttonColor == true ? background : null,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (buttonColor == true) {
                                        buttonColor = false;
                                      } else {
                                        buttonColor = true;
                                      }
                                    });
                                    await reqWish
                                        .once()
                                        .then((DataSnapshot snap) {
                                      print("Keys ${snap.value}");
                                      var keys = snap.value.keys;
                                      var DATA = snap.value;

                                      if (keys != null) {
                                        for (var individualKey in keys) {
                                          if (DATA[individualKey]['email'] ==
                                              user.email) {
                                            if (DATA[individualKey]
                                                    ['productName'] ==
                                                widget.productTitle) {
                                              counter2++;
                                            }
                                          }
                                        }
                                      }
                                    });
                                    if (counter2 == 0) {
                                      await reqWish
                                          .push()
                                          .set(<dynamic, dynamic>{
                                        'email': user.email,
                                        'productName': widget.productTitle,
                                        'productImage': widget.productImage_1,
                                        'productPrice': widget.productPrice
                                      });
                                    }
                                  })
                              : Text(""),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.productDescription,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade500),
                              ),
                              alignment: Alignment.topLeft,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    height: 75,
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 100, right: 100),
                      onPressed: () async {
                        Generatedcode =randomAlphaNumeric(5);
                        if (snapshot.hasData) {
                          await cartRef.once().then((DataSnapshot snap) {
                            var key = snap.value.keys;
                            var DATA = snap.value;
                            for (var individualkey in key) {
                              if (DATA[individualkey]['productName'] ==
                                      widget.productTitle &&
                                  user.email == DATA[individualkey]['email']) {
                                counter++;
                              } else {
                                print('the same');
                              }
                            }
                          });

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
                            'postedBy':widget.vendorPhone,
                            'productImage':widget.productImage_1,
                            'productName':widget.productTitle,
                            'requestedFrom':userPhone,
                            'userName':userName,
                            'date':date,
                            'price':widget.productPrice
                          });

                          //   _showSnackBar('Enter your confirmation code');

                          print(Generatedcode);
                          print("user Phone $userPhone");

                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InsertCode(
                                  widget.productTitle,
                                  widget.productPrice,
                                  widget.productImage_1,
                                  user.email)));
                        } else {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        }
                      },
                      child: Text(
                        "Buy Now",
                        style:
                            TextStyle(fontSize: fontHeader, color: fontWhite),
                      ),
                      color: Colors.pink,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class InsertCode extends StatefulWidget {
  final String productTitle;
  final int productPrice;
  final String productImage_1;
  final String userEmail;
  var keytoDelete;
  InsertCode(this.productTitle, this.productPrice, this.productImage_1,
      this.userEmail);

  @override
  _InsertCodeState createState() => _InsertCodeState();
}

class _InsertCodeState extends State<InsertCode> {
  TextEditingController controller = TextEditingController();

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background_2,
        title: Text('Confirm'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Image.asset("assets/images/download.jpg"),
            Container(
              child: GestureDetector(
                onTap: () => UrlLauncher.launch('tel:0936377294'),
                child: Center(
                  child: Column(
                    children: <Widget>[Text("Call Admin"), Text('0936377294')],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 200,
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: PinCodeTextField(
                    onCompleted: (value) async {

                      if (Generatedcode == value) {
                        print("equal with Generated code ie${Generatedcode}");
                        if (counter == 0) {
                          print("added to cart");
                          await cartRef.push().set(<dynamic, dynamic>{
                            'productName': widget.productTitle,
                            'productPrice': widget.productPrice,
                            'productImage': widget.productImage_1,
                            'email': widget.userEmail,
                          });

                        }
//                        await reqRef.limitToLast(1).once().then((DataSnapshot snapshot){
//                          Map map = snapshot.value;
//                          widget.keytoDelete = map.keys.toList()[0];
//                          print(widget.keytoDelete);
//                          reqRef.child(widget.keytoDelete).remove();
//                        });

                        print("confirmed");
                        await Navigator.popAndPushNamed(context, '/confirm');
                      } else {
                        print("Error confirmation code");
                      }
                    },
                    backgroundColor: fontWhite,
                    controller: controller,
                    length: 5,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.box,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    selectedColor: background_2,
                    activeColor: background,
                    inactiveColor: background_2,
                    inactiveFillColor: Colors.white70,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
        backgroundColor: background_2,
      ),
      body: Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height / 2.5,),
          Text('Thank you for Purchasing',style: TextStyle(fontWeight: FontWeight.w600),),
          Icon(Icons.check,color: background,size: 70,)
        ],
      )),
    );
  }
}
