import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendor/UI/Admin/SpecificCategoryListVendor.dart';

import 'package:vendor/variables/ProductList.dart';
import 'package:vendor/variables/vars.dart';

class Categories extends StatefulWidget {
  Categories();

  @override
  _Categories createState() => _Categories();
}

class _Categories extends State<Categories> {
  DatabaseReference productRef =
      FirebaseDatabase.instance.reference().child("catagory");
  Color background_2 = Color(0XFF738989);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: productRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            //map.forEach((dynamic,category)=>print(category["type"]));
            //print("the map is ${map.values.toList()}");
            return GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: map.values.toList().length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductList(
                            map.values.toList()[index]["type"])));
                  },
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white24,


                                  child: GridTile(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                      child: FadeInImage(
                                        image: NetworkImage(
                                            map.values.toList()[index]["image"]),
                                        placeholder: AssetImage('assets/images/cart.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  )),
                        ),
                        Text(
                            map.values.toList()[index]["type"],overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
          return Center(
              child: SpinKitWave(
            size: 25,
            color: background,
            // controller: AnimationController(duration: Duration(seconds: 30), vs),
          ));
        });
  }
}
