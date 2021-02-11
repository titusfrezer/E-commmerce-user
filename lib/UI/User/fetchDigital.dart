import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:random_string/random_string.dart';
import 'package:vendor/LoginScreen.dart';
import 'package:vendor/UI/User/viewDigital.dart';
import 'package:vendor/variables/vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

var isCorrectCode = false;
var dir;
var testdir;
var Generatedcode;
FirebaseUser user;
String date;
FirebaseAuth _auth;
DatabaseReference reqRef;
DatabaseReference cartRef = FirebaseDatabase.instance.reference().child("cart");
var percentage = "0%";

class fetchDigital extends StatefulWidget {
  var KEYS;
String userPhone;
String userName;

fetchDigital(this.userPhone,this.userName);
  @override
  _fetchDigitalState createState() => _fetchDigitalState();
}

class _fetchDigitalState extends State<fetchDigital> {
  List<DigitalVar> digitalProducts = [];

  void getPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    user = await _auth.currentUser();
  }

  void initState() {
    super.initState();
    getPermission();
    DatabaseReference digitalProduct =
    FirebaseDatabase.instance.reference().child("DigitalDocument");
    _auth = FirebaseAuth.instance;

    digitalProduct.once().then((DataSnapshot snap) {
      widget.KEYS = snap.value.keys;

      var DATA = snap.value;

      digitalProducts.clear();
      if (widget.KEYS != null) {
        for (var individualKey in widget.KEYS) {
          DigitalVar digitalVar = DigitalVar(
              DATA[individualKey]['Name'],
              DATA[individualKey]['detail'],
              DATA[individualKey]['postedBy'],
              DATA[individualKey]['price'],
              (DATA[individualKey]['size']) / 1000,
              DATA[individualKey]['pdfUrl'],
              DATA[individualKey]['imageUrl'],
              individualKey.toString());

          digitalProducts.add(digitalVar);
        }
      } else {
        print("No product posted in this category");
      }
      setState(() {
        print("Lenght: ${widget.KEYS}");
      });
    });
    date = DateTime
        .now()
        .day
        .toString() +
        DateTime
            .now()
            .month
            .toString() +
        DateTime
            .now()
            .year
            .toString();
    reqRef = FirebaseDatabase.instance.reference().child("Requests");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: background_2,
      appBar: AppBar(
        title: Text(
          "Digital documents",
          style: TextStyle(
              color: fontWhite, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: background_2,
      ),
      body: Container(
        color: Colors.white,
        child: widget.KEYS != null
            ? GridView.builder(
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                itemCount: digitalProducts.length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return SingleDigital(
                      digitalProducts[index].productName,
                      digitalProducts[index].productDescription,
                      digitalProducts[index].productPrice,
                      digitalProducts[index].pdfUrl,
                      digitalProducts[index].imageUrl,
                      digitalProducts[index].size,
                      digitalProducts[index].key.toString(),
                      digitalProducts[index].vendorPhone,widget.userName,widget.userPhone);
                })
            : Center(child: Text("No Product")),
      ),
    ));
  }
}

class DigitalVar {
  String productName, productDescription, vendorPhone, productPrice, pdfUrl,imageUrl;
  double size;

  var key;

  DigitalVar(
    this.productName,
    this.productDescription,
    this.vendorPhone,
    this.productPrice,
    this.size,
    this.pdfUrl,
    this.imageUrl,
    this.key,

  );
}

class SingleDigital extends StatefulWidget {
  @override
  _SingleDigitalState createState() => _SingleDigitalState();
  final String productName;
  final String productDescription;
  final String vendorPhone;
  final String productPrice;
  final double size;
  final String pdfUrl;
  final String imageUrl;
  final String ke;
  final String userName;
  final String userPhone;
  SingleDigital(this.productName, this.productDescription, this.productPrice,
      this.pdfUrl,this.imageUrl, this.size, this.ke, this.vendorPhone,this.userName,this.userPhone);
}

