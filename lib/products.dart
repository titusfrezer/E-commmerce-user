import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vendor/fromDatabase.dart';

var proKey;
List<Product> proValue=[];
DatabaseReference productRef;
class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("val $proValue");
    productRef = FirebaseDatabase.instance.reference().child("product");
  productRef.once().then((DataSnapshot snapshot){
    print('${snapshot.value}');
  });
//    fetchProduct();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: productRef.once().then((DataSnapshot snap) {
          return snap.value;
        }),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return Container(
                child: Text(
                    "You don't have any notes"
                ));
          }

          return Text('you have data but i don"t know how to display');
        });
  }
}
//  Future<List> fetchProduct() async{
//
//    await
//    print(proValue);
//return proValue.toList();
//  }
//}
