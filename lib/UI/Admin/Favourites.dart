import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/variables/vars.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
  var keys;
}

class _FavoritesState extends State<Favorites> {
  DatabaseReference reqWish = FirebaseDatabase.instance.reference().child(
      "WishList");

  List<FavouriteVar> favouriteList=[];
  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;

  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await(Connectivity().checkConnectivity());

    print(user.email.toString());
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
    reqWish.once().then((DataSnapshot snapshot)  {
      if (snapshot.value != null) {
        widget.keys = snapshot.value.keys;
        var DATA = snapshot.value;
        favouriteList.clear();
        for (var individualkey in widget.keys) {
           FavouriteVar fav =
          FavouriteVar(
              DATA[individualkey]['productImage'],
              DATA[individualkey]['productName'],
              DATA[individualkey]['productPrice'].toString(),
              DATA[individualkey]['email'],
              individualkey.toString()
          );
          favouriteList.add(fav);
          print(favouriteList.length);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("this is the lenght ${favouriteList.length}");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: background_2,
          title: Text("Favorites"),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
          child:StreamBuilder(
            stream: reqWish.onValue,
            builder: (context, snapshot) {
              if(snapshot.hasData){
              return ListView.builder(
                    itemCount: favouriteList.length,
                    itemBuilder: (context, int index) {
                      if (favouriteList[index].email == user.email) {
                        print(favouriteList[index].email);
                        return Dismissible(
                          key: Key(favouriteList[index].individualkey),
                          confirmDismiss: (direction) {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Are you sure you want to delete!!'),
                                    actions: <Widget>[
                                      RaisedButton(
                                          child: Text('Yes'),
                                          onPressed: () {
                                            print("${favouriteList[index].individualkey}is key");
                                            setState(() {
                                              FirebaseDatabase.instance.reference()
                                                  .child("WishList")
                                                  .child(favouriteList[index]
                                                  .individualkey).remove();
                                            });

                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }),
                                      RaisedButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                    ],
                                  );
                                });
                          },
                          child: ListTile(
                            leading: FadeInImage(placeholder: AssetImage(
                                'assets/images/ecorp-lightblue.png'),
                                image: NetworkImage(
                                    favouriteList[index].productImage)),
                            title: Text(
                                favouriteList[index].productName),
                            subtitle: Text(
                                favouriteList[index].productPrice.toString()),
                            trailing: Icon(Icons.favorite, color: background,),

                          ),
                        );
                      }
                      return Container();
                    });}return SpinKitWave(
                color: background,
                size: 25,
              );
            }
          )));
  }
}


class FavouriteVar {
  String productImage;
  String productName;
  String productPrice;
  String email;
  String individualkey;

  FavouriteVar(this.productImage, this.productName, this.productPrice,
      this.email, this.individualkey);
}
