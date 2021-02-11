import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/LoginScreen.dart';
import 'package:vendor/variables/Categories.dart';

import 'package:vendor/variables/vars.dart';

import 'About.dart';
import 'Help.dart';
import 'SingleProductDetail.dart';
import 'fetchDigital.dart';

List<String> carouselImage = List();
bool searchVisible = false;
String userPhone;
String userName;
class fetchCategory extends StatefulWidget {
  @override
  _fetchCategoryState createState() => _fetchCategoryState();
}

class _fetchCategoryState extends State<fetchCategory> {
  DatabaseReference productRef =
      FirebaseDatabase.instance.reference().child("catagory");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        var keys = snapshot.value.keys;
        var DATA = snapshot.value;
        Map<dynamic, dynamic> map = snapshot.value;
        int listLength = map.values.toList().length;
        for (var individualKey in keys) {
          carouselImage.add(DATA[individualKey]['image_0'].toString());
        }
      }
    });
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
          userName = DATA[individualkey]['userName'];
          print("phone $userPhone");
          print("name $userName");
        }
      }
    });
  }

  var keys, data;
  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;
  List<String> Data;
  var queryResultSet = [];
  var tempSearchStore = [];
  var imageResult = [];
  var imageTempStore = [];

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        imageResult = [];
        imageTempStore = [];
      });
    }
    var capitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);
    if (queryResultSet.isEmpty && value.toString().length == 1) {
      print("true");
      Query query = FirebaseDatabase.instance
          .reference()
          .child('product')
          .orderByChild('firstLetter')
          .equalTo(value.substring(0, 1).toUpperCase());
      query.once().then((DataSnapshot snapshot) {
        var KEYS = snapshot.value.keys;
        var DATA = snapshot.value;
        for (var individualKey in KEYS) {
          print("${DATA[individualKey]['productName']} is the value");
          queryResultSet.add(DATA[individualKey]);
          imageResult.add(DATA[individualKey]['image_0']);
        }
      });
    } else {
      print('not found');
      tempSearchStore = [];
      imageTempStore = [];
      queryResultSet.forEach((element) {
        print("titus element${element['productName']}");
        //print("element is ${element['productName'][0]}");
        if (element['productName'].toString().startsWith(capitalizedValue)) {
          print("hooray");
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
      imageResult.forEach((element) {
        setState(() {
          imageTempStore.add(element);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: background_2,
        title: Text(
          "Afroel",
          style: TextStyle(
              color: fontWhite, fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: background_2,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ClipRect(
              child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/images/ecorp-lightblue.png'),
                          fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child:Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Icon(Icons.input,size: 40,),
                        FlatButton(
                          color: Colors.deepOrangeAccent,
                          child: Text('Login'),
                          onPressed: (){
                            Navigator.of(context).pop();
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                        )
                      ],
                    )
                  )),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(
                  Icons.book,
                  color: background,
                ),
                title: Text('Digital Documents'),
                onTap: () {
                  // CategoriesVendor();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => fetchDigital(userPhone,userName)));
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Help()));
              },
              child: ListTile(
                leading: Icon(Icons.help, color: background),
                title: Text('Help'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => About()));
              },
              child: ListTile(
                leading: Icon(Icons.alternate_email, color: background),
                title: Text('About'),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            width: 250,
            // duration: Duration(seconds: 2),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              shape: BoxShape.rectangle,

              // borderRadius: BorderRadius.all(Radius.circular(50))
            ),

            child: TextField(
              style: TextStyle(color: fontWhite),
              onChanged: (val) {
                initiateSearch(val);
                // print("${val} textfiesl");
              },
              cursorColor: fontWhite,
              //controller: null,
              textInputAction: TextInputAction.search,

              decoration: InputDecoration(
                  icon: Icon(Icons.search, color: fontWhite),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  hoverColor: Colors.white10,
                  fillColor: Colors.white,
                  hintText: "Search",
                  hintStyle: TextStyle(color: fontWhite)),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  shrinkWrap: true,
                  primary: false,
                  children: tempSearchStore.map((element) {
                    return buildResultCard(element, context);
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: background_2,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                          ),
                          child: Text("Categories",
                              style: TextStyle(
                                  color: fontWhite,
                                  fontSize: fontHeader,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(height: 250, child: Categories()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

Widget buildResultCard(data, BuildContext context) {
  print("why does the data is not working${data}");
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleProductDetail(
              data['productName'],
              data['productDescription'],
              data['productPrice'],
              data['productCategory'],
              data['image_0'],
              data['image_1'],
              data['image_2'],
              data['vendorPhone'])));
    },
    child: Column(
      children: <Widget>[
        Expanded(
          child: Card(
            semanticContainer: true,
            elevation: 3,
            color: Colors.grey,
            child: GridTile(
              child: FadeInImage(
                image: NetworkImage(data['image_0']),
                placeholder: AssetImage('assets/images/cart.jpg'),
                fit: BoxFit.cover,
              ),
//
            ),
          ),
        ),
        Text(data['productName'],
            style: TextStyle(color: fontWhite, fontSize: 20)),
      ],
    ),
  );
}
