import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/variables/vars.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  DatabaseReference cartRef =
      FirebaseDatabase.instance.reference().child("cart");

  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;

  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await (Connectivity().checkConnectivity());

    print(user.email.toString());
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var counter = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background_2,
        title: Text('Order History'),
      ),
      body: StreamBuilder(
          stream: cartRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

              return ListView.builder(
                itemCount: map.values.toList().length,
                itemBuilder: (context, int index) {
                  if (map.values.toList()[index]['email'] == user.email) {
                    counter++;
                    return Dismissible(
                      background: Container(
                        child: Center(child: Text('Delete')),
                        color: Colors.red,
                      ),
                      key: Key(map.values.toList()[index].toString()),
                      confirmDismiss: (DismissDirection direction) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                  ),
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child("cart")
                                          .child(map.keys.toList()[index])
                                          .remove();
                                      Navigator.of(context).pop();

                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: ListTile(
                        trailing: Icon(Icons.history,color: background,),
                        title: Text(map.values.toList()[index]['productName']),
                        subtitle: Text(map.values
                            .toList()[index]['productPrice']
                            .toString()),
                        leading: map.values.toList()[index]['productImage'] !=
                                null
                            ? FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/men1.jpeg'),
                                image: NetworkImage(
                                    map.values.toList()[index]['productImage']),
                              )
                            : Image.asset('assets/images/pdf.png'),
                      ),
                    );
                  }
                  return Container();
                },
              );
            }
            return SpinKitWave(
              color: background,
              size: 25,
            );
          }),
    );
  }
}
//    return Scaffold(
//      appBar:AppBar(
//        title:Text('Cart')
//      ) ,
//      body:
//    );
