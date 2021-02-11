import 'dart:io';
import 'dart:ui';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vendor/UI/Admin/Favourites.dart';
import 'package:vendor/UI/User/About.dart';
import 'package:vendor/UI/User/Help.dart';
import 'package:vendor/UI/User/SingleProductDetail.dart';
import 'package:vendor/UI/User/fetchDigital.dart';
import 'package:vendor/UI/User/viewDigital.dart';
import 'package:vendor/auth_service.dart';
import 'package:vendor/variables/Categories2.dart';
import 'package:vendor/variables/CategoriesVendor.dart';
import 'package:vendor/variables/cart.dart';
import 'package:vendor/variables/vars.dart';


FirebaseAuth _auth;
FirebaseUser user;
List<String> carouselImage = List();

var connectivity;
String userPhone;
String userName;

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  DatabaseReference productRef =
      FirebaseDatabase.instance.reference().child("product");

  var connectivity;
  var dir;
  var files;
  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await (Connectivity().checkConnectivity());

    print(user.email.toString());
  }


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();


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
//        print("${snapshot.value} is the value");
//        queryResultSet.add(snapshot.value);
      });
    } else {
      print('titusfrezer');
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
getFiles()async {
   dir = await getExternalStorageDirectory();
   bool checkDirectory =
   await Directory('${dir.path}/Afroel').exists();
   if(checkDirectory){
     var testdir = await Directory('${dir.path}/Afroel');
     print("path is ${testdir.path}");
     var fm = FileManager(root: Directory(testdir.path));
     files = await fm.filesTree(

         extensions: ["pdf"] //optional, to filter files, list only pdf files

     );
   }

}
  bool searchVisible = false;

  @override
  Widget build(BuildContext context) {
    print(carouselImage);
    double searchWidth = MediaQuery.of(context).size.width;
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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                child: FutureBuilder(
                  future: _auth.currentUser(),
                      builder: (context,AsyncSnapshot snapshot){
                    return ClipRect(
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/ecorp-lightblue.png'),
                                  fit: BoxFit.cover)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                            child: UserAccountsDrawerHeader(
                              decoration:
                              BoxDecoration(color: Colors.transparent),
                              accountName: CircleAvatar(
                                  backgroundColor: background_2,
                                  foregroundColor: background,
                                  child: Text(user.email
                                      .substring(0, 1)
                                      .toUpperCase())),
                              accountEmail: Text(
                                user.email,
                                style: TextStyle(
                                    color: background_2,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )),
                    );}
                        )
    ),

              InkWell(
                  child: ListTile(
                leading: Icon(
                  Icons.history,
                  color: background,
                ),
                title: Text('Order History'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Cart()));
                },
              )),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: background,
                  ),
                  title: Text('My posted products'),
                  onTap: () {
                    // CategoriesVendor();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesVendor()));
                  },
                ),
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
                child: ListTile(
                  leading: Icon(
                    Icons.pageview,
                    color: background,
                  ),
                  title: Text('see Documents'),
                  onTap: () async{
                   getFiles();
//                   dir = await getExternalStorageDirectory();
//                   bool checkDirectory =
//                   await Directory('${dir.path}/Afroel').exists();
//                   if(checkDirectory){
//                     var testdir = await Directory('${dir.path}/Afroel');
//                     print("path is ${testdir.path}");
//                     var fm = FileManager(root: Directory(testdir.path));
//                     files = await fm.filesTree(
//
//                         extensions: ["pdf"] //optional, to filter files, list only pdf files
//
//                     );
//                   }
                    // CategoriesVendor();
                   print("the files is ${files}");
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewDigital(files)));
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Favorites()));
                },
                child: ListTile(
                  leading: Icon(Icons.favorite_border, color: background),
                  title: Text('Favorites'),
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
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Are your sure?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                AuthService().signOut();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
                child: ListTile(
                    leading: Icon(
                      Icons.visibility_off,
                      color: background,
                    ),
                    title: Text("Log Out")),
              ),
            ],
          ),
        ),
        backgroundColor: background_2,
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
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
                decoration: InputDecoration(icon: Icon(Icons.search,color: fontWhite,),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.transparent)),
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
                            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                          Container(height: 250, child: Categories2()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
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



class carouselVar {
  String image;

  carouselVar(this.image);
}
