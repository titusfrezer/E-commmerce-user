//
//
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_sorted_list.dart';
//import 'package:flutter/material.dart';
//import 'package:vendor/UI/Admin/Post.dart';
//import 'package:vendor/UI/User/SingleProductDetail.dart';
//import 'package:vendor/variables/PostVar.dart';
//import 'package:vendor/variables/vars.dart';
//
//class ProductList extends StatefulWidget {
//  final String category;
//  var KEYS;
//  ProductList(this.category);
//
//  @override
//  _ProductListState createState() => _ProductListState();
//}
//
//class _ProductListState extends State<ProductList> {
//  List<PostVar> postedProducts = [];
//  void initState(){
//    super.initState();
//    print("The category is ${widget.category}");
//    //Query query = FirebaseDatabase.instance.reference().child("products").equalTo("car");
////Query query = FirebaseDatabase.instance.reference().child("product").orderByChild("productCategory").equalTo(productCategory.text);
//    FirebaseDatabase.instance.reference().keepSynced(true);
//    Query  postedRef = FirebaseDatabase.instance.reference().child("product").orderByChild("productCategory").equalTo(widget.category);
//
//
//    postedRef.once().then((DataSnapshot snap){
//      widget.KEYS = snap.value.keys;
//      var DATA = snap.value;
//      print(snap.value.keys);
//      postedProducts.clear();
//      if (widget.KEYS!=null) {
//        for (var individualKey in widget.KEYS) {
//          PostVar postVar =
//          PostVar(
//
//              DATA[individualKey]['productName'],
//              DATA[individualKey]['productDescription'],
//              DATA[individualKey]['productPrice'],
//              DATA[individualKey]['productCategory'],
//              DATA[individualKey]['image_0'],
//              DATA[individualKey]['image_1'],
//              DATA[individualKey]['image_2'],
//              //DATA[individualKey]['image_3'],
//              individualKey.toString()
//          );
//          postedProducts.add(postVar);
//
//        }
//      }
//      else {
//        print("No product posted in this category");
//      }
//      setState(() {
//        print("Lenght: ${postedProducts.length}");
//      });
//    });
//  }
//
////  var products = [
////    {
////      "Product Name": "Men",
////      "Product Descripton": "The most straightforward way to achieve mutual. exclusion in a distributed system is to simulate how it is done in a one-processor system. One process is elected as the coordinator. Whenever a process wants to access a shared resource, it sends a request message to the coordinator stating which resource it wants to access and asking for permission. If no other process is currently accessing that resource, the coordinator sends back a reply granting permission, as shown in Fig.6-14(a). When the reply arrives, the requesting process can go ahead.",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menWatch.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Perfume",
////      "Product Descripton": "Describe",
////      "Product Price": 300,
////      "Product Image_1": "assets/images/menWatch.jpeg",
////      "Product Image_2": "assets/images/menPerfume.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Watch",
////      "Product Descripton": "Describe",
////      "Product Price": 120,
////      "Product Image_1": "assets/images/men1.jpeg",
////
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/menPerfume.jpeg",
////      "Product Image_4": "assets/images/Images/men1.jpeg"
////    },
////    {
////      "Product Name": "Men",
////      "Product Descripton": "Describe",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menPerfume.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Men",
////      "Product Descripton": "Describe",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menPerfume.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Men",
////      "Product Descripton": "The most straightforward way to achieve mutual. exclusion in a distributed system is to simulate how it is done in a one-processor system. One process is elected as the coordinator. Whenever a process wants to access a shared resource, it sends a request message to the coordinator stating which resource it wants to access and asking for permission. If no other process is currently accessing that resource, the coordinator sends back a reply granting permission, as shown in Fig.6-14(a). When the reply arrives, the requesting process can go ahead.",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menPerfume.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Perfume",
////      "Product Descripton": "Describe",
////      "Product Price": 300,
////      "Product Image_1": "assets/images/menWatch.jpeg",
////      "Product Image_2": "assets/images/menPerfume.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Watch",
////      "Product Descripton": "Describe",
////      "Product Price": 120,
////      "Product Image_1": "assets/images/men1.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/menPerfume.jpeg",
////      "Product Image_4": "assets/images/Images/men1.jpeg"
////    },
////    {
////      "Product Name": "Men",
////      "Product Descripton": "Describe",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menPerfume.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////    {
////      "Product Name": "Men",
////      "Product Descripton": "Describe",
////      "Product Price": 200,
////      "Product Image_1": "assets/images/menPerfume.jpeg",
////      "Product Image_2": "assets/images/menWatch.jpeg",
////      "Product Image_3": "assets/images/men1.jpeg",
////      "Product Image_4": "assets/images/men1.jpeg"
////    },
////  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: background_2,appBar: AppBar(
//      title:Text(widget.category) ,
//    ),
//      body:widget.KEYS!=null ?GridView.builder(
//          scrollDirection: Axis.vertical,
//          itemCount: postedProducts.length,
//          padding: EdgeInsets.all(5),
//          gridDelegate:
//          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//          itemBuilder: (BuildContext context, int index) {
//            return SingleCategory(
//
//              postedProducts[index].productName,
//              postedProducts[index].productDescription,
//              postedProducts[index].productPrice,
//              postedProducts[index].productCategory,
//              postedProducts[index].image_0,
//              postedProducts[index].image_1,
//              postedProducts[index].image_2,
//              postedProducts[index].image_3,
//              postedProducts[index].key.toString(),
//            );
//          }):Center(child: Text('No product')),
//    );
//  }
//}
//class SingleCategory extends StatefulWidget {
//  @override
//  _SingleCategoryState createState() => _SingleCategoryState();
//  final String productName;
//  final String productDescription;
//  final int productPrice;
//  final String productCategory;
//  final String productImage_0;
//  final String productImage_1;
//  final String productImage_2;
//  //final String productImage_3;
//  final String ke;
//  SingleCategory(
//      this.productName,
//      this.productDescription,
//      this.productPrice,
//      this.productCategory,
//      this.productImage_0,
//      this.productImage_1,
//      this.productImage_2,
//      this.productImage_3,
//      this.ke
//      );
//}
//
//class _SingleCategoryState extends State<SingleCategory> {
//
//  @override
//  Widget build(BuildContext context) {
//    print("key is ${widget.ke}");
//    return Scaffold(
//      backgroundColor: background_2,
//      body: widget.ke.isEmpty? Center(child: Text('No product')):Card(
//          child: GestureDetector(
//            onLongPress: (){
//              print("delete");
//              return showDialog(context: context,builder:(context){
//                return AlertDialog(
//                  title: Text('Are you sure this can not be done'),
//                  actions: <Widget>[
//                    RaisedButton(
//                      child: Text('Yes'),
//                      onPressed: () {
//                        FirebaseDatabase.instance.reference().child("product").child(widget.ke).remove();
//                        widget.ke.isEmpty==true;
//                        setState(() {
//                          Navigator.of(context).pop();
//                        });
//
//                      },
//                    ),
//                    RaisedButton(
//                      child:Text('No'),
//                      onPressed: (){
//                        Navigator.of(context).pop();
//                      },
//                    )
//                  ],
//
//                );
//              });
//
//
//
//            },
//            child: InkWell(
//
//              onTap: () {
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (context) => SingleProductDetail(
//                        widget.productName,
//                        widget.productDescription,
//                        widget.productPrice,
//                        widget.productCategory,
//                        widget.productImage_0,
//                        widget.productImage_1,
//                        widget.productImage_2,
//                        widget.productImage_3)));
//                print("Product Pressed! price ");
//              },
//              child: GridTile(
//                  footer: Container(
//                    color: Colors.white54,
//                    height: 50,
//                    child: ListTile(
//                      trailing: Text(
//                        '${widget.productPrice} ETB'.toString(),
//                        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.red),
//                      ),
//                      title: Text(
//                        widget.productName,
//                        style: TextStyle(fontWeight: FontWeight.w800),
//                      ),
//                    ),
//                  ),
//                  child:FadeInImage(
//                    placeholder:AssetImage('assets/images/men1.jpeg') ,
//                    image: NetworkImage(widget.productImage_0),
//                    fit:BoxFit.cover,
//                  )
//                // Image.network(productImage_0)
//              ),
//            ),
//          )),
//    );
//  }
//}
//
