import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:vendor/UI/Admin/Post.dart';
import 'package:vendor/UI/User/SingleProductDetail.dart';
import 'package:vendor/variables/PostVar.dart';
import 'package:vendor/variables/vars.dart';

class ProductList2 extends StatefulWidget {
  final String category;
  var KEYS;

  ProductList2(this.category);

  @override
  _ProductList2State createState() => _ProductList2State();
}

class _ProductList2State extends State<ProductList2> {
  List<PostVar> postedProducts = [];
  FirebaseAuth _auth;
  FirebaseUser user;
  getCurrentUser() async{
    user = await _auth.currentUser();
    print(user.email.toString());
  }
  void initState() {
    super.initState();
    _auth=FirebaseAuth.instance;
    getCurrentUser();

    print("The category is ${widget.category}");

    FirebaseDatabase.instance.reference().keepSynced(true);

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
          appBar: AppBar(title:  Text(
            widget.category,
            style: TextStyle(
                color: fontWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
            backgroundColor: background_2,

          ),
          body:   Container(
            color: Colors.white,
            child: StreamBuilder(
              stream:postedRef.onValue ,
              builder: (context, snapshot) {
                if(snapshot.data!=null) {
                  print(snapshot.hasData);
                  Map  map = snapshot.data.snapshot.value;
                  return Container(
                      color: Colors.white,
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: map.values.toList().length,
                          padding: EdgeInsets.all(5),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
//                              onLongPress: () {
//                                print("Delete");
//                                return showDialog(
//                                    context: context,
//                                    builder: (context) {
//                                      return AlertDialog(
//                                        title: Text('Are you sure you want to delete!!'),
//                                        actions: <Widget>[
//                                          RaisedButton(
//                                            child: Text('Yes'),
//                                            onPressed: () {
//                                              setState(() {
//                                                FirebaseDatabase.instance
//                                                    .reference()
//                                                    .child("product")
//                                                    .child(map.values.toList()[index])
//                                                    .remove();
//                                              });
//                                              Navigator.of(context).pop();
//                                            },
//                                          ),
//                                          RaisedButton(
//                                            child: Text('No'),
//                                            onPressed: () {
//                                              Navigator.of(context).pop();
//                                            },
//                                          )
//                                        ],
//                                      );
//                                    });
//                              },
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SingleProductDetail(
                                        map.values.toList()[index]['productName'],
                                        map.values.toList()[index]['productDescription'],
                                        map.values.toList()[index]['productPrice'],
                                        map.values.toList()[index]['productCategory'],
                                        map.values.toList()[index]['image_0'],
                                        map.values.toList()[index]['image_1'],
                                        map.values.toList()[index]['image_2'],
                                        map.values.toList()[index]['vendorPhone']
                                    )));
                                print("Product Pressed! price ");
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
                          })



                );
              }
                return  Center(
                child: Text("No product posted yet"));
              }
            ),
          ),

           floatingActionButton: FloatingActionButton(onPressed: () {
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

