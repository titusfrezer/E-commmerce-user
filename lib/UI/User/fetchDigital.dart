import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vendor/variables/vars.dart';

var dir;
var testdir;
class fetchDigital extends StatefulWidget {
  var KEYS;

  @override
  _fetchDigitalState createState() => _fetchDigitalState();
}

class _fetchDigitalState extends State<fetchDigital> {
  List<DigitalVar> digitalProducts = [];
    void initState(){
      super.initState();
      DatabaseReference digitalProduct = FirebaseDatabase.instance.reference().child("DigitalDocument");

      digitalProduct.once().then((DataSnapshot snap) {
        widget.KEYS = snap.value.keys;

        var DATA = snap.value;

        digitalProducts.clear();
        if (widget.KEYS != null) {
          for (var individualKey in widget.KEYS) {

            DigitalVar digitalVar = DigitalVar(
                DATA[individualKey]['Name'],
                DATA[individualKey]['detail'],
                int.parse(DATA[individualKey]['price']),
                DATA[individualKey]['url'],
                individualKey.toString(),
                DATA[individualKey]['postedBy']);
            digitalProducts.add(digitalVar);
          }



        } else {
          print("No product posted in this category");
        }
        setState(() {
          print("Lenght: ${digitalProducts.length}");
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key:_scaffoldkey,
          backgroundColor: background_2,
          appBar: AppBar(title:  Text(
           "Digital documetns",
            style: TextStyle(
                color: fontWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
            backgroundColor: background_2,),
          body: Container(
            color:Colors.white,
            child: widget.KEYS != null
                ? GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: digitalProducts.length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return SingleDigital(
                      digitalProducts[index].productName,
                      digitalProducts[index].productDescription,
                      digitalProducts[index].productPrice,
                      digitalProducts[index].url,
                      digitalProducts[index].key.toString(),
                      digitalProducts[index].vendorPhone
                  );
                })
                : Center(
                child: Text(
                    "No Product"
                )),

          ),
        )

    );
  }
}
class DigitalVar {
  String productName,productDescription,url;
  int productPrice;
  var key;
  String vendorPhone;
  DigitalVar(

      this.productName,
      this.productDescription,
      this.productPrice,
      this.url,
      this.key,
      this.vendorPhone
      );

}
class SingleDigital extends StatefulWidget {
  @override
  _SingleDigitalState createState() => _SingleDigitalState();
  final String productName;
  final String productDescription;
  final int productPrice;
  final String url;
  final String ke;
  final String vendorPhone;

  SingleDigital(
      this.productName,
      this.productDescription,
      this.productPrice,
      this.url,
      this.ke,
      this.vendorPhone);
}

class _SingleDigitalState extends State<SingleDigital> {

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
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
  @override
  Widget build(BuildContext context) {
    print("key is ${widget.ke}");
    return SafeArea(
      child: Scaffold(
        body:  widget.ke.isEmpty
            ? Center(
            child: SpinKitWave(
              size: 25,
              color: background_2,
              // controller: AnimationController(duration: Duration(seconds: 30), vs),
            ))
            : GestureDetector(
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
                              .child(widget.ke)
                              .remove();
                          widget.ke.isEmpty == true;
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
          onTap: () async{
            dir = await getExternalStorageDirectory();
            bool checkDirectory= await Directory('${dir.path}/Afroel').exists();
           if(!checkDirectory){
            testdir = await Directory('${dir.path}/Afroel').create(recursive: true);

           }
           else{
             testdir = await Directory('${dir.path}/Afroel');

           }
            String fullPath = "${testdir.path}/${widget.productName}.pdf";
            print('full path is ${fullPath}');
            await download(dio, widget.url, fullPath);
            _showSnackBar('Downloaded');
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => SingleProductDetail(
//                    widget.productName,
//                    widget.productDescription,
//                    widget.productPrice,
//                    widget.productCategory,
//                    widget.productImage_0,
//                    widget.productImage_1,
//                    widget.productImage_2,
//                    widget.vendorPhone
//
//                )));
//            print("Product Pressed! price ");
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Card(
                    child: GridTile(
                      child: Image.asset('assets/images/pdf.png')
                    )),
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
                child: Text('${widget.productPrice} ETB'.toString(),
                    style: TextStyle(
                        color: Colors.red)),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
final GlobalKey<ScaffoldState> _scaffoldkey=  GlobalKey<ScaffoldState>();

_showSnackBar(String content){
  final snackBar = SnackBar(
      content:Text(content),
      duration: Duration(seconds:3)
  );

  _scaffoldkey.currentState.showSnackBar(snackBar);

}