class _SingleDigitalState extends State<SingleDigital> {
  @override
  Widget build(BuildContext context) {
    print("key is ${widget.ke}");
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () async {
//
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SingleBookDetail(
                    widget.productName,
                    widget.productDescription,
                    widget.productPrice,
                    widget.vendorPhone,
                    widget.userName,
                    widget.userPhone,
                    widget.pdfUrl,
                    widget.imageUrl,
                    widget.size)));
            print("Product Pressed! price ");
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: background_2,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridTile(
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.productName,
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                  '${widget.productPrice} ETB'.toString(),
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        child: FadeInImage(
                         placeholder: AssetImage('assets/images/pdf.png'),
                         image: NetworkImage(
                           widget.imageUrl
                         ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

_showSnackBar(String content) {
  final snackBar =
      SnackBar(content: Text(content), duration: Duration(seconds: 3));

  _scaffoldkey.currentState.showSnackBar(snackBar);
}

class SingleBookDetail extends StatefulWidget {
  @override
  _SingleBookDetailState createState() => _SingleBookDetailState();
  final String bookName;
  final String bookDescription;
  final String bookPrice;
  final String vendorPhone;
  final String pdfUrl;
  final String imageUrl;
  final double bookSize;
  final String userName;
  final String userPhone;
  SingleBookDetail(this.bookName, this.bookDescription, this.bookPrice,
      this.vendorPhone,this.userName,this.userPhone,this.pdfUrl,this.imageUrl, this.bookSize);
}

class _SingleBookDetailState extends State<SingleBookDetail> {
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_2,
      appBar: AppBar(
        title: Text('Download Book'),
        backgroundColor: background_2,
      ),
      body: ListView(
//              mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Container(

            alignment: Alignment.center,
            child: Container(

              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/images/pdf.png"),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50)),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Book Title :',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      Text(
                        "${widget.bookName}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ],
                  )
                ),
                Expanded(
                    child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(50))),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    "${widget.bookPrice} br",
                    style: TextStyle(fontSize: 18),
                  ),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),

            Container(
              height: 120,
              child: SingleChildScrollView(

                scrollDirection: Axis.vertical,

                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                    Text('Description---',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                    Text('${widget.bookDescription}',style: TextStyle(color:Colors.white),)
                      ],
                    )

                  ),

              ),
            ),

          SizedBox(
            height: 25,
          ),
           FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                 return  Padding(
                        padding: const  EdgeInsets.symmetric(horizontal: 80),
                        child: RaisedButton(shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                        ),
                    child: ListTile(trailing: Icon(Icons.file_download),title: Text('Download',style: TextStyle(fontSize: 15),),),
                    onPressed: () async {
                        user = await _auth.currentUser();
                        Generatedcode = randomAlphaNumeric(5);
                        if (snapshot.hasData) {
                          print('User Logged In');
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
                              if (check[i]['confirmationCode'].toString() ==
                                  Generatedcode) {
                                Generatedcode = randomAlphaNumeric(5);
                                check.add(Generatedcode);
                                i = 0;
                              }
                            }
                          }

                          await reqRef.push().set(<dynamic, dynamic>{
                            'confirmationCode': Generatedcode,
                            'email': user.email,
                            'postedBy': widget.vendorPhone,
                            'productName': widget.bookName,
                            'requestedFrom': widget.userPhone,
                            'userName': widget.userName,
                            'date': date,
                            'price': widget.bookPrice
                          });

                          //   _showSnackBar('Enter your confirmation code');

                          print("code: $Generatedcode, userphone:${widget.userPhone},suername : ${widget.userName}");
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InsertCode(widget.bookName,
                                  widget.bookPrice, widget.pdfUrl,widget.imageUrl, user.email,widget.userPhone,widget.userName)));
                        } else {
                          print('not Logged in');
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        }
                    },
                  ),
                      );
                }),

        ],
      ),
    );
  }
}

