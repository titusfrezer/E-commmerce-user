import 'package:flutter/material.dart';
import 'package:vendor/UI/Admin/PostOnSpecificCategory.dart';
import 'package:vendor/variables/ProductList.dart';
import 'package:vendor/variables/vars.dart';

class PostedProductList extends StatefulWidget {
  final String categoryName;
  PostedProductList(this.categoryName);
  @override
  _PostedProductListState createState() => _PostedProductListState();
}

class _PostedProductListState extends State<PostedProductList> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background_2,
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: Colors.white24,
                padding: EdgeInsets.fromLTRB(30, 15, 20, 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                              color: fontWhite,
                              fontSize: fontHeader,
                              fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () {},
                          color: fontWhite,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: appbarHeightSmaller ,
                height: MediaQuery.of(context).size.height - appbarHeightSmaller,
                width: MediaQuery.of(context).size.width,


                  child: ListView(
                    scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height - appbarHeightSmaller,
                        padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                        decoration: BoxDecoration(
                            color: fontWhite,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))
                        ),
                        child: ProductList(widget.categoryName)
                    ),
                  ],
                  ),

              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: background_2,child: Icon(Icons.add,color: fontWhite,),onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PostOnSpecificCategory(widget.categoryName)))),
      ),
    );
  }
}
