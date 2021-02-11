import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/UI/Admin/Post.dart';
import 'package:vendor/UI/Admin/PostOnSpecificCategory.dart';
import 'package:vendor/variables/PostVar.dart';

import 'package:vendor/variables/ProductList.dart';
import 'package:vendor/variables/vars.dart';


class SpecificCategoryListVendor extends StatefulWidget {
  final String category;
  var KEYS;

  SpecificCategoryListVendor(this.category);

  @override
  _SpecificCategoryListVendorState createState() =>
      _SpecificCategoryListVendorState();
}

class _SpecificCategoryListVendorState
    extends State<SpecificCategoryListVendor> {
  List<PostVar> postedProducts = [];
  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;
  bool check = false;
  String currentState;


  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await(Connectivity().checkConnectivity());
    print(user.email.toString());
  }


  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
    print("The category is ${widget.category}");
    //Query query = FirebaseDatabase.instance.reference().child("products").equalTo("car");
//Query query = FirebaseDatabase.instance.reference().child("product").orderByChild("productCategory").equalTo(productCategory.text);
    FirebaseDatabase.instance.reference().keepSynced(true);
    Query postedRef = FirebaseDatabase.instance
        .reference()
        .child("product")
        .orderByChild("productCategory")
        .equalTo(widget.category);

    postedRef.once().then((DataSnapshot snap) {
      widget.KEYS = snap.value.keys;
      var DATA = snap.value;
      print(snap.value.keys);
      postedProducts.clear();
      if (widget.KEYS != null) {
        for (var individualKey in widget.KEYS) {
          if (DATA[individualKey]['privilege'] == user.email) {
            check = true;
            PostVar postVar = PostVar(
                DATA[individualKey]['productName'],
                DATA[individualKey]['productDescription'],
                DATA[individualKey]['productPrice'],
                DATA[individualKey]['productCategory'],
                DATA[individualKey]['image_0'],
                DATA[individualKey]['image_1'],
                DATA[individualKey]['image_2'],
                DATA[individualKey]['vendro'],
                individualKey.toString(),
                DATA[individualKey]['vendorPhone']);
            postedProducts.add(postVar);
          }
        }
      } else {
        print("No product posted in this category");
      }
      setState(() {
        print("Lenght: ${postedProducts.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Query postedRef = FirebaseDatabase.instance
        .reference()
        .child("product")
        .orderByChild("productCategory")
        .equalTo(widget.category);
    return SafeArea(
      child: Scaffold(
        backgroundColor: background_2,
//      appBar: AppBar(
//        backgroundColor: Colors.grey.shade500,
//        title: Text(widget.category),
//      ),

        body: Container(

          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      child:
                      Text(
                        widget.category,
                        style: TextStyle(
                            color: fontWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: StreamBuilder(
                    stream: postedRef.onValue,
                    builder: (context, snapshot) {
                      if(snapshot.data!=null) {
                        Map map = snapshot.data.snapshot.value;
                        return GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: map.values.toList().length,
                            padding: EdgeInsets.all(5),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onLongPress: () {
                                  print("Delete");
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Are you sure you want to delete!!'),
                                          actions: <Widget>[
                                            RaisedButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("product")
                                                    .child(map.keys.toList()[index].toString())
                                                    .remove();

                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                            RaisedButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },

                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Card(
                                          child: GridTile(
                                            child: FadeInImage(
                                              placeholder:
                                              AssetImage('assets/images/men1.jpeg'),
                                              image: NetworkImage(map.values.toList()[index]['image_0']),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        map.values.toList()[index]['productName'],
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('${map.values.toList()[index]['productPrice']} ETB'.toString(),
                                          style: TextStyle(
                                              color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                      return Center(
                          child: Text("No product")
                      );
                    }
                  )



                ),
              )
            ],
          ),
        )
        , floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Post(widget.category)));
//
//                    },
      },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: background_2,),
      ),
    );
  }
}