class InsertCode extends StatefulWidget {
  final String bookName;
  final String bookPrice;
  final String bookUrl;
  final String imageUrl;
  final String userEmail;
  var keytoDelete;
  final String userPhone;
  final String userName;

  InsertCode(this.bookName, this.bookPrice, this.bookUrl,this.imageUrl, this.userEmail,this.userPhone,this.userName);

  @override
  _InsertCodeState createState() => _InsertCodeState();
}

class _InsertCodeState extends State<InsertCode> {
  TextEditingController controller = TextEditingController();

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var dio = Dio();

  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);

      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    setState(() {
      if (total != -1) {
        percentage = ((received / total * 100).toStringAsFixed(0) + "%");
        print(percentage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(0, 0, 0,5),
//      borderRadius: BorderRadius.circular(20.0),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: background_2,
        title: Text('Confirm'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
//
          SizedBox(height: 30,),
            Container(
              child: GestureDetector(
                onTap: () => UrlLauncher.launch('tel:0936377294'),
                child: Center(
                  child: Column(
                    children: <Widget>[Text("Call Admin",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),), Text('0936377294',style: TextStyle(fontWeight: FontWeight.bold),)],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Column(
              children: <Widget>[
                Container(

                  width: 200,
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: PinPut(
                    autofocus: true,
                    withCursor: true,
                    textStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    submittedFieldDecoration:  pinPutDecoration.copyWith(color: Colors.white),
                    onSubmit: (value) async {
                      if (Generatedcode == value) {
                        print("equal with Generated code ie${Generatedcode}");
                        if (counter == 0) {
                          print("added to cart");
                          await cartRef.push().set(<dynamic, dynamic>{
                            'productName': widget.bookName,
                            'productPrice': widget.bookPrice,
                            'productImage': widget.imageUrl,
                            'email': widget.userEmail,
                          });
                        }
                        dir = await getExternalStorageDirectory();
                        bool checkDirectory =
                            await Directory('${dir.path}/Afroel').exists();
                        if (!checkDirectory) {
                          testdir = await Directory('${dir.path}/Afroel')
                              .create(recursive: true);
                        } else {
                          testdir = await Directory('${dir.path}/Afroel');
                        }
                        String fullPath =
                            "${testdir.path}/${widget.bookName}.pdf";
                        print('full path is ${fullPath}');
                        print('url is ${widget.bookUrl}');
                        await download(dio, widget.bookUrl, fullPath);
//                      _showSnackBar('Downloaded');
//                        await reqRef.limitToLast(1).once().then((DataSnapshot snapshot){
//                          Map map = snapshot.value;
//                          widget.keytoDelete = map.keys.toList()[0];
//                          print(widget.keytoDelete);
//                          reqRef.child(widget.keytoDelete).remove();
//                        });

                        print("confirmed");


                        var testdir2 = await Directory('${dir.path}/Afroel');
                        print("path is ${testdir2.path}");
                        var fm = FileManager(root: Directory(testdir2.path));
                        var files = await fm.filesTree(

                            extensions: ["pdf"] //optional, to filter files, list only pdf files

                        );
                        print("the file is $files");
                        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>ViewDigital(files)));
//
                      } else {

                        return _showSnackBar('Error Confirmation Code');
//                        print("Error confirmation code");
                      }
                    },

                    controller: controller,
                    fieldsCount: 5,

//                    animationDuration: Duration(milliseconds: 300),

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
                  child: percentage == "99%"
                      ? Text(
                          "Clear",
                          style: TextStyle(color: fontWhite),
                        )
                      : Text("$percentage", style: TextStyle(color: fontWhite)),
                  color: background_2,
                ),
              ],
            ),
            Image.asset("assets/images/download.jpg"),
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
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          Text(
            'Thank you for Purchasing',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Icon(
            Icons.check,
            color: background,
            size: 70,
          )
        ],
      )),
    );
  }
}
