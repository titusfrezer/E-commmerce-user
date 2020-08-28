import 'dart:ui';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/UI/Admin/Favourites.dart';
import 'package:vendor/UI/Admin/Post.dart';
import 'package:vendor/UI/Admin/SpecificCategoryListVendor.dart';
import 'package:vendor/UI/User/SingleProductDetail.dart';
import 'package:vendor/UI/User/fetchDigital.dart';
import 'package:vendor/UI/User/viewDigital.dart';
import 'package:vendor/auth_service.dart';
import 'package:vendor/variables/Categories2.dart';
import 'package:vendor/variables/CategoriesList.dart';
import 'package:vendor/variables/Categories.dart';
import 'package:vendor/variables/CategoriesVendor.dart';
import 'package:vendor/variables/cart.dart';
import 'package:vendor/variables/searchService.dart';
import 'package:vendor/variables/vars.dart';


FirebaseAuth _auth;
FirebaseUser user;
List<String> carouselImage = List();
var connectivity;

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  DatabaseReference productRef =
      FirebaseDatabase.instance.reference().child("product");

  var connectivity;

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


    productRef.once().then((DataSnapshot snapshot) async{
       connectivity = await(Connectivity().checkConnectivity());
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
    // var checkValue = value.substring(0,1).toUpperCase()+value.substring(1);
//    print("captiatl${captialValue}");
    // print("value${value.toString().length}");

    if (queryResultSet.isEmpty && value.toString().length == 1) {
      print("true");
      Query query = FirebaseDatabase.instance
          .reference()
          .child('product')
          .orderByChild('firstLetter')
          .equalTo(value.substring(0, 1));
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
        if (element['productName'].toString()[0] == value[0]) {
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
                    Icons.shopping_cart,
                    color: background,
                  ),
                  title: Text('Digital Documents'),
                  onTap: () {
                    // CategoriesVendor();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => fetchDigital()));
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: background,
                  ),
                  title: Text('see Documents'),
                  onTap: () {
                    // CategoriesVendor();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewDigital()));
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
class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: background_2,
      ),
      body:Column(
        children: <Widget>[
          Icon(
            Icons.live_help,
            size: 150,
          ),
          Text("Developer's Contact",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
           SizedBox(height: 20,),
          Column(children: <Widget>[
            GestureDetector(
            onTap:(){UrlLauncher.launch('tel:0924334695');},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.call),
                  Text('0924334695',style:TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
           onTap:(){UrlLauncher.launch('tel:0962491657');}
            ,child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.call),
                Text('0962491657',style:TextStyle(fontWeight: FontWeight.bold)),
              ],
            ))
          ],),
 SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Adminstrator's Contact",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              GestureDetector(
                child:Row(
                  children: <Widget>[
                    Icon(Icons.subdirectory_arrow_right),
                    Text('0936377294',style:TextStyle(fontWeight: FontWeight.bold,backgroundColor: Colors.grey.shade400)),
                  ],
                ),
                onTap: (){
                  UrlLauncher.launch('tel:0936377294');
                },
              )
            ],
          )

        ],
      )
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: background_2,
      ),
      body: Column(
        children: <Widget>[
          Icon(
            Icons.alternate_email,
            size: 150,
          ),
          Column(
            children: <Widget>[
              Container(child: Center(child: Text('Run by Digital Center ......'))),
              SizedBox(height: 20,),
              Container(child:Center(child:Padding(padding:EdgeInsets.all(10),child:Text('This app is designed and developed to meet your shoping interest:')))),
              SizedBox(height: 20,),
              Column(
                children: <Widget>[
                 Row(
                   children: <Widget>[
                     Icon(Icons.comment),
                     SizedBox(width: 10,),
                     Text('1 If you want to give comment on our service')
                   ],

                 ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.report_problem),
                      SizedBox(width: 10,),
                      Text('2 If you want to report any problem')
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(padding:EdgeInsets.all(20),child: Text("Don't hesitate to call us using the numbers listed in help section!!"))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class carouselVar {
  String image;

  carouselVar(this.image);
}